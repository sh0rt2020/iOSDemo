//
//  GBHomeFeedCell.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/17.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const FavorBtnTag = 1000;
static NSInteger const UnfavorBtnTag = 1001;
static NSInteger const CommentBtnTag = 1002;
static NSInteger const ShareBtnTag = 1003;

@protocol GBHomeFeedCellDelegate <NSObject>
@required
- (void)homeFeedCellHandleAction:(UIButton *)sender index:(NSInteger)index;
@end

@interface GBHomeFeedCell : UITableViewCell

@property (nonatomic, weak) id<GBHomeFeedCellDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
- (void)configData:(id)data;
@end
