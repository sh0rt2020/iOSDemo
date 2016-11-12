//
//  NBCellActionsView.m
//  NBTableView
//
//  Created by Yige on 2016/11/10.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "NBCellActionsView.h"
#import "NBGeometryTools.h"

@implementation NBCellActionsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark - setter&getter
- (void)setItems:(NSArray *)items {
    if (_items != items) {
        _items = items;
        
        for (NBCellActionItem *item in items) {
            [item removeFromSuperview];
        }
        
        for (NBCellActionItem *item in items) {
            [self addSubview:item];
        }
    }
}

//自定义初始化方法
- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setItems:items];
    return self;
}

//筛选出可交互的actionItems？？
- (void)setEnableItemWithMaskOffSet:(float)offset {
    CGRect emptyMaskRect = CGRectMake(0, 0, offset, CGRectGetHeight(self.frame));
    NSMutableArray *enableItems = [NSMutableArray new];
    for (NBCellActionItem *item in self.items) {
        CGRect rect = CGRectUseEdge(self.bounds, item.edgeInsets);
        if (CGRectContainsRect(emptyMaskRect, rect)) {
            item.enabled = YES;
            [enableItems addObject:item];
        } else {
            item.enabled = NO;
            [enableItems removeObject:item];
        }
    }
    
    CGPoint point = CGPointMake(offset, CGRectGetHeight(self.frame)/2);
    float lastDistance = INT_MAX;
    if (enableItems.count) {
        for (NBCellActionItem *item in enableItems) {
            CGRect rect = CGRectUseEdge(self.bounds, item.edgeInsets);
            CGPoint centerPoint = CGPointCenterRect(rect);
            float distance = CGDistanceBetweenPoints(centerPoint, point);
            if (distance < lastDistance) {
                _abledItem = item;
                lastDistance = distance;
            }
        }
    } else {
        _abledItem = nil;
    }
}

- (void)layoutSubviews {
    for (NBCellActionItem *item in _items) {
        CGRect rect = CGRectUseEdge(self.bounds, item.edgeInsets);
        item.frame = rect;
    }
}
@end
