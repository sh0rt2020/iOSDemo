//
//  GBDetailCommentCell.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/19.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBDetailCommentCellDelegate <NSObject>
@required
- (void)detailCommentCellHandleFavor:(UIButton *)sender;
@end

@interface GBDetailCommentCell : UITableViewCell

@property (nonatomic, weak) id<GBDetailCommentCellDelegate> delegate;

- (void)configData:(id)data;
@end
