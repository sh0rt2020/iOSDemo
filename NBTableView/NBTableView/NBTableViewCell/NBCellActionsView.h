//
//  NBCellActionsView.h
//  NBTableView
//
//  Created by Yige on 2016/11/10.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBCellActionItem.h"
#import "NBGlobalDefines.h"

@interface NBCellActionsView : UIView

@property (nonatomic, strong, readonly) NBCellActionItem *abledItem;
DEFINE_PROPERTY_STRONG(NSArray *, items);

- (instancetype)initWithItems:(NSArray *)items;
- (void)setEnableItemWithMaskOffSet:(float)offset;
@end
