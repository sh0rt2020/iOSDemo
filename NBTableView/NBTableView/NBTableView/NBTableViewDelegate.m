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
@end


@implementation NBTableViewDelegate


#pragma mark - NBTableViewActionDelegate
- (void)nbTableView:(NBTableView *)tableView didTapAtRow:(NSInteger)row {
    
}

- (void)nbTableView:(NBTableView *)tableView deleteCellAtRow:(NSInteger)row {
    
}

- (void)nbTableView:(NBTableView *)tableView editCellDataAtRow:(NSInteger)row {
    
}

@end
