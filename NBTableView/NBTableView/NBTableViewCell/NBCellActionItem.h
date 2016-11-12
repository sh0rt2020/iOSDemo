//
//  NBCellActionItem.h
//  NBTableView
//
//  Created by Yige on 2016/11/10.
//  Copyright © 2016年 sunwell. All rights reserved.
//

//cell中负责响应用户交互的对象

#import <UIKit/UIKit.h>

@class NBTableViewCell;

@interface NBCellActionItem : UIButton

@property (nonatomic, weak) NBTableViewCell *linkedCell;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@end
