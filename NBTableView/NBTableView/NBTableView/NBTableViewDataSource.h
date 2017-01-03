//
//  NBTableViewDataSource.h
//  NBTableView
//
//  Created by sunwell on 2016/11/12.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NBTableView.h"

typedef void(^NBTableViewDataSourceConfigureBlock)(id cell, id item);

@interface NBTableViewDataSource : NSObject <NBTableViewSourceDelegate>

DEFINE_PROPERTY_ASSIGN_FLOAT(height);

- (id)initWithItems:(NSArray *)itemArray
       cellIdentifier:(NSString *)identifier
       configureBlock:(NBTableViewDataSourceConfigureBlock)block;
@end
