//
//  ZJTagView.m
//  ZJTagView
//
//  Created by ZeroJ on 16/9/27.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJTagView.h"
#import "ZJTagViewCell.h"
#import "ZJTagHeaderView.h"

@interface ZJTagView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate> {
    NSIndexPath *_currentIndexPath;
    CGPoint _deltaPoint;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGesture;
@property (strong, nonatomic) NSMutableArray<ZJTagItem *> *selectedItems;
@property (strong, nonatomic) NSMutableArray<ZJTagItem *> *unselectedItems;

@property (strong, nonatomic) UIView *snapedImageView;

@end

// 系统状态
static NSString *const kCellID = @"kCellID";
static NSString *const kHeaderID = @"kHeaderID";

@implementation ZJTagView

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithSelectedItems:(NSArray<ZJTagItem *> *)selectedItems unselectedItems:(NSArray<ZJTagItem *> *)unselectedItems {
    if (self = [super init]) {
        _selectedItems = [selectedItems mutableCopy];
        _unselectedItems = [unselectedItems mutableCopy];
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _unselctedSectionTitle = @"  点击添加更多栏目";
    [self addSubview:self.collectionView];
    [self.collectionView addGestureRecognizer:self.panGesture];
    [self.collectionView addGestureRecognizer:self.longPressGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)panGes {
    CGPoint location = [panGes locationInView:self.collectionView];
    
    switch (panGes.state) {

        case UIGestureRecognizerStateBegan: {
            // 获取当前手指所在的cell
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_currentIndexPath];
            // 截取当前cell 保存为snapedImageView
            self.snapedImageView = [cell snapshotViewAfterScreenUpdates:NO];
            // 设置初始位置和当前cell一样
            self.snapedImageView.center = cell.center;
            // 隐藏当前cell
            cell.alpha = 0.f;
            // 记录当前手指的位置的x和y距离cell的x,y的间距, 便于同步截图的位置
            _deltaPoint = CGPointMake(location.x - cell.frame.origin.x, location.y - cell.frame.origin.y);
            // 放大截图
            self.snapedImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            // 添加截图到collectionView上
            [self.collectionView addSubview:self.snapedImageView];

        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            // 这种设置并不精准, 效果不好, 开始移动的时候有跳跃现象
//            self.snapedImageView.center = location;
            CGRect snapViewFrame = self.snapedImageView.frame;
            snapViewFrame.origin.x =  location.x - _deltaPoint.x;
            snapViewFrame.origin.y =  location.y - _deltaPoint.y;
            self.snapedImageView.frame = snapViewFrame;
            
            // 获取当前手指的位置对应的indexPath
            NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:location];
            if (newIndexPath &&  // 不为nil的时候
                newIndexPath.section == _currentIndexPath.section && // 只在同一个section中移动
                newIndexPath.row != 0 // 第一个不要移动
                ) {
                
                // 更新数据
               // 同一个section中, 需要将两个下标之间的所有的数据改变位置(前移或者后移)
                NSMutableArray *oldRows = [self.selectedItems mutableCopy];
                // 当手指所在的cell在截图cell的后面的时候
                if (newIndexPath.row > _currentIndexPath.row) {
                    // 将这个区间的数据都前后交换, 就能够达到 数组中这两个下标之间所有的数据都向前移动一位 并且currentIndexPath.row的元素移动到了newIndexPath.row的位置
                    for (NSInteger index = _currentIndexPath.row; index<newIndexPath.row; index++) {
                        [oldRows exchangeObjectAtIndex:index withObjectAtIndex:index+1];
                    }
                    
                    // 或者可以像下面这样来处理
                    // 缓存最初的元素
                    id tempFirst = oldRows[_currentIndexPath.row];
                    for (NSInteger index = _currentIndexPath.row; index<newIndexPath.row; index++) {
                        if (index != newIndexPath.row - 1) {
                            // 这之间的所有的元素前移一位
                            oldRows[index] = oldRows[index++];
                        }
                        else {
                            // 第一个元素移动到这个区间的最后
                            oldRows[index] = tempFirst;
                        }
                    }

                }
                if (newIndexPath.row < _currentIndexPath.row) {

                    for (NSInteger index = _currentIndexPath.row; index>newIndexPath.row; index--) {
                        [oldRows exchangeObjectAtIndex:index withObjectAtIndex:index-1];
                    }
                }
                // 先更新数据设置为交换后的数据
                self.selectedItems = oldRows;
                // 再移动cell
                [self.collectionView moveItemAtIndexPath:_currentIndexPath toIndexPath:newIndexPath];
                
                // 获取到新位置的cell
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:newIndexPath];
                // 设置为移动后的新的indexPath
                _currentIndexPath = newIndexPath;
                // 隐藏新的cell
                cell.alpha = 0.f;
            }
        }
            
            break;
        case UIGestureRecognizerStateEnded: {
            // 获取当前的cell
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_currentIndexPath];
            // 显示隐藏的cell
            cell.alpha = 1.f;
            // 删除cell的截图
            [self.snapedImageView removeFromSuperview];
            _currentIndexPath = nil;
        }
            
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    if (_inEditState) {
//        return 1;
//    }
//    else {
//        return 2;
//    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.selectedItems.count;
    }
    else {
        return self.unselectedItems.count;
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJTagViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    ZJTagItem *item;
    if (indexPath.section == 0) {
        item = _selectedItems[indexPath.row];
    }
    else {
        item = _unselectedItems[indexPath.row];
    }
    cell.titleLabel.text = item.name;
    // cell是否进入编辑状态 set方法中会改变cell的样式
    cell.inEditState = self.inEditState;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ZJTagHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        header.titleLabel.text = @" ";
    }
    else {
        header.titleLabel.text = _unselctedSectionTitle;
    }
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    else {
        return CGSizeMake(100, 44);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_inEditState) {
        
        if (indexPath.section == 0) {// 删除第一组的
            if (indexPath.row == 0) return; // 不能编辑第一个
            // 添加新数据
            [self.unselectedItems addObject: self.selectedItems[indexPath.row]];
            // 删除旧数据
            [self.selectedItems removeObjectAtIndex:indexPath.row];
            // 在第二组最后增加一个
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.unselectedItems.count-1 inSection:1];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
        }
        else { // 添加第一组的
            // 添加新数据
            [self.selectedItems addObject: self.unselectedItems[indexPath.row]];
            // 删除旧数据
            [self.unselectedItems removeObjectAtIndex:indexPath.row];
            // 在第一组最后增加一个
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.selectedItems.count-1 inSection:0];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];

        }
        
    }
    else {
        if (indexPath.section == 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(tagView:didSelectTagWhenNotInEditState:)]) {
                [_delegate tagView:self didSelectTagWhenNotInEditState:indexPath.row];
            }
        }
        else {
            // 添加新数据
            [self.selectedItems addObject: self.unselectedItems[indexPath.row]];
            // 删除旧数据
            [self.unselectedItems removeObjectAtIndex:indexPath.row];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.selectedItems.count-1 inSection:0];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
        }

    }


}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 手指的位置
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
    // 获取手指所在的位置的cell的indexPath -- 位置不在cell上时为nil
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (gestureRecognizer == _panGesture) {
        if (indexPath) { // indexPath不为nil 说明手指开始的位置是在cell上面
            if (indexPath.section == 0 && indexPath.row != 0 && _inEditState) {
                // 只允许第一个section里面的cell响应手势
                // 并且不允许拖动第一个cell, 当然你可以自定义不能拖动的cell
                _currentIndexPath = indexPath;
                return YES;
            }
        }
        return NO;
        
    }
    
    if (gestureRecognizer == _longPressGesture) {
        if (!_inEditState && indexPath.section == 0) return YES;
        else return NO;
    }
    return YES;

}

