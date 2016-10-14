//
//  ArrayDataSource.h
//  SimplifyVCDemo
//
//  Created by sunwell on 2016/10/14.
//  Copyright © 2016年 com.sun.mantledemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TableViewCellConfigureBlock)(id cell, id item);

@interface ArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)itemArray
     cellIdentifier:(NSString *)cellIdentifier
     configureBlock:(TableViewCellConfigureBlock)block;
@end
