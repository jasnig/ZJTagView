//
//  ZJTagFlowLayout.m
//  ZJTagView
//
//  Created by ZeroJ on 16/10/24.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJTagFlowLayout.h"

@implementation ZJTagFlowLayout
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // x方向的瀑布流实现
    // 但是我们这里面并没有处理 header和footer
    NSArray *superRect = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *arrtibutes = [NSMutableArray arrayWithCapacity:superRect.count];
    CGFloat y = 0;
    CGFloat x = 0;
    CGFloat margin = 10;
    for (UICollectionViewLayoutAttributes *layoutAttr in superRect) {
        CGRect layoutFrame = layoutAttr.frame;
        if ((x+layoutAttr.frame.size.width + margin*2)>self.collectionView.bounds.size.width) {
            x = margin;
            y += (layoutAttr.frame.size.height+margin);
        }
        layoutFrame.origin.x = x;
        layoutFrame.origin.y = y;
        x = layoutFrame.origin.x + layoutAttr.frame.size.width;
        layoutAttr.frame = layoutFrame;
        [arrtibutes addObject:layoutAttr];
    }
    
    return arrtibutes;
}

@end
