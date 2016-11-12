//
//  NBTableViewDataSource.h
//  NBTableView
//
//  Created by sunwell on 2016/11/12.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^NBTableViewCellConfigureBlock)(id cell, id item);

@interface NBTableViewDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)itemArray
       cellIdentifier:(NSString *)identifier
       configureBlock:(NBTableViewCellConfigureBlock)block;
@end
