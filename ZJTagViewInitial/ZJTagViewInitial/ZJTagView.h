//
//  ZJTagView.h
//  ZJTagView
//
//  Created by ZeroJ on 16/9/27.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJTagItem.h"
@interface ZJTagView : UIView

- (instancetype)initWithSelectedItems:(NSArray<ZJTagItem *> *)selectedItems unselectedItems:(NSArray<ZJTagItem *> *)unselectedItems;
@property (strong, nonatomic) NSString *unselctedSectionTitle;

@property (assign, nonatomic) BOOL editState;
@end
