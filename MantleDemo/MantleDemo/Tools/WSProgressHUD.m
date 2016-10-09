//
//  WSProgressHUD.m
//  WSProgressHUD
//
//  Created by Wilson-Yuan on 15/7/17.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSProgressHUD.h"
#import <objc/runtime.h>
#import "SSDatasInfo.h"

typedef NS_ENUM(NSInteger, WSProgressHUDType) {

    WSProgressHUDTypeImage,
};

@interface WSProgressHUD ()

@property (nonatomic, strong) UIControl *overlayView;

@property (nonatomic, strong) UILabel *labelView;

@property (nonatomic, strong) UIView *hudView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *currentString;

@end

static CGFloat stringWidth = 0.0f;
static CGFloat stringHeight = 0.0f;
static CGFloat maskTopEdge = 0;
static CGFloat maskBottomEdge = 0;

static CGFloat WSProgressHUDDefaultWidth = 50;
static CGFloat WSProgressHUDDefaultHeight = 50;

static CGRect WSProgressHUDStringRect;
static CGRect WSProgressHUDNewBounds;

static UIColor *WSProgressHUDForeGroundColor;
static UIColor *WSProgressHUDBackGroundColor;

static CGFloat WSProgressHUDShowDuration = 0.3;
static CGFloat WSProgressHUDDismissDuration = 0.15;
static CGFloat const WSProgressHUDHeightEdgeOffset = 8;
static CGFloat const WSProgressHUDImageTypeWidthEdgeOffset = 16;

@implementation WSProgressHUD

