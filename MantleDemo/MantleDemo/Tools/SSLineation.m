//
//  SMLineation.m
//  SpiderSubscriber
//
//  Created by spider on 15/1/7.
//  Copyright (c) 2015年 spider. All rights reserved.
//

#import "SSLineation.h"
#import "SSToolsClass.h"

@implementation UIView (SSLayer)

//直接给cell画一条线

/**
 *  添加顶部分割线
 */
-(void)topLayerLine {

    CALayer* newLayer = [self getLayerByName:@"TOP_LAYER_LINE"];
    if (newLayer) {
        return;
    }
    
    UIColor *color = SS_LINE_COLOR;
    
    newLayer = [CALayer layer];
    newLayer.name = @"TOP_LAYER_LINE";
    newLayer.contentsScale = [UIScreen mainScreen].scale;
    newLayer.backgroundColor = color.CGColor;
    newLayer.frame = CGRectMake(0, 0, ScreenWidth, 0.5);
    [self.layer addSublayer:newLayer];
}
-(void)topLayerLineDetail {
    
    CALayer* newLayer = [self getLayerByName:@"TOP_LAYER_LINE"];
    if (newLayer) {
        return;
    }
    
    UIColor *color = SS_LINE_COLOR;
    
    newLayer = [CALayer layer];
    newLayer.name = @"TOP_LAYER_LINE";
    newLayer.contentsScale = [UIScreen mainScreen].scale;
    newLayer.backgroundColor = color.CGColor;
    newLayer.frame = CGRectMake(10, 0, ScreenWidth - 20, 0.5);
    [self.layer addSublayer:newLayer];
}

/**
 *  添加底部分割线
 */
-(void)bottomLayerLine {

    CALayer* newLayer = [self getLayerByName:@"BOTTOM_LAYER_LINE"];
    if (newLayer) {
        return;
    }
    
    UIColor *color = SS_LINE_COLOR;
    
    newLayer = [CALayer layer];
    newLayer.name = @"BOTTOM_LAYER_LINE";
    newLayer.contentsScale = [UIScreen mainScreen].scale;
    newLayer.backgroundColor = color.CGColor;
    newLayer.frame = CGRectMake(0, self.frame.size.height - 0.5, ScreenWidth, 0.5);
    [self.layer addSublayer:newLayer];

}

-(void)leftLayerLine {

    CALayer* newLayer = [self getLayerByName:@"LEFT_LAYER_LINE"];
    if (newLayer) {
        return;
    }
    
    UIColor *color = SS_LINE_COLOR;
    
    newLayer = [CALayer layer];
    newLayer.name = @"LEFT_LAYER_LINE";
    newLayer.contentsScale = [UIScreen mainScreen].scale;
    newLayer.backgroundColor = color.CGColor;
    newLayer.frame = CGRectMake(0.5, 0, 0.5, self.frame.size.height);
    [self.layer addSublayer:newLayer];
}

- (void)verticalCenterLine {
    CALayer* newLayer = [self getLayerByName:@"VERTICAL_LAYER_LINE"];
    if (newLayer) {
        return;
    }
    
    UIColor *color = SS_LINE_COLOR;
    
    newLayer = [CALayer layer];
    newLayer.name = @"VERTICAL_LAYER_LINE";
    newLayer.contentsScale = [UIScreen mainScreen].scale;
    newLayer.backgroundColor = color.CGColor;
    newLayer.frame = CGRectMake(0, self.frame.size.height / 2, self.frame.size.width, 0.5);
    [self.layer addSublayer:newLayer];

}
-(void)rightLayerLine {

    CALayer* newLayer = [self getLayerByName:@"RIGHT_LAYER_LINE"];
    if (newLayer) {
        return;
    }
    
    UIColor *color = SS_LINE_COLOR;
    
    newLayer = [CALayer layer];
    newLayer.name = @"RIGHT_LAYER_LINE";
    newLayer.contentsScale = [UIScreen mainScreen].scale;
    newLayer.backgroundColor = color.CGColor;
    newLayer.frame = CGRectMake(self.frame.size.width - 0.5, 0, 0.5, self.frame.size.height);
    [self.layer addSublayer:newLayer];
}

-(void)addTopLayer:(float)xOffeset color:(UIColor *)color width:(float)width height:(float)height {
    CALayer* newLayer = [self getLayerByName:@"TOP_LAYER_SS"];
    if (newLayer) {
        return;
    }
    
    newLayer = [CALayer layer];
    newLayer.name = @"TOP_LAYER_SS";
    newLayer.contentsScale = [UIScreen mainScreen].scale;
    newLayer.backgroundColor = color.CGColor;
    newLayer.frame = CGRectMake(xOffeset, 0, width, height);
    [self.layer addSublayer:newLayer];
}

-(void)addBottomLayer:(float)xOffeset color:(UIColor *)color width:(float)width height:(float)height {
    
    CALayer* newLayer = [self getLayerByName:@"BOTTOM_LAYER_SS"];
    if (newLayer) {
        return;
    }
    
    newLayer = [CALayer layer];
    newLayer.name = @"BOTTOM_LAYER_SS";
    newLayer.contentsScale = [UIScreen mainScreen].scale;
    newLayer.backgroundColor = color.CGColor;
    newLayer.frame = CGRectMake(xOffeset, self.frame.size.height - height, width, height);
    [self.layer addSublayer:newLayer];
}

-(void)addLeftLayer:(float)yOffeset color:(UIColor *)color width:(float)width height:(float)height {
    CALayer* newLayer = [self getLayerByName:@"LEFT_LAYER_SS"];
    if (newLayer) {
        return;
    }
    
    newLayer = [CALayer layer];
    newLayer.name = @"LEFT_LAYER_SS";
    newLayer.contentsScale = [UIScreen mainScreen].scale;
    newLayer.backgroundColor = color.CGColor;
    newLayer.frame = CGRectMake(0, yOffeset, width, height);
    [self.layer addSublayer:newLayer];
    
}
-(void)addRightLayer:(float)yOffeset color:(UIColor *)color width:(float)width height:(float)height{
    CALayer* newLayer = [self getLayerByName:@"RIGHT_LAYER_SS"];
    if (newLayer) {
        return;
    }
    
    newLayer = [CALayer layer];
    newLayer.name = @"RIGHT_LAYER_SS";
    newLayer.contentsScale = [UIScreen mainScreen].scale;
    newLayer.backgroundColor = color.CGColor;
    newLayer.frame = CGRectMake(self.frame.size.width, 0, width, height);
    [self.layer addSublayer:newLayer];

}
-(CALayer*)getLayerByName:(NSString*)name {
    
    for (CALayer* layer in self.layer.sublayers) {
        if ([layer.name length] > 0 && [name isEqualToString:layer.name]) {
            return layer;
        }
    }
    return nil;
}

@end
