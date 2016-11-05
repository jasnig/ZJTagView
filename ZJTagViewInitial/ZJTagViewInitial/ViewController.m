//
//  ViewController.m
//  ZJTagView
//
//  Created by ZeroJ on 16/9/27.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ViewController.h"
#import "ZJTagView.h"
@interface ViewController ()
@property (strong, nonatomic) ZJTagView *tagView;
@end

@implementation ViewController
@synthesize tagView;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *selectedItems = [NSMutableArray array];
    NSMutableArray *unselectedItems = [NSMutableArray array];

    for (int i=0; i<20; i++) {
        ZJTagItem *item = [ZJTagItem new];
        item.name = [NSString stringWithFormat:@"选中--- %d",i];
        [selectedItems addObject:item];
    }
    
    for (int i=0; i<40; i++) {
        ZJTagItem *item = [ZJTagItem new];
        item.name = [NSString stringWithFormat:@"未选中--- %d",i];
        [unselectedItems addObject:item];
    }
    tagView = [[ZJTagView alloc] initWithSelectedItems:selectedItems unselectedItems:unselectedItems];
    [self.view addSubview:tagView];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    tagView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
