//
//  ArrayDataSource.m
//  SimplifyVCDemo
//
//  Created by sunwell on 2016/10/14.
//  Copyright © 2016年 com.sun.mantledemo. All rights reserved.
//

#import "ArrayDataSource.h"

@interface ArrayDataSource ()
@property (nonatomic) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureBlock;
@end

@implementation ArrayDataSource

- (id)init {
    return nil;  //只允许调用自定义的初始化方法
}
//自定义的初始化方法
- (id)initWithItems:(NSArray *)itemArray cellIdentifier:(NSString *)cellIdentifier configureBlock:(TableViewCellConfigureBlock)block {
    
    self = [super init];
    if (itemArray) {
        _items = itemArray;
    }
    
    if (cellIdentifier) {
        _cellIdentifier = cellIdentifier;
    }
    
    if (block) {
        _configureBlock = block;
    }
    
    return self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    id item = self.items[indexPath.row];
    self.configureBlock(cell, item);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
