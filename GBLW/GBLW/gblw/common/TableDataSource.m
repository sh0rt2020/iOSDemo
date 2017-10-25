//
//  TableDataSource.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/25.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "TableDataSource.h"
#import <UIKit/UIKit.h>

@interface TableDataSource () 
@property (nonatomic, strong) NSArray *items;  //二维数组 一维表示分区数量  二维表示分区中cell数量
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableCellConfigBlock block;
@end

@implementation TableDataSource
//只允许调用自定义的初始化方法
- (instancetype)init {
    return nil;
}

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellId
        configBlock:(TableCellConfigBlock)block {
    self = [super init];
    
    if (self) {
        if (items) {
            self.items = items;
        }
        
        if (cellId) {
            self.cellIdentifier = cellId;
        }
        
        if (block) {
            self.block = block;
        }
    }
    
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.items[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id item = self.items[indexPath.section][indexPath.row];
    self.block(cell, item, indexPath);
    return cell;
}
@end
