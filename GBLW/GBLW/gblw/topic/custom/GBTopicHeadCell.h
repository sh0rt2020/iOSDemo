//
//  GBTopicHeadCell.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/24.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBTopicHeadCellDelegate <NSObject>
@required
- (void)topicHeadCellFollowAction:(UIButton *)sender beFollowed:(BOOL)beFollowed;
@end

@interface GBTopicHeadCell : UITableViewCell

@property (nonatomic, weak) id<GBTopicHeadCellDelegate> delegate;
- (void)configData:(id)data;
@end