+ (WSProgressHUD *)shareInstance {
    static dispatch_once_t once;
    static WSProgressHUD *shareView;
    dispatch_once(&once, ^{
        shareView = [[self alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];

    });
    return shareView;
}
#pragma mark - Show image

+ (void)showError:(SSErrorInfo *)info {
    [self showSuccessWithStatus:info.message];
}

+ (void)showSuccessWithStatus: (NSString *)string
{
    [self showImage:nil status:string];
}
+ (void)showImage:(UIImage *)image status:(NSString *)title
{
    [[self shareInstance] showImage:image status:title];
    [[self shareInstance] addOverlayViewToWindow];
}
+ (void)dismiss {
    [[self shareInstance] dismiss];
}

#pragma mark - Progress
- (void)showImage:(UIImage *)image status:(NSString *)title
{
    NSAssert([NSThread isMainThread], @"WSProgressHUD show Must on main thread");
    [self setMaskEdgeWithType];
    self.currentString = title;
    [self updateSubviewsPosition];
    [self showHudViewWithAnimation];
    self.timer = [NSTimer timerWithTimeInterval:[self displayDurationForString:title] target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


#pragma mark - Pravite Method

- (void)showHudViewWithAnimation
{
    if (self.showOnTheWindow) {
        self.overlayView.userInteractionEnabled = NO;
    } else {
        self.userInteractionEnabled = NO;
    }
    objc_setAssociatedObject(self, @selector(hudIsShowing), @(1), OBJC_ASSOCIATION_ASSIGN);
    self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.2, 1.2);
    
    [UIView animateWithDuration:WSProgressHUDShowDuration
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.2, 1/1.2);
                         self.hudView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [self setNeedsDisplay];
    
}


- (void)dismiss
{
    if (!self.hudIsShowing || self.hudView.alpha != 1) {
        return;
    }
    [self invalidateTimer];
    objc_setAssociatedObject(self, @selector(hudIsShowing), @(0), OBJC_ASSOCIATION_ASSIGN);
    WSProgressHUDNewBounds = CGRectZero;
    self.hudView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:WSProgressHUDDismissDuration
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut
                     animations:^{
                         self.hudView.transform = CGAffineTransformScale(self.hudView.transform, .8, .8);
                         self.hudView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         self.hudView.transform = CGAffineTransformIdentity;
                         [self.overlayView removeFromSuperview];
                         self.userInteractionEnabled = NO;
                         [self setNeedsDisplay];
                     }];
}


- (void)addOverlayViewToWindow
{
    if(!self.overlayView.superview){
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
        }
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if (!self.superview) {
        [self.overlayView addSubview:self];
    }
    
    objc_setAssociatedObject(self, @selector(showOnTheWindow), @(1), OBJC_ASSOCIATION_ASSIGN);
}


- (void)updateSubviewsPosition
{
    NSString *string = self.currentString;
    CGSize hudSize = [self hudSizeWithString:string];
    CGRect hudBounds = CGRectMake(0, 0, hudSize.width, hudSize.height);
    [self updatePositionWithString:string hudBounds:hudBounds];
    
}

- (void)updatePositionWithString: (NSString *)string hudBounds: (CGRect)bounds
{
    CGFloat centerX = self.bounds.size.width / 2;
    CGFloat centerY = self.bounds.size.height / 2 - 20;
    self.hudView.bounds = bounds;
    self.labelView.frame = WSProgressHUDStringRect;//Reset the view frame
    self.hudView.center = CGPointMake(centerX, centerY);
    self.hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    CGFloat hudCenterX = CGRectGetWidth(bounds)/2;
    CGFloat hudCenterY = CGRectGetHeight(bounds)/2;
    self.labelView.text = string;
    self.labelView.center = CGPointMake(hudCenterX, hudCenterY);
    
}
- (CGFloat)valueByScreenScale: (CGFloat)value
{
    return ([UIScreen mainScreen].bounds.size.width / 320 * value);
}

- (CGSize)hudSizeWithString: (NSString *)string
{
    WSProgressHUDStringRect = CGRectZero;
    WSProgressHUDDefaultHeight = 50;
    WSProgressHUDDefaultWidth = 50;
    CGSize constraintSize = CGSizeMake([self valueByScreenScale:200], [self valueByScreenScale:300]);
    
    WSProgressHUDStringRect.size = [string boundingRectWithSize:constraintSize
                                                        options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                                     attributes:@{NSFontAttributeName: self.labelView.font}
                                                        context:NULL].size;
    stringWidth =  ceilf(WSProgressHUDStringRect.size.width);
    stringHeight = ceilf(WSProgressHUDStringRect.size.height);
    self.labelView.hidden = NO;
    self.labelView.text = string;
    WSProgressHUDDefaultHeight = stringHeight + WSProgressHUDHeightEdgeOffset;
    WSProgressHUDDefaultWidth = stringWidth + WSProgressHUDImageTypeWidthEdgeOffset;
    return CGSizeMake(WSProgressHUDDefaultWidth, WSProgressHUDDefaultHeight);
}

- (void)setMaskEdgeWithType
{
    maskBottomEdge = 0;
    maskTopEdge = 0;
    self.overlayView.frame = CGRectMake(0, maskTopEdge, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - maskTopEdge - maskBottomEdge);
    if (self.showOnTheWindow) {
        CGRect rect = self.bounds;
        rect.size = self.overlayView.frame.size;
        self.bounds = rect;
    }
}

- (void)invalidateTimer
{
    if (self.timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)setTimer:(NSTimer *)timer
{
    [self invalidateTimer];
    if (timer) {
        _timer = timer;
    }
}
- (NSTimeInterval)displayDurationForString:(NSString*)string {
    CGFloat duration = MIN((CGFloat)string.length*0.06 + 0.5, 5.0);
    if (duration < 1.0) {
        duration = 1.0;
    }
    return duration;
}

- (CGFloat)maskTopEdge
{
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return 32;
    } else {
        return 64;
    }
}
#pragma mark - Draw rect
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0 alpha:0] set];
    CGRect bounds = self.bounds;
    CGContextFillRect(context, bounds);
}
#pragma mark - Init View
- (instancetype)initWithView:(UIView *)view {
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        WSProgressHUDForeGroundColor = [UIColor whiteColor];
        WSProgressHUDBackGroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        [self addSubview:self.hudView];
        [self.hudView addSubview:self.labelView];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin        | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}
- (UIView *)hudView
{
    if (!_hudView) {
        _hudView = [[UIView alloc] init];
        _hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _hudView.layer.cornerRadius = 3.5;
        _hudView.layer.masksToBounds = YES;
        _hudView.alpha = 0;
        _hudView.contentScaleFactor = [UIScreen mainScreen].scale;
    }
    return _hudView;
}

- (UILabel *)labelView
{
    if (!_labelView) {
        _labelView = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelView.textColor = [UIColor whiteColor];
        _labelView.backgroundColor = [UIColor clearColor];
//        if ([UIFont respondsToSelector:@selector(preferredFontForTextStyle:)]) {
//            _labelView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//        } else {
            _labelView.font = [UIFont systemFontOfSize:14];
//        }
        _labelView.adjustsFontSizeToFitWidth = YES;
        _labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _labelView.textAlignment = NSTextAlignmentCenter;
        _labelView.numberOfLines = 0;
    }
    return _labelView;
}
- (UIControl *)overlayView {
    if(!_overlayView) {
        CGRect windowBounds = [UIApplication sharedApplication].keyWindow.bounds;
        _overlayView = [[UIControl alloc] initWithFrame:windowBounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
    }
    return _overlayView;
}
- (BOOL)hudIsShowing
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (BOOL)showOnTheWindow
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


@end
