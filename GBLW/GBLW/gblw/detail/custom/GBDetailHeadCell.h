//
//  GBDetailCell.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/19.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const FavorBtnTag = 2000;
static NSInteger const UnfavorBtnTag = 2001;
static NSInteger const CommentBtnTag = 2002;
static NSInteger const AttentionTag = 2003;

@protocol GBDetailHeadCellDelegate <NSObject>
@required
- (void)detailHeadCellHandleAction:(UIButton *)sender;
@end

@interface GBDetailHeadCell : UITableViewCell

@property (nonatomic, weak) id<GBDetailHeadCellDelegate> delegate;

- (void)configData:(id)data;
@end