- (void)longPressHandler:(UILongPressGestureRecognizer *)longPressGesture {
    // 设置为进入编辑状态, 改变cell的状态
    self.inEditState = YES;
}

- (void)setInEditState:(BOOL)inEditState {
    if (_delegate && [_delegate respondsToSelector:@selector(tagView:didChangeInEditState:)]) {
        [_delegate tagView:self didChangeInEditState:inEditState];
    }
    _inEditState = inEditState;
    [self.collectionView reloadData];

}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[ZJTagViewCell class] forCellWithReuseIdentifier:kCellID];
        [collectionView registerClass:[ZJTagHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderID];
        collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(100, 44);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.headerReferenceSize = CGSizeMake(100, 44);
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
        _panGesture.delegate = self;
        // 优先执行collectionView系统的手势
//        [_panGesture requireGestureRecognizerToFail:self.collectionView.panGestureRecognizer];
    }
    return _panGesture;
}

- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        longPressGesture.delegate = self;
        _longPressGesture = longPressGesture;
    }
    return _longPressGesture;
}

- (NSMutableArray<ZJTagItem *> *)selectedItems {
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    return _selectedItems;
}

- (NSMutableArray<ZJTagItem *> *)unselectedItems {
    if (!_unselectedItems) {
        _unselectedItems = [NSMutableArray array];
    }
    return _unselectedItems;
}
@end
