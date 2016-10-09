//
//  SSGiftSubscribeTableCell.h
//  SpiderSubscriber
//
//  Created by sunwell on 15/9/14.
//  Copyright (c) 2015年 spider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSDatasInfo.h"
#import "SSGiftScrollView.h"

@interface SSGiftSubscribeTableCell : UITableViewCell

@property (strong, nonatomic) SSGiftScrollView *ssGiftV;
- (void)configCellWithData:(SSPublicationInfo *)info;
@end
