//
//  ViewController.m
//  ZJTagView
//
//  Created by ZeroJ on 16/9/27.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ViewController.h"
#import "ZJTagView.h"
@interface ViewController ()<ZJTagViewDelegate>
@property (strong, nonatomic) ZJTagView *tagView;
@property (strong, nonatomic) UIButton *editBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *selectedItems = [NSMutableArray array];
    NSMutableArray *unselectedItems = [NSMutableArray array];
    
    _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 44)];
    [_editBtn setTitle:@"点击这里或者长按标签进入编辑页面" forState:UIControlStateNormal];
    [_editBtn setTitle:@"编辑完成" forState:UIControlStateSelected];

    [_editBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editBtn];

    // 初始化第一个section数据
    for (int i=0; i<20; i++) {
        ZJTagItem *item = [ZJTagItem new];
        item.name = [NSString stringWithFormat:@"选中--- %d",i];
        [selectedItems addObject:item];
    }
    // 初始化第二个section数据
    for (int i=0; i<40; i++) {
        ZJTagItem *item = [ZJTagItem new];
        item.name = [NSString stringWithFormat:@"未选中--- %d",i];
        [unselectedItems addObject:item];
    }
    // 初始化
    _tagView = [[ZJTagView alloc] initWithSelectedItems:selectedItems unselectedItems:unselectedItems];
    
    // 设置代理 可以处理点击
    _tagView.delegate = self;
    _tagView.frame = CGRectMake(0, CGRectGetMaxY(_editBtn.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_editBtn.frame));
    // 设置frame
    [self.view addSubview:_tagView];
    
    
}

- (void)editBtnOnClick:(UIButton *)editBtn {
    _tagView.inEditState = !editBtn.isSelected;
}


#pragma mark - ZJTagViewDelegate
- (void)tagView:(ZJTagView *)tagView didChangeInEditState:(BOOL)inEditState {
    _editBtn.selected = inEditState;

}

- (void)tagView:(ZJTagView *)tagView didSelectTagWhenNotInEditState:(NSInteger)index {
    NSLog(@"点击未处于编辑状态的第一组的第%ld个tag", index);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
