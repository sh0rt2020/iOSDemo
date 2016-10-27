//
//  TipView.m
//  YeWen
//
//  Created by Luye on 16/7/30.
//  Copyright © 2016年 YiGeMed. All rights reserved.
//

#import "NoAccess.h"

@interface NoAccess ()
{
    UIView *            _maskView;
    UIView  *          _contentView;
}

@end

@implementation NoAccess

- (instancetype)init
{
    if (self = [super init]) {
        [self p_initUI];
    }
    return self;
}

#pragma mark - private method
- (void)p_initUI
{
    self.backgroundColor = [UIColor clearColor];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    _maskView = [[UIView alloc] initWithFrame:window.bounds];
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _maskView.userInteractionEnabled = YES;
    [window addSubview:_maskView];
    
    _maskView.hidden = YES;
    self.hidden = YES;
    
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_maskView addGestureRecognizer:tap1];
    
    self.frame = CGRectMake(50,  window.bounds.size.height / 2.0 - ( window.bounds.size.width - 160)/2.0, window.bounds.size.width -100, window.bounds.size.width - 160);
    _contentView =  [[NSBundle mainBundle] loadNibNamed:@"NoAccessContent" owner:nil options:nil][0];;
    _contentView.frame = self.bounds;
    self.layer.cornerRadius = 5;
    _contentView.layer.cornerRadius = 5;
    _contentView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_contentView addGestureRecognizer:tap2];
    [self addSubview:_contentView];
    [window addSubview:self];
}

#pragma mark - public method
- (void)show
{
    [_maskView setHidden:NO];
    [self setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide
{
  
    [UIView animateWithDuration:0.3 animations:^{
      
    } completion:^(BOOL finished) {
        [_maskView setHidden:YES];
        [self setHidden:YES];
        
        if (self.delegate) {
            [self.delegate hidenNoaccess];
        }
    }];
}

- (void)dealloc
{
    for (UIGestureRecognizer* ges in _maskView.gestureRecognizers) {
        [_maskView removeGestureRecognizer:ges];
    }
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}


@end
