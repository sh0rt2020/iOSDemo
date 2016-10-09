//
//  SpiderLoading.m
//  WSProgressHUD
//
//  Created by Czh on 15/10/30.
//  Copyright © 2015年 wilson-yuan. All rights reserved.
//

#import "SpiderLoading.h"
#import "UIImage+GIF.h"
#import "UIImage+MultiFormat.h"
#import "SSToolsClass.h"

@interface SpiderLoading ()

@property (nonatomic, strong) UIView *sLoadView;
//@property (nonatomic, strong) UILabel *sTitleLab;
@property (nonatomic, strong) UIImageView *sImageView;
@property (nonatomic, strong) UIView *sBGv;
//@property (nonatomic, strong) UIWebView *sWebView;

@end

@implementation SpiderLoading

+ (SpiderLoading *)shareInstance {
    static dispatch_once_t once;
    static SpiderLoading *shareView;
    dispatch_once(&once, ^{
        shareView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
    });
    return shareView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.sBGv.frame =CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.sBGv];
        self.sLoadView.center = self.sBGv.center;
        [self addSubview:self.sLoadView];
//        [self.sLoadView addSubview:self.sWebView];
//        [self.sLoadView addSubview:self.sTitleLab];
        [self.sLoadView addSubview:self.sImageView];
        self.backgroundColor = [UIColor clearColor];
//        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin        | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

- (UIView *)sBGv {
    if (!_sBGv) {
        self.sBGv = [[UIView alloc] init];
        _sBGv.backgroundColor = [UIColor blackColor];
//        _sBGv.userInteractionEnabled = NO;
        _sBGv.alpha = 0.3;
    }
    return _sBGv;
}

- (UIView *)sLoadView {
    if (!_sLoadView) {
        self.sLoadView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 113, 113)];
        _sLoadView.backgroundColor = [UIColor redColor];
        _sLoadView.layer.cornerRadius = 4.0;
        _sLoadView.layer.masksToBounds = YES;
    }
    return _sLoadView;
}

- (UIImageView *)sImageView  {
    if (!_sImageView) {
        self.sImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 113, 113)];
        _sImageView.image = [UIImage sd_animatedGIFNamed:@"loading"];
    }
    return _sImageView;
}


+ (void)showLoading:(NSString *)title {
    if ([title isEqualToString:@"2"]) {
        [self shareInstance].frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49);
         [self shareInstance].sBGv.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49);
    } else if ([title isEqualToString:@"1"]) {
        [self shareInstance].frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
        [self shareInstance].sBGv.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    } else if ([title isEqualToString:@"3"]) {
        [self shareInstance].frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 113);
        [self shareInstance].sBGv.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight - 113);
    } else {
        [self shareInstance].frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self shareInstance].sBGv.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
     [self shareInstance].sLoadView.center = [self shareInstance].sBGv.center;
    [[self shareInstance] addOverlayViewToWindonWith:title];
}

+ (void)dismiss {
    [[self shareInstance] dismiss];
}

- (void)dismiss
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    
}


- (void)addOverlayViewToWindonWith:(NSString *)title
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.sLoadView.transform = CGAffineTransformScale(self.sLoadView.transform, 1.2, 1.2);
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.sLoadView.transform = CGAffineTransformScale(self.sLoadView.transform, 1/1.2, 1/1.2);
                         self.sLoadView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    [self.sImageView startAnimating];
    [self setNeedsDisplay];
}

@end
