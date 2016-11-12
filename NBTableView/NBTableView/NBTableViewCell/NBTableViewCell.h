//
//  NBTableViewCell.h
//  NBTableView
//
//  Created by sunwell on 2016/10/27.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBGlobalDefines.h"

@interface NBTableViewCell : UIView

DEFINE_PROPERTY_ASSIGN(BOOL, isSelected);

- (void) showGradientStart:(UIColor *)startColor endColor:(UIColor *)end;
@end
