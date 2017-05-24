//
//  UCRedPocketView.m
//  Doctor
//
//  Created by Yige on 2016/11/9.
//  Copyright © 2016年 YiGeMed. All rights reserved.
//

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define AL_TAB_BAR_HEIGHT                           49.f

#define Pocket_Position_Y  75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0+(318.0/245.0*(SCREEN_WIDTH-65.0*2))/2

#import "UCRedPocketView.h"

@interface UCRedPocketView () {
    CGPoint pCenter;
}

@property (nonatomic, nonnull) UIImageView *bgView; //绿色背景
@property (nonatomic, nonnull) UIImageView *logoView; //logo
@property (nonatomic, nonnull) UIImageView *cloudShadowView; //最里面的云的影子
@property (nonatomic, nonnull) UIImageView *bgMaskView; //红包遮罩背景
@property (nonatomic, nonnull) UIImageView *pocketMaskView; //红包遮罩
@property (nonatomic, nonnull) UIImageView *cloudView;  //底部的浮云
@property (nonatomic, nonnull) UIImageView *cloudViewEmpty;  //无红包状态下的浮云
@property (nonatomic, nonnull) UIImageView *titleView;  //头部文字
@property (nonatomic, nonnull) UIImageView *tipView; //矩形提示框
@property (nonatomic, nonnull) UILabel *tipLab; //红包数量提示

@property (nonatomic, nonnull) UIButton *openBtn;  //开红包按钮
//@property (nonatomic, nonnull) UIDynamicAnimator *animator;  //负责控制动画
@end

@implementation UCRedPocketView
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark - response method
- (void)didClickOpen:(UIButton *)sender {
    NSLog(@"%s", __func__);
//    [self fireEvent:EventRPOpen];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didClickOpenRedPocket:)]) {
        [self.delegate didClickOpenRedPocket:sender];
    }
}

#pragma mark - private method
- (void)createUI {
    [self addSubview:self.bgView];
    [self addSubview:self.logoView];
    [self addSubview:self.cloudShadowView];
    [self addSubview:self.pocketView];
    [self addSubview:self.pocketMaskView];
    [self addSubview:self.tipView];
    [self addSubview:self.tipLab];
    [self addSubview:self.bgMaskView];
    [self addSubview:self.cloudView];
    [self addSubview:self.cloudViewEmpty];
    [self addSubview:self.titleView];
    [self addSubview:self.openBtn];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor greenColor];
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
}

- (void)layoutUI {
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _logoView, _cloudShadowView, _pocketView, _pocketMaskView, _bgMaskView, _cloudView, _cloudViewEmpty, _titleView, _openBtn, _tipView, _tipLab);
    NSDictionary *metrics = @{@"Logo_Width":@(57.0/(375.0-14.0)*(SCREEN_WIDTH-14.0)),
                              @"Logo_Height":@(26.0/57.0*57.0/(375.0-14.0)*(SCREEN_WIDTH-14.0)),
                              @"Title_Height":@(66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)),
                              @"CloudShadow_Height":@(132.0/375.0*SCREEN_WIDTH),
                              @"Pocket_Top":@(75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0),
                              @"Pocket_Top_Animate":@(-180),
                              @"Pocket_Height":@(318.0/245.0*(SCREEN_WIDTH-65.0*2)),
                              @"Pocket_Width":@(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0),
                              @"Pocket_Leading_Gap":@((SCREEN_WIDTH-318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)/2),
                              @"Cloud_Height":@(137.0/375.0*SCREEN_WIDTH),
                              @"PocketMask_Height":@(318.0/245.0*(SCREEN_WIDTH-65.0*2)-11.0),
                              @"OpenBtn_Top":@(75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0+35.0),
                              @"OpenBtn_Leading_Gap":@(SCREEN_WIDTH/2-84.0/2),
                              @"CloudEmpty_Height":@(137.0/375.0*SCREEN_WIDTH-20),
                              @"Tip_Height":@(49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)),
                              @"Tip_Width":@(155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)),
                              @"Tip_Top":@(75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0+230.0/318.0*318.0/245.0*(SCREEN_WIDTH-65.0*2)),
                              @"Tip_Leading_Gap":@(SCREEN_WIDTH/2-155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)/2)};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-0-|" options:NSLayoutFormatAlignAllCenterX|NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bgView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_logoView(Logo_Height)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_logoView(Logo_Width)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cloudShadowView(CloudShadow_Height)]-(0@1000)-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_cloudShadowView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Pocket_Top-[_pocketView(Pocket_Height)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-Pocket_Leading_Gap-[_pocketView(Pocket_Width)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Pocket_Top-[_pocketMaskView(PocketMask_Height)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-Pocket_Leading_Gap-[_pocketMaskView(Pocket_Width)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgMaskView]-0-|" options:NSLayoutFormatAlignAllCenterY|NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bgMaskView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cloudView(Cloud_Height)]-(0@1000)-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_cloudView]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cloudViewEmpty(CloudEmpty_Height)]-(0@1000)-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_cloudViewEmpty]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-75-[_titleView(Title_Height)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_titleView]-18-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-OpenBtn_Top-[_openBtn(84)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-OpenBtn_Leading_Gap-[_openBtn(84)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Tip_Top-[_tipView(Tip_Height)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-Tip_Leading_Gap-[_tipView(Tip_Width)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Tip_Top-[_tipLab(Tip_Height)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-Tip_Leading_Gap-[_tipLab(Tip_Width)]" options:0 metrics:metrics views:views]];
    
//    [self appearAnimate];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutUI];
    [self appearAnimate];
    
//    [self animate];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
//    self.pocketView.transform = CGAffineTransformScale(self.pocketView.transform, 0.1, 0.1);
    
    [self animate];
}

- (void)animate {
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.fromValue = @(0.2f);
    scale.toValue = @(1.0);
    scale.duration = 0.5;
    [self.pocketView.layer addAnimation:scale forKey:nil];

    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 0.9;
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, -SCREEN_HEIGHT)],
                         [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, Pocket_Position_Y)],
                         [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, Pocket_Position_Y-30)],
                         [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, Pocket_Position_Y)],
                         [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, Pocket_Position_Y-10)],
                         [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, Pocket_Position_Y)]
                         ];
    animation.timingFunctions = @[
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]
                                  ];
    animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9];
    self.pocketView.layer.position = CGPointMake(SCREEN_WIDTH/2, Pocket_Position_Y);
    [self.pocketView.layer addAnimation:animation forKey:nil];
}


