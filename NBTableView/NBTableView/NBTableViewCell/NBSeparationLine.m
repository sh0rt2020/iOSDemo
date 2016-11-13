//
//  NBSeparationLine.m
//  NBTableView
//
//  Created by sunwell on 2016/11/13.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#define CGRectViewWidth (CGRectGetWidth(self.bounds))
#define CGRectViewHeight CGRectGetHeight(self.bounds)

#import "NBSeparationLine.h"

@interface NBSeparationLine () {
    UIColor *topColor;
    UIColor *bottomColor;
}

@end

@implementation NBSeparationLine

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectViewWidth, CGRectViewHeight/2)];
    [topColor setFill];
    [path fill];
    
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, CGRectViewHeight/2, CGRectViewWidth, CGRectViewHeight/2)];
    [bottomColor setFill];
    [bottomPath fill];
}

- (void)setLineColor:(UIColor *)lineColor {
    if (_lineColor != lineColor) {
        _lineColor = lineColor;
        if (_lineColor) {
            CGFloat red;
            CGFloat green;
            CGFloat blue;
            CGFloat alpha;
            if ([_lineColor getRed:&red green:&green blue:&blue alpha:&alpha]) {
                topColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
                bottomColor = [UIColor colorWithRed:red+0.3 green:green+0.3 blue:blue+0.3 alpha:alpha];
            }
        }
    }
}
@end
