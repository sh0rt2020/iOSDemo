//
//  NewNoAccessView.h
//  NoAccessDemo
//
//  Created by Yige on 2016/10/27.
//  Copyright © 2016年 Yige. All rights reserved.
//


//纯手动计算实现页面布局
#import <UIKit/UIKit.h>

@protocol NewNoAccessViewDelegate <NSObject>

- (void)newNoAccessViewWillDisappear;
@end

@interface NewNoAccessView : UIView

//two subtitles
@property (nonatomic, copy) NSString *subTitleOne;
@property (nonatomic, copy) NSString *subTitleTwo;
@property (nonatomic, weak) id<NewNoAccessViewDelegate> delegate;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)hiddenFromView:(UIView *)view animated:(BOOL)animated;

-(id)initWithSubTitleOne:(NSString *)subTitleOne subTitleTwo:(NSString *)subTitleTwo;

@end