- (void)appearAnimate {
    

//    _bgMaskView.frame = CGRectMake(0, -SCREEN_HEIGHT+AL_TAB_BAR_HEIGHT, [UIApplication sharedApplication].keyWindow.bounds.size.width, SCREEN_HEIGHT-AL_TAB_BAR_HEIGHT);
//    _bgMaskView.center = CGPointMake(SCREEN_WIDTH/2, -SCREEN_HEIGHT/2);
//    _pocketView.frame = CGRectMake(0, 75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0-SCREEN_HEIGHT, 1, 1);
//    _pocketView.frame = CGRectMake(0, 75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0-SCREEN_HEIGHT, 318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0, 318.0/245.0*(SCREEN_WIDTH-65.0*2));
//    _pocketView.center = CGPointMake(SCREEN_WIDTH/2, -SCREEN_HEIGHT/2);
    

    
//    [UIView animateKeyframesWithDuration:1.6 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
////        NSLog(@"============%@==========", NSStringFromCGRect(_pocketView.frame));
//        
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.4 animations:^{
//            _bgMaskView.center = CGPointMake(SCREEN_WIDTH/2, ((SCREEN_HEIGHT-AL_TAB_BAR_HEIGHT)/2+SCREEN_HEIGHT/2)/3-SCREEN_HEIGHT/2);
//        }];
//        
//        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.4 animations:^{
//            _bgMaskView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-AL_TAB_BAR_HEIGHT)/2);
//        }];
//
//        
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.4 animations:^{
//            _pocketView.frame = CGRectMake(0, 0, 318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0/3, 318.0/245.0*(SCREEN_WIDTH-65.0*2)/3);
//            _pocketView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3-SCREEN_HEIGHT/2);
//        }];
//
//        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.4 animations:^{
//            _pocketView.frame = CGRectMake(0, 0, 318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0, 318.0/245.0*(SCREEN_WIDTH-65.0*2));
//            _pocketView.center = CGPointMake(SCREEN_WIDTH/2, 75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0+(318.0/245.0*(SCREEN_WIDTH-65.0*2))/2);
//        }];
//        
//        pCenter = _pocketView.center;
//        
//        //下落动画结束 开始弹跳动画
//        [UIView addKeyframeWithRelativeStartTime:0.9 relativeDuration:0.2 animations:^{
//            _pocketView.center = CGPointMake(SCREEN_WIDTH/2, pCenter.y-15);
//        }];
//        
//        [UIView addKeyframeWithRelativeStartTime:1.1 relativeDuration:0.1 animations:^{
//            _pocketView.center = CGPointMake(SCREEN_WIDTH/2, pCenter.y-20);
//        }];
//        
//        
//        [UIView addKeyframeWithRelativeStartTime:1.3 relativeDuration:0.1 animations:^{
//            _pocketView.center = CGPointMake(SCREEN_WIDTH/2, pCenter.y-15);
//        }];
//        
//        [UIView addKeyframeWithRelativeStartTime:1.4 relativeDuration:0.2 animations:^{
//            _pocketView.center = CGPointMake(SCREEN_WIDTH/2, pCenter.y);
//        }];
//    } completion:^(BOOL finished) {
//        //弹跳停止 显示标题、红包数量提示、替换云
//        [UIView animateWithDuration:0.1 animations:^{
////            _titleView.alpha = 1;
////            _tipLab.alpha = 1;
////            _tipView.alpha = 1;
//        } completion:^(BOOL finished) {
//            _cloudView.hidden = NO;
//            _cloudViewEmpty.hidden = YES;
////            _pocketMaskView.hidden = NO;
//        }];
//    }];
}

- (void)disappearAnimateCompleted:(void (^)(UCRedPocketView *ss))completed {
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.4 animations:^{
            _tipView.alpha = 0;
            _tipLab.alpha = 0;
            _tipView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0));
            _tipLab.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0));
            _pocketMaskView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+318.0/245.0*(SCREEN_WIDTH-65.0*2)/2);
        }];
    } completion:^(BOOL finished) {
        completed(self);
    }];
}

