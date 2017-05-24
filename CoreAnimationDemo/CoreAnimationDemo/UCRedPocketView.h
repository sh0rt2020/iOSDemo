//
//  UCRedPocketView.h
//  Doctor
//
//  Created by Yige on 2016/11/9.
//  Copyright © 2016年 YiGeMed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCRedPocketViewDelegate <NSObject>
- (void)didClickOpenRedPocket:( UIButton * _Nonnull )sender;
@end

@interface UCRedPocketView : UIView

@property (nonatomic, weak) id<UCRedPocketViewDelegate> delegate;
@property (nonatomic, copy) NSString * _Nonnull count;  //总数量
@property (nonatomic, nonnull) UIImageView *pocketView;  //红包
@property (nonatomic, nonnull) UIDynamicAnimator *animator;  //负责控制动画

- (void)disappearAnimateCompleted:(void ( ^ _Nonnull)( UCRedPocketView * _Nonnull ss))completed;
- (void)resetView;
- (void)layoutUI;
//- (void)animate;

@end
