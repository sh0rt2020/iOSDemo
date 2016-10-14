//
//  SSLineation.h
//  SpiderSubscriber
//
//  Created by spider on 15/1/7.
//  Copyright (c) 2015年 spider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SSLayer)

//直接给cell画一条0.5高，满宽的颜色为#B2B2B2的线
-(void)topLayerLine;
-(void)topLayerLineDetail;
-(void)bottomLayerLine;
-(void)leftLayerLine;
-(void)rightLayerLine;
- (void)verticalCenterLine;

//画一条可自定义颜色，坐标，宽度，高度
-(void)addTopLayer:(float)xOffeset color:(UIColor *)color width:(float)width height:(float)height;
-(void)addBottomLayer:(float)xOffeset color:(UIColor *)color width:(float)width height:(float)height;
-(void)addLeftLayer:(float)yOffeset color:(UIColor *)color width:(float)width height:(float)height;
-(void)addRightLayer:(float)yOffeset color:(UIColor *)color width:(float)width height:(float)height;

@end