- (void)resetView {
    _tipLab.alpha = 1;
    _tipView.alpha = 1;
    _tipView.center = CGPointMake(SCREEN_WIDTH/2, 49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)/2+75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0+230.0/318.0*318.0/245.0*(SCREEN_WIDTH-65.0*2));
    _tipLab.center = CGPointMake(SCREEN_WIDTH/2, 49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)/2+75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0+230.0/318.0*318.0/245.0*(SCREEN_WIDTH-65.0*2));
    _pocketMaskView.center = _pocketView.center;
    _pocketMaskView.hidden = NO;
}

#pragma mark - getter&setter
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.translatesAutoresizingMaskIntoConstraints = NO;
        _bgView.image = [UIImage imageNamed:@"bg"];
    }
    return _bgView;
}

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
        _logoView.translatesAutoresizingMaskIntoConstraints = NO;
        _logoView.image = [UIImage imageNamed:@"logo_1"];
        _logoView.backgroundColor = [UIColor clearColor];
    }
    return _logoView;
}

- (UIImageView *)cloudShadowView {
    if (!_cloudShadowView) {
        _cloudShadowView = [UIImageView new];
        _cloudShadowView.translatesAutoresizingMaskIntoConstraints = NO;
        _cloudShadowView.image = [UIImage imageNamed:@"xbg"];
    }
    return _cloudShadowView;
}

- (UIImageView *)bgMaskView {
    if (!_bgMaskView) {
        _bgMaskView = [UIImageView new];
        _bgMaskView.translatesAutoresizingMaskIntoConstraints = NO;
        _bgMaskView.image = [UIImage imageNamed:@"bgmask"];
    }
    return _bgMaskView;
}

- (UIImageView *)pocketView {
    if (!_pocketView) {
        _pocketView = [UIImageView new];
        _pocketView.translatesAutoresizingMaskIntoConstraints = NO;
        _pocketView.image = [UIImage imageNamed:@"pocket_1"];
        _pocketView.hidden = NO;
    }
    return _pocketView;
}

- (UIImageView *)pocketMaskView {
    if (!_pocketMaskView) {
        _pocketMaskView = [UIImageView new];
        _pocketMaskView.translatesAutoresizingMaskIntoConstraints = NO;
        _pocketMaskView.image = [UIImage imageNamed:@"pocket_2"];
        _pocketMaskView.hidden = YES;
    }
    return _pocketMaskView;
}

- (UIImageView *)cloudView {
    if (!_cloudView) {
        _cloudView = [UIImageView new];
        _cloudView.translatesAutoresizingMaskIntoConstraints = NO;
        _cloudView.image = [UIImage imageNamed:@"cloud_1"];
        _cloudView.hidden = YES;
    }
    return _cloudView;
}

- (UIImageView *)cloudViewEmpty {
    if (!_cloudViewEmpty) {
        _cloudViewEmpty = [UIImageView new];
        _cloudViewEmpty.translatesAutoresizingMaskIntoConstraints = NO;
        _cloudViewEmpty.image = [UIImage imageNamed:@"cloud_2"];
        _cloudViewEmpty.hidden = NO;
    }
    return _cloudViewEmpty;
}

- (UIImageView *)titleView {
    if (!_titleView) {
        _titleView = [UIImageView new];
        _titleView.translatesAutoresizingMaskIntoConstraints = NO;
        _titleView.image = [UIImage imageNamed:@"title"];
        _titleView.alpha = 0;
    }
    return _titleView;
}

- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [UIButton new];
        _openBtn.backgroundColor = [UIColor clearColor];
        _openBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_openBtn addTarget:self action:@selector(didClickOpen:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

- (UIImageView *)tipView {
    if (!_tipView) {
        _tipView = [UIImageView new];
        _tipView.translatesAutoresizingMaskIntoConstraints = NO;
        _tipView.image = [UIImage imageNamed:@"pocketnum"];
        _tipView.alpha = 0;
    }
    return _tipView;
}

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [UILabel new];
        _tipLab.textColor = [UIColor whiteColor];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.font = [UIFont systemFontOfSize:18.0];
        _tipLab.translatesAutoresizingMaskIntoConstraints = NO;
        _tipLab.alpha = 0;
        if (!self.count||self.count.length == 0) {
            self.count = @"0";
        }
        _tipLab.text = [NSString stringWithFormat:@"待拆红包 %@ 个", self.count];
    }
    return _tipLab;
}

- (void)setCount:(NSString *)count {
    if (_count != count) {
        _count = count;
        self.tipLab.text = [NSString stringWithFormat:@"待拆红包%@个", _count];
    }
}
@end
