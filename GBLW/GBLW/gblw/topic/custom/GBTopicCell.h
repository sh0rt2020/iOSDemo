//
//  GBTopicCell.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/20.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBTopicCellDelegate <NSObject>
@required
- (void)topicCellHandleAttention:(UIButton *)sender index:(NSInteger)index;
@end

@interface GBTopicCell : UITableViewCell

@property (nonatomic, weak) id<GBTopicCellDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
- (void)configData:(id)data;
@end
