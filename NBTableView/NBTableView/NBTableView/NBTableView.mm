//
//  NBTableView.m
//  NBTableView
//
//  Created by sunwell on 2016/11/12.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#define nbTableViewDefaultHeight 44.0f
#define CGRectViewWidth (CGRectGetWidth(self.bounds))

static float const NBAnimationDefualtDuration = 0.25;

#import "NBTableView.h"
#import <map>
#import <vector>
#import "UIColor+NBAdd.h"
//#import "NBTableViewDelegate.h"
//#import "NBTableViewDataSource.h"
#import "NBCellActionItem.h"
#import "UIView+NBAdd.h"

typedef std::map<int, float> NBCellYoffsetMap;
typedef std::vector<float>   NBCellHeightVector;

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
    NBCellYoffsetMap cellYOffsets;  //记录Y的偏移量
    NBCellHeightVector cellHeights;
    DZTableDataSourceResponse dataSourceReponse;
    BOOL isLayoutCells;
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self canBeginLayoutCells]) {
        [self layoutNeedDisplayCells];
    }
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

//更新cell
- (void)updateVisibleCell:(NBTableViewCell *)cell withIndex:(NSInteger)index {
    
    cell.index =  index;
    for (NBCellActionItem *eachItem in cell.actionsView.items) {
        eachItem.linkedCell = cell;
    }
    visibleCellsMap[@(index)] = cell;
    if (index == numberOfCells-1) {
        cell.topSeparationLine.hidden = YES;
        cell.bottomSeparationLine.hidden = YES;
    } else {
        cell.topSeparationLine.hidden = NO;
        cell.bottomSeparationLine.hidden = NO;
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
}

//更新内容视图大小
- (void)reduceContentSize {
    numberOfCells = [self.dataSource numberOfRowsInNBTableView:self];
    cellYOffsets = NBCellYoffsetMap();  //？？？？
    cellHeights = NBCellHeightVector();
    float height = 0;
    for (int i = 0; i < numberOfCells; i++) {
        float cellHeight = dataSourceReponse.funcHeightRow?[self.dataSource nbTableView:self cellHeightForRow:i]:nbTableViewDefaultHeight;
        cellHeights.push_back(cellHeight);
        height += cellHeight;
        cellYOffsets .insert(std::pair<int, float>(i, height));
    }
    
    if (height < CGRectGetHeight(self.frame)) {
        height = CGRectGetHeight(self.frame) + 2;  //为什么要加2
    }
    height += 10;
    CGSize size = CGSizeMake(CGRectGetWidth(self.frame), height);
    [self setContentSize:size];
//    [self reloadPiceGradientColor];
}

//计算屏幕上展示的cell的索引范围
- (NSRange)displayRange {
    
    if (numberOfCells == 0) {
        return NSMakeRange(0, 0);
    }
    
    int beginIndex = 0;
    float beginHeight = self.contentOffset.y;
    float displayBeginHeight = -0.00000001f;
    
    for (int i = 0; i < numberOfCells; i++) {
        float cellHeight = cellHeights.at(i);
        displayBeginHeight += cellHeight;
        
        if (displayBeginHeight > beginHeight) {
            beginIndex = i;  //屏幕上显示的第一个cell的索引
            break;
        }
    }
    
    int endIndex = beginIndex;
    float displayEndHeight = self.contentOffset.y+CGRectGetHeight(self.frame);
    for (int i = beginIndex; i < numberOfCells; i++) {
        float cellYoffset = cellYOffsets.at(i);
        if (cellYoffset > displayEndHeight) {
            endIndex = i;
            break;
        }
        if (i == numberOfCells - 1) {
            endIndex = i;
            break;
        }
    }
    return NSMakeRange(beginIndex, endIndex-beginIndex+1);
}

- (void)addCell:(NBTableViewCell *)cell atRow:(NSInteger)row {
    
    [self addSubview:cell];
    [self updateVisibleCell:cell withIndex:row];
}

//清除不用的cell
- (void)cleanUnusedCellsWithDisplayRange:(NSRange)range {
    
    NSDictionary *dic = [visibleCellsMap copy];
    NSArray *keys = dic.allKeys;
    for (NSNumber *rowIndex in keys) {
        int row = [rowIndex intValue];
        if (!NSLocationInRange(row, range)) {
            NBTableViewCell *cell = [visibleCellsMap objectForKey:rowIndex];
            [visibleCellsMap removeObjectForKey:rowIndex];
            [self enqueueTableViewCel:cell];
        }
    }
}

//
- (void)layoutNeedDisplayCells {
    [self beginLayoutCells];
    NSRange displayRange = [self displayRange];
    for (int i = (int)displayRange.location; i < displayRange.location+displayRange.length; i++) {
        NBTableViewCell *cell = [self cellForRow:i];
        [self addCell:cell atRow:i];
        cell.frame = [self rectForCellAtRow:i];
        if (self.selectedIndex == i) {
            cell.isSelected = YES;
        } else {
            cell.isSelected = NO;
        }
    }
    
    [self cleanUnusedCellsWithDisplayRange:displayRange];
    [self endLayoutCells];
    
    if (self.backgroundView) {
        self.backgroundView.frame = self.bounds;
        [self insertSubview:self.backgroundView atIndex:0];
    }
    
    if (self.bottomView) {
        CGRect lastRect = [self rectForCellAtRow:(int)numberOfCells-1];
        self.bottomView.frame = CGRectMake(lastRect.origin.x, CGRectGetMaxY(lastRect), CGRectViewWidth, CGRectGetHeight(self.bottomView.frame));
        [self bringSubviewToFront:self.bottomView];
//        if ([self.bottomView isKindOfClass:]) {
//            
//        }
    }
}

- (NSArray *)cellsBetween:(NSInteger)start end:(NSInteger)end {
    NSMutableArray *array = [NSMutableArray new];
    for (int i = (int)start; i <= end; i++) {
        NBTableViewCell *cell = visibleCellsMap[@(i)];
        if (cell) {
            [array addObject:cell];
        }
    }
    return array;
}

//移除
- (void)removeRowAt:(NSInteger)row withAnimate:(BOOL)animate {
    NSRange displayRange = [self displayRange];
    [self reduceContentSize];
    NSRange newDisplayRange = [self displayRange];
    
    if (NSLocationInRange(row, displayRange)) {
        [self beginLayoutCells];
        
        NBTableViewCell *cell = visibleCellsMap[@(row)];
        [visibleCellsMap removeObjectForKey:@(row)];
        
        //将被标记为移除的cell删除  后面的在屏幕上的cell往前移动
        NSArray *afterCells = [self cellsBetween:row+1 end:row+(displayRange.location-((row+1)-displayRange.location))];
        for (NBTableViewCell *eachCell in afterCells) {
            [visibleCellsMap removeObjectForKey:@(eachCell.index)];
            eachCell.index -= 1;
            visibleCellsMap[@(eachCell.index)] = eachCell;
        }
        
        //
        NBTableViewCell *newCell = nil;
        if (displayRange.location+displayRange.length == newDisplayRange.location+newDisplayRange.length) {
            NSInteger row = newDisplayRange.location+newDisplayRange.length-1;
            newCell = [self cellForRow:row];
            [self addCell:newCell atRow:row];
            newCell.frame = CGRectOffset([self rectForCellAtRow:(int)row], 0, cellHeights.at(row));
        }
        
        void(^animationBlock)(void) = ^(void) {
            for (NBTableViewCell *eachCell in afterCells) {
                CGRect rect = [self rectForCellAtRow:(int)eachCell.index];
                eachCell.frame = rect;
            }
            if (newCell) {
                newCell.frame = [self rectForCellAtRow:(int)newCell.index];
            }
            
            CGRect cellFrame = [self rectForCellAtRow:(int)row];
            cell.frame = CGRectOffset(cellFrame, CGRectGetWidth(cellFrame), 0);
        };
        
        void(^completeBlock)(void) = ^(void) {
            [self enqueueTableViewCel:cell];
            [self endLayoutCells];
        };
        
        if (animate) {
            [UIView animateWithDuration:NBAnimationDefualtDuration animations:animationBlock completion:^(BOOL finished) {
                completeBlock();
            }];
        } else {
            animationBlock();
            completeBlock();
        }
    }
    
}

//插入
- (void)insertRowAt:(NSSet *)rowsSet withAnimate:(BOOL)animate {
    
}

- (void) beginLayoutCells {
    isLayoutCells = YES;
}

- (void) endLayoutCells {
    isLayoutCells = NO;
}

- (BOOL) canBeginLayoutCells {
    return isLayoutCells;
}


//重载数据
- (void)reloadData {
    [self reduceContentSize];
    [self layoutNeedDisplayCells];
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

- (void) reloadPiceGradientColor {
    
    //    Float32 cellsCount = (Float32)_numberOfCells + 1;
    //    CColorModel offset = CColorModelGetOffSet(_beginGradientColor, _endGradientColor);
    //    _preGradientPiceColor.red = offset.red / cellsCount;
    //    _preGradientPiceColor.green = offset.green/ cellsCount;
    //    _preGradientPiceColor.blue = offset.blue / cellsCount;
    //    _preGradientPiceColor.alpha = offset.alpha;
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

- (void)setGradientColor:(UIColor *)gradientColor {
    
//    if (_gradientColor != gradientColor) {
//        _gradientColor = gradientColor;
//        _beginGradientColor = CColorModelFromUIColor(_gradientColor);
//        _endGradientColor = CColorModelOffset(_beginGradientColor, 0.3);
//        [self reloadPiceGradientColor];
//    }
}
@end
