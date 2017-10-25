//
//  TableDataSource.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/25.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TableCellConfigBlock)(id cell, id item, NSIndexPath *indexPath);

@interface TableDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellId
        configBlock:(TableCellConfigBlock)block;
@end
