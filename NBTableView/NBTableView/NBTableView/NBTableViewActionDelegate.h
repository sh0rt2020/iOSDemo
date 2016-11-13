//
//  NBTableViewActionDelegate.h
//  NBTableView
//
//  Created by sunwell on 2016/11/13.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NBTableView;
@protocol NBTableViewActionDelegate <NSObject>

- (void) nbTableView:(NBTableView *)tableView didTapAtRow:(NSInteger)row;
- (void) nbTableView:(NBTableView *)tableView deleteCellAtRow:(NSInteger)row;
- (void) nbTableView:(NBTableView *)tableView editCellDataAtRow:(NSInteger)row;
@end
