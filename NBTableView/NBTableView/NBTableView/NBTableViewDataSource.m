//
//  NBTableViewDataSource.m
//  NBTableView
//
//  Created by sunwell on 2016/11/12.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "NBTableViewDataSource.h"
#import "NBGlobalDefines.h"

@interface NBTableViewDataSource () {
    
}

DEFINE_PROPERTY_STRONG(NSArray *, items);
DEFINE_PROPERTY_STRONG_NSSTRING(identifier);
@property (nonatomic, copy) NBTableViewCellConfigureBlock block;

@end

@implementation NBTableViewDataSource

//只允许调用自定义的初始化方法
- (id)init {
    return nil;
}

- (id)initWithItems:(NSArray *)itemArray cellIdentifier:(NSString *)identifier configureBlock:(NBTableViewCellConfigureBlock)block {
    self = [super init];
    if (itemArray) {
        _items = itemArray;
    }
    
    if (identifier) {
        _identifier = identifier;
    }
    
    if (block) {
        _block = block;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
//    if (!cell) {
//        
//    }
    id item = self.items[indexPath.row];
    self.block(cell, item);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
}
@end
