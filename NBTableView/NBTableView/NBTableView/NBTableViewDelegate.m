//
//  NBTableViewDelegate.m
//  NBTableView
//
//  Created by sunwell on 2016/11/12.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "NBTableViewDelegate.h"
#import "NBGlobalDefines.h"

@interface NBTableViewDelegate ()

DEFINE_PROPERTY_ASSIGN_FLOAT(height);
@property (nonatomic, copy) NBTableViewDelegateConfigureBlock delegateBlock;
@property (nonatomic, nonnull, copy) NSArray *items;
@end


@implementation NBTableViewDelegate
#pragma mark - self def memthod
- (id)init {
    return nil;
}

- (instancetype)initWithItems:(NSArray *)items configureBlock:(NBTableViewDelegateConfigureBlock)block {
    self = [super init];
    if (self) {
        self.items = items;
        
        self.delegateBlock = block;
    }
    return self;
}

#pragma mark - NBTableViewActionDelegate
- (void)nbTableView:(NBTableView *)tableView didTapAtRow:(NSInteger)row {
    NSLog(@"%s", __func__);
    
    id item = self.items[row];
    self.delegateBlock(row, item);
}

- (void)nbTableView:(NBTableView *)tableView deleteCellAtRow:(NSInteger)row {
    
}

- (void)nbTableView:(NBTableView *)tableView editCellDataAtRow:(NSInteger)row {
    
}

@end
