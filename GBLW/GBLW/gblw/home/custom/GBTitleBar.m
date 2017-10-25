//
//  GBTitleBar.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/17.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBTitleBar.h"

#define TitleButtonWidth  (SCREEN_W-30*2)/4
#define TitleButtonHeight  30
#define UnderLineTipWidth  TitleButtonWidth-44
#define UnderLineTipHeight  4

static NSInteger const TitleBaseTag = 1000;

@interface GBTitleBar () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) CALayer *underLineTip;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation GBTitleBar

#pragma mark - init
- (id)initWithTitles:(NSArray *)titles {
    self = [super init];
    if (self) {
        self.titles = titles;
        [self addSubview:self.contentScrollView];
        
        [self configTitles:titles];
    }
    return self;
}

#pragma mark - delegate


#pragma mark - public

#pragma mark - private
- (void)configTitles:(NSArray *)titles {
    
    int i = 0;
    for (NSString *title in titles) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*TitleButtonWidth+30, 8, TitleButtonWidth, TitleButtonHeight)];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.tag = TitleBaseTag + i;
        [btn addTarget:self action:@selector(handleTitleSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:btn];
        
        i += 1;
    }
}


#pragma mark - event
- (void)handleTitleSelected:(UIButton *)sender {
    NSInteger index = sender.tag - TitleBaseTag;
    [UIView animateWithDuration:0.3 animations:^{
        self.underLineTip.frame = CGRectMake(index*TitleButtonWidth+30+22, TitleButtonHeight+10, UnderLineTipWidth, UnderLineTipHeight);
    } completion:^(BOOL finished) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(titleBarDidSelected:)]) {
            [self.delegate titleBarDidSelected:index];
        }
    }];
}

#pragma mark - setter & getter
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, 44)];
        _contentScrollView.delegate = self;
        _contentScrollView.scrollEnabled = YES;
        [_contentScrollView.layer addSublayer:self.underLineTip];
    }
    return _contentScrollView;
}

- (CALayer *)underLineTip {
    if (!_underLineTip) {
        _underLineTip = [[CALayer alloc] init];
        _underLineTip.frame = CGRectMake(30+22, TitleButtonHeight+9, UnderLineTipWidth, UnderLineTipHeight);
        _underLineTip.cornerRadius = 2.0;
        _underLineTip.backgroundColor = ColorHex(@"ffc000").CGColor;
    }
    return _underLineTip;
}

@end
