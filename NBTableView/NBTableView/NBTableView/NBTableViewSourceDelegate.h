//
//  NBTableViewSourceDelegate.h
//  NBTableView
//
//  Created by sunwell on 2016/11/13.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NBTableView;
@class NBTableViewCell;
@protocol NBTableViewSourceDelegate  <NSObject>

- (NSInteger)numberOfRowsInNBTableView:(NBTableView *)tableView;
- (NBTableViewCell *)nbTableView:(NBTableView *)tableView cellForRow:(NSInteger)row;
- (CGFloat)nbTableView:(NBTableView *)tableView cellHeightForRow:(NSInteger)row;
@end
