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

#pragma mark - NBTableViewSourceDelegate
- (NSInteger)numberOfRowsInNBTableView:(NBTableView *)tableView {
    return self.items.count;
}

- (CGFloat)nbTableView:(NBTableView *)tableView cellHeightForRow:(NSInteger)row {
    return self.height;
}

- (NBTableViewCell *)nbTableView:(NBTableView *)tableView cellForRow:(NSInteger)row {
    NBTableViewCell *cell = [tableView dequeNBTableViewCellForIdentifier:self.identifier];
    if (!cell) {
        cell = [[NBTableViewCell alloc] initWithIdentifiy:self.identifier];
    }
    id item = self.items[row];
    self.block(cell, item);
    return cell;
}
@end
