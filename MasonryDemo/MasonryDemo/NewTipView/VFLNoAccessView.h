//
//  VFLNoAccessView.h
//  NoAccessDemo
//
//  Created by Yige on 2016/10/27.
//  Copyright © 2016年 Yige. All rights reserved.
//


//用VFL来实现页面布局
#import <UIKit/UIKit.h>

@interface VFLNoAccessView : UIView

//two subtitles
@property (nonatomic, copy) NSString *subTitleOne;
@property (nonatomic, copy) NSString *subTitleTwo;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)hiddenAnimated:(BOOL)animated;

-(id)initWithSubTitleOne:(NSString *)subTitleOne subTitleTwo:(NSString *)subTitleTwo;

@end
