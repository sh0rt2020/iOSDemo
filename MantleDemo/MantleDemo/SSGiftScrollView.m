//
//  SSGiftScrollView.m
//  SpiderSubscriber
//
//  Created by Czh on 15/9/7.
//  Copyright (c) 2015年 spider. All rights reserved.
//

#import "SSGiftScrollView.h"
#import "SSGiftView.h"
#import "SSToolsClass.h"

#define Width 112

@implementation SSGiftScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, 10, ScreenWidth, 118.0);
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(0, 0);
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;

}

- (void)setSsGiftArr:(NSArray *)ssGiftArr {
    
//    self.backgroundColor = [UIColor greenColor];
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    self.contentSize = CGSizeMake(ssGiftArr.count * (Width+0.5), 105);
    for (int i = 0; i < ssGiftArr.count; i++) {
        SSGiftView *gift = [[SSGiftView alloc] initWithFrame:CGRectMake((Width + 0.5) * i, 0, Width, 105)];
        gift.ssGiftInfo = ssGiftArr[i];
        gift.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGes:)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        [gift addGestureRecognizer:tapGes];
        if (i < ssGiftArr.count - 1 && ssGiftArr.count != 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(Width + (Width + 0.5) * i, 0, 0.5, 105)];
            line.backgroundColor = SS_LINE_COLOR;
            [self addSubview:line];
        }
        [self addSubview:gift];
    }
}

- (void)handleTapGes:(UITapGestureRecognizer *)ges {
    
    if (self.giftScrollViewDelegate&&[self.giftScrollViewDelegate respondsToSelector:@selector(giftScrollViewDidTapped)]) {
        [self.giftScrollViewDelegate giftScrollViewDidTapped];
    }
}

@end
