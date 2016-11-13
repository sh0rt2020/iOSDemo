//
//  NBTableView.h
//  NBTableView
//
//  Created by sunwell on 2016/11/12.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBTableViewCell.h"
#import "NBTableViewSourceDelegate.h"
#import "NBTableViewActionDelegate.h"

@interface NBTableView : UIScrollView

DEFINE_PROPERTY_WEAK(id<NBTableViewSourceDelegate>, dataSource);
DEFINE_PROPERTY_WEAK(id<NBTableViewActionDelegate>, delegate);
DEFINE_PROPERTY_ASSIGN(NSInteger, selectedIndex);
DEFINE_PROPERTY_STRONG(UIColor *, gradientColor);
@end
