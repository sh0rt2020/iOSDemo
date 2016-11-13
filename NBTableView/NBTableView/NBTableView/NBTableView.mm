//
//  NBTableView.m
//  NBTableView
//
//  Created by sunwell on 2016/11/12.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "NBTableView.h"
#import <map>
#import <vector>
#import "UIColor+NBAdd.h"
//#import "NBTableViewDelegate.h"
//#import "NBTableViewDataSource.h"
#import "NBCellActionItem.h"
#import "UIView+NBAdd.h"

typedef std::map<int, float> DZCellYoffsetMap;
typedef std::vector<float>   DZCellHeightVector;

typedef struct {
    BOOL funcNumberOfRows;
    BOOL funcCellAtRow;
    BOOL funcHeightRow;
    BOOL funcPullDownCell;
}DZTableDataSourceResponse;

@interface NBTableView () {
    NSMutableArray *cacheCells;
    NSMutableDictionary *visibleCellsMap;
    int64_t     numberOfCells;
    DZCellYoffsetMap cellYOffsets;
    DZCellHeightVector cellHeights;
    DZTableDataSourceResponse dataSourceReponse;
}

@end


@implementation NBTableView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        visibleCellsMap = [NSMutableDictionary dictionary];
        cacheCells = [NSMutableArray array];
        [self addTapTarget:self selector:@selector(handleTapGesture:)];
    }
    return self;
}

- (void)menuSelectRowAt:(NSInteger)row {
    
    NBTableViewCell *cell = [self cellForRow:row];
    NSArray *cells = visibleCellsMap.allValues;
    for (NBTableViewCell *eachCell in cells) {
        if (eachCell == cell) {
            if ([self.delegate respondsToSelector:@selector(nbTableView:didTapAtRow:)]) {
                [self.delegate nbTableView:self didTapAtRow:row];
            }
            eachCell.isSelected = YES;
            self.selectedIndex = eachCell.index;
        } else {
            eachCell.isSelected = NO;
        }
    }
    
    [self scrollToRow:row];
    self.selectedIndex = row;
}

#pragma mark - event response
- (void) deleteCellOfItem:(NBCellActionItem *)item {
    
    if ([self.delegate respondsToSelector:@selector(nbTableView:deleteCellAtRow:)]) {
        [self.delegate nbTableView:self deleteCellAtRow:item.linkedCell.index];
    }
}

- (void) editCellOfItem:(NBCellActionItem *)item {
    
    if ([self.delegate respondsToSelector:@selector(nbTableView:editCellDataAtRow:)]) {
        [self.delegate nbTableView:self editCellDataAtRow:item.linkedCell.index];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGes {
    
    CGPoint point = [tapGes locationInView:self];
    NSArray *cells = visibleCellsMap.allValues;
    for (NBTableViewCell *eachCell in cells) {
        CGRect rect = eachCell.frame;
        if (CGRectContainsPoint(rect, point)) {
            if ([self.delegate respondsToSelector:@selector(nbTableView:didTapAtRow:)]) {
                [self.delegate nbTableView:self didTapAtRow:eachCell.index];
            }
            eachCell.isSelected = YES;
            self.selectedIndex = eachCell.index;
        } else {
            eachCell.isSelected = NO;
        }
        
    }
}

#pragma mark - private method
- (NBTableViewCell *)cellForRow:(NSInteger)rowIndex {
    //此处逻辑可能有问题？？？先从可见的cell缓存里拿 拿不到在从dataSource里拿
    NBTableViewCell *cell = [visibleCellsMap objectForKey:@(rowIndex)];
    if (!cell) {
        cell = [self.dataSource nbTableView:self cellForRow:rowIndex];
        NBCellActionItem *deleteItem = [NBCellActionItem buttonWithType:UIButtonTypeSystem];
        deleteItem.backgroundColor = [UIColor redColor];
        [deleteItem addTarget:self action:@selector(deleteCellOfItem:) forControlEvents:UIControlEventTouchUpInside];
        [deleteItem setTitle:@"删除" forState:UIControlStateNormal];
        deleteItem.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 240);
        
        NBCellActionItem *editItem = [NBCellActionItem buttonWithType:UIButtonTypeSystem];
        editItem.backgroundColor = [UIColor greenColor];
        [editItem addTarget:self action:@selector(editCellOfItem:) forControlEvents:UIControlEventTouchUpInside];
        [editItem setTitle:@"编辑" forState:UIControlStateNormal];
        editItem.edgeInsets = UIEdgeInsetsMake(0, 80, 0, 180);
    }
    return cell;
}

//从缓存里面拿cell
- (NBTableViewCell *)dequeNBTableViewCellForIdentifier:(NSString *)identifier {
    
    NBTableViewCell *cell = nil;
    for (NBTableViewCell *eachCell in cacheCells) {
        if ([eachCell.identifiy isEqualToString:identifier]) {
            cell = eachCell;
            break;
        }
    }
    
    if (cell) {
        [cacheCells removeObject:cell];
    }
    return cell;
}

//回收cell 放到缓存中待复用
- (void)enqueueTableViewCel:(NBTableViewCell *)cell {
    if (cell) {
        [cell prepareForReused];
        [cacheCells addObject:cell];
        [cell removeFromSuperview];
    }
}

- (void)updateVisibleCell:(NBTableViewCell *)cell withIndex:(NSInteger)index {
    
    for (NBCellActionItem *each in cell.actionsView.items) {
        each.linkedCell = cell;
    }
    visibleCellsMap[@(index)] = cell;
    if (index == numberOfCells-1) {
        
    } else {
        
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
}

- (CGRect)rectForCellAtRow:(int)rowIndex {
    
    if (rowIndex < 0||rowIndex >= numberOfCells) {
        return CGRectZero;
    }
    
    float cellYOffset = cellYOffsets.at(rowIndex);
    float cellHeight = cellHeights.at(rowIndex);
    return CGRectMake(0, cellYOffset-cellHeight, CGRectGetWidth(self.frame), cellHeight);
}

- (void) scrollToRow:(NSInteger)row {
    
    CGRect rect = [self rectForCellAtRow:(int)row];
    [self scrollRectToVisible:rect animated:YES];
}

#pragma mark - getter&setter
- (void)setDataSource:(id<NBTableViewSourceDelegate>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        dataSourceReponse.funcNumberOfRows = [dataSource respondsToSelector:@selector(numberOfRowsInNBTableView:)];
        dataSourceReponse.funcCellAtRow = [dataSource respondsToSelector:@selector(nbTableView:cellForRow:)];
        dataSourceReponse.funcHeightRow = [dataSource respondsToSelector:@selector(nbTableView:cellHeightForRow:)];
    }
}

//- (void)setGradientColor:(UIColor *)gradientColor {
//    
//    if (_gradientColor != gradientColor) {
//        _gradientColor = gradientColor;
//        _beginGradientColor = CColorModelFromUIColor(_gradientColor);
//        _endGradientColor = CColorModelOffset(_beginGradientColor, 0.3);
//        [self reloadPiceGradientColor];
//    }
//}
@end
