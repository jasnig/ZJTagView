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
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
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
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    if (_editState) {
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
    if (_editState) {
        cell.titleLabel.backgroundColor = [UIColor redColor];
    }
    else {
        cell.titleLabel.backgroundColor = [UIColor blueColor];

    }
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


- (void)setEditState:(BOOL)editState {
    _editState = editState;
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
