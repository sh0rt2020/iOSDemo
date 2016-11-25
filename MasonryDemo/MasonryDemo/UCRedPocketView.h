//
//  UCRedPocketView.h
//  Doctor
//
//  Created by Yige on 2016/11/9.
//  Copyright © 2016年 YiGeMed. All rights reserved.
//

//#import "BaseView.h"
#import <UIKit/UIKit.h>

@protocol UCRedPocketViewDelegate <NSObject>

@end

@interface UCRedPocketView : UIView

@property (nonatomic, copy, nonnull) NSString *count;  //总数量
@property (nonatomic, copy, nonnull) NSString *title;  //标题
@property (nonatomic, nonnull) UIImageView *noPocketView; //没有红包的背景

- (void)appearAnimate;
- (void)dropViewCompleted:(void (^)(BOOL finished))complete;
- (void)clearViewCompleted:(void (^)(BOOL finished))complete;
@end
