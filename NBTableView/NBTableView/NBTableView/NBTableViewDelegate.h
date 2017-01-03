//
//  NBTableViewDelegate.h
//  NBTableView
//
//  Created by sunwell on 2016/11/12.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NBTableView.h"

typedef void(^NBTableViewDelegateConfigureBlock)(NSInteger row, id item);

@interface NBTableViewDelegate : NSObject <NBTableViewActionDelegate>

- (instancetype)initWithItems:(NSArray *)items configureBlock:(NBTableViewDelegateConfigureBlock)block;

@end
