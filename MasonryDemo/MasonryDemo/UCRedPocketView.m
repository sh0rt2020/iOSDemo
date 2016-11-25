//
//  UCRedPocketView.m
//  Doctor
//
//  Created by Yige on 2016/11/9.
//  Copyright © 2016年 YiGeMed. All rights reserved.
//


#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height

#define Pocket_Position_Y       75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0+(318.0/245.0*(SCREEN_WIDTH-65.0*2))/2
#define LogoHeight              26.0/57.0*57.0/(375.0-14.0)*(SCREEN_WIDTH-14.0)
#define LogoWidth               57.0/(375.0-14.0)*(SCREEN_WIDTH-14.0)
#define NoPocketHeight          300.0/314.0*(SCREEN_WIDTH-2*30)
#define NoPocketWidth           SCREEN_WIDTH-2*30
#define CloudShadowHeight       132.0/375.0*SCREEN_WIDTH
#define TitleHeight             66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)
#define PocketTop               75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0
#define PocketHeight            318.0/245.0*(SCREEN_WIDTH-65.0*2)
#define PocketWidth             318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0
#define PocketLeadingGap        (SCREEN_WIDTH-318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)/2
#define CloudHeight             137.0/375.0*SCREEN_WIDTH
#define PocketMaskHeight        318.0/245.0*(SCREEN_WIDTH-65.0*2)-11.0
#define OpenBtnTop              75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0+35.0
#define OpenBtnLeadingGap       SCREEN_WIDTH/2-84.0/2
#define CloudEmptyHeight        137.0/375.0*SCREEN_WIDTH-20
#define TipWidth                155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)
#define TipHeight               49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)
#define TipTop                  75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0+230.0/318.0*318.0/245.0*(SCREEN_WIDTH-65.0*2)
#define TipLeadingGap           SCREEN_WIDTH/2-155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)/2

#import "UCRedPocketView.h"
//#import "NBLabel.h"

static NSInteger const MaxWordNum = 20;

@interface UCRedPocketView () <CAAnimationDelegate> {
    CGPoint pCenter;
}

@property (nonatomic, nonnull) UIImageView *bgView; //绿色背景
@property (nonatomic, nonnull) UIImageView *logoView; //logo
@property (nonatomic, nonnull) UIImageView *cloudShadowView; //最里面的云的影子
@property (nonatomic, nonnull) UIImageView *bgMaskView; //红包遮罩背景
@property (nonatomic, nonnull) UIImageView *pocketView;  //红包
@property (nonatomic, nonnull) UIImageView *pocketMaskView; //红包遮罩
@property (nonatomic, nonnull) UIImageView *cloudView;  //底部的浮云
@property (nonatomic, nonnull) UIImageView *cloudViewEmpty;  //无红包状态下的浮云
//@property (nonatomic, nonnull) UIImageView *titleView;  //头部文字
@property (nonatomic, nonnull) UILabel *titleView;  //头部标题
@property (nonatomic, nonnull) UIImageView *tipView; //矩形提示框
@property (nonatomic, nonnull) UILabel *tipLab; //红包数量提示

@property (nonatomic, nonnull) UIButton *openBtn;  //开红包按钮

@end

@implementation UCRedPocketView
#pragma mark - life cycle
- (instancetype)init {
    
    if (self = [super init]) {
        if ([self respondsToSelector:@selector(createUI)]) {
            [self createUI];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    [self layoutUI];
}


#pragma mark - response method
- (void)didClickOpen:(UIButton *)sender {
    NSLog(@"%s", __func__);
//    [self fireEvent:EventRPOpen];
}

#pragma mark - CAAnimationDelegate
//弹跳的动画完成
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [UIView animateWithDuration:0.3 animations:^{
        self.titleView.alpha = 1.0;
        self.tipLab.alpha = 1.0;
        self.tipView.alpha = 1.0;
        self.cloudView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.pocketMaskView.alpha = 1.0;
        self.cloudViewEmpty.alpha = 0.0;
    }];
}

#pragma mark - private method
- (void)createUI {
    [self addSubview:self.bgView];
    [self addSubview:self.noPocketView];
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
    self.backgroundColor = [UIColor clearColor];
    
    [self configView];
}

- (void)layoutUI {
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _logoView, _cloudShadowView, _pocketView, _pocketMaskView, _bgMaskView, _cloudView, _cloudViewEmpty, _titleView, _openBtn, _tipView, _tipLab, _noPocketView);
    NSDictionary *metrics = @{@"Logo_Width":@(57.0/(375.0-14.0)*(SCREEN_WIDTH-14.0)),
                              @"Logo_Height":@(26.0/57.0*57.0/(375.0-14.0)*(SCREEN_WIDTH-14.0)),
                              @"NoPocket_Height":@(300.0/314.0*(SCREEN_WIDTH-2*30)),
                              @"NoPocket_Width":@(SCREEN_WIDTH-2*30),
                              @"Title_Height":@(66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)),
                              @"CloudShadow_Height":@(132.0/375.0*SCREEN_WIDTH),
                              @"Pocket_Top":@(75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0),
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
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-114-[_noPocketView(NoPocket_Height)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_noPocketView(NoPocket_Width)]-30-|" options:0 metrics:metrics views:views]];
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
    
    //
//    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.logoView.frame = CGRectMake(14, 14, LogoWidth, LogoHeight);
//    self.noPocketView.frame = CGRectMake(30, 114, NoPocketWidth, NoPocketHeight);
//    self.cloudShadowView.frame = CGRectMake(0, SCREEN_HEIGHT-CloudShadowHeight, SCREEN_WIDTH, CloudShadowHeight);
//    self.pocketView.frame = CGRectMake(PocketLeadingGap, PocketTop, PocketWidth, PocketHeight);
//    self.pocketMaskView.frame = CGRectMake(PocketLeadingGap, PocketTop, PocketWidth, PocketMaskHeight);
//    self.bgMaskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.cloudView.frame = CGRectMake(0, SCREEN_HEIGHT-CloudHeight, SCREEN_WIDTH, CloudHeight);
//    self.cloudViewEmpty.frame = CGRectMake(0, SCREEN_HEIGHT-CloudShadowHeight, SCREEN_WIDTH, CloudShadowHeight);
//    self.titleView.frame = CGRectMake(18, 75, SCREEN_WIDTH-2*18, TitleHeight);
//    self.openBtn.frame = CGRectMake(OpenBtnLeadingGap, OpenBtnTop, 84, 84);
//    self.tipView.frame = CGRectMake(TipLeadingGap, TipTop, TipWidth, TipHeight);
//    self.tipLab.frame = CGRectMake(TipLeadingGap, TipTop, TipWidth, TipHeight);
}

- (void)appearAnimate {
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.fromValue = @(0.2f);
    scale.toValue = @(1.0);
    scale.duration = 0.5;
    [self.pocketView.layer addAnimation:scale forKey:nil];
    
    CABasicAnimation *move = [CABasicAnimation animation];
    move.keyPath = @"position.y";
    move.fromValue = @(-SCREEN_HEIGHT);
    move.toValue = @(SCREEN_HEIGHT/2);
    move.duration = 0.45;
    move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.bgMaskView.layer addAnimation:move forKey:nil];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 0.9;
    animation.delegate = self;
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

- (void)dropViewCompleted:(void (^)(BOOL finished))complete {
    
    [UIView animateWithDuration:0.5 animations:^{
        _tipView.alpha = 0;
        _tipLab.alpha = 0;
        _tipView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0));
        _tipLab.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0));
        _pocketMaskView.frame = CGRectMake(0, 0, 1, 1);
        _pocketMaskView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+318.0/245.0*(SCREEN_WIDTH-65.0*2)/2);
    } completion:^(BOOL finished) {
        [self resetView];
        complete(finished);
    }];
}

//还有剩余红包
- (void)resetView {
    _tipLab.alpha = 1;
    _tipView.alpha = 1;
    _tipView.center = CGPointMake(SCREEN_WIDTH/2, 49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)/2+75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0+230.0/318.0*318.0/245.0*(SCREEN_WIDTH-65.0*2));
    _tipLab.center = CGPointMake(SCREEN_WIDTH/2, 49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0)/2+75.0+66.0/(375.0-18.0*2)*(SCREEN_WIDTH-18.0*2)+24.0+230.0/318.0*318.0/245.0*(SCREEN_WIDTH-65.0*2));
    _pocketMaskView.center = _pocketView.center;
    _pocketMaskView.frame = CGRectMake(_pocketView.frame.origin.x, _pocketView.frame.origin.y, _pocketView.frame.size.width, 318.0/245.0*(SCREEN_WIDTH-65.0*2)-11.0);
    _pocketMaskView.alpha = 1;
}

//没有剩余红包
- (void)clearViewCompleted:(void (^)(BOOL finished))complete {
    _pocketMaskView.alpha = 0;
    _noPocketView.alpha = 1.0;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _cloudView.alpha = 0.0;
        _titleView.alpha = 0;
        _tipView.alpha = 0;
        _tipLab.alpha = 0;
        _tipView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0));
        _tipLab.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+49.0/155.0*155.0/245.0*(318.0/245.0*(SCREEN_WIDTH-65.0*2)*245.0/318.0));
        _pocketView.frame = CGRectMake(0, 0, 1, 1);
        _pocketView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+318.0/245.0*(SCREEN_WIDTH-65.0*2)/2);
        _bgMaskView.center = CGPointMake(SCREEN_WIDTH/2, 2*SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        _cloudViewEmpty.alpha = 1.0;
        complete(finished);
    }];
}

- (void)configView {
    _pocketView.alpha = 1;
    _pocketMaskView.alpha = 0;
    _noPocketView.alpha = 0;
    _titleView.alpha = 0;
    _tipView.alpha = 0;
    _tipLab.alpha = 0;
    _bgMaskView.alpha = 1;
    _cloudView.alpha = 0;
    _cloudViewEmpty.alpha = 1;
    
    
    _bgView.translatesAutoresizingMaskIntoConstraints = NO;
    _logoView.translatesAutoresizingMaskIntoConstraints = NO;
    _cloudShadowView.translatesAutoresizingMaskIntoConstraints = NO;
    _bgMaskView.translatesAutoresizingMaskIntoConstraints = NO;
    _pocketView.translatesAutoresizingMaskIntoConstraints = NO;
    _pocketMaskView.translatesAutoresizingMaskIntoConstraints = NO;
    _cloudView.translatesAutoresizingMaskIntoConstraints = NO;
    _cloudViewEmpty.translatesAutoresizingMaskIntoConstraints = NO;
    _titleView.translatesAutoresizingMaskIntoConstraints = NO;
    _openBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _tipView.translatesAutoresizingMaskIntoConstraints = NO;
    _tipLab.translatesAutoresizingMaskIntoConstraints = NO;
    _noPocketView.translatesAutoresizingMaskIntoConstraints = NO;
}


#pragma mark - getter&setter
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.image = [UIImage imageNamed:@"bg"];
    }
    return _bgView;
}

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [UIImageView new];
        _logoView.image = [UIImage imageNamed:@"logo_1"];
        _logoView.backgroundColor = [UIColor clearColor];
    }
    return _logoView;
}

- (UIImageView *)cloudShadowView {
    if (!_cloudShadowView) {
        _cloudShadowView = [UIImageView new];
        _cloudShadowView.image = [UIImage imageNamed:@"xbg"];
    }
    return _cloudShadowView;
}

- (UIImageView *)bgMaskView {
    if (!_bgMaskView) {
        _bgMaskView = [UIImageView new];
        _bgMaskView.image = [UIImage imageNamed:@"bgmask"];
        _bgMaskView.alpha = 0;
    }
    return _bgMaskView;
}

- (UIImageView *)pocketView {
    if (!_pocketView) {
        _pocketView = [UIImageView new];
        _pocketView.image = [UIImage imageNamed:@"pocket_1"];
        _pocketView.alpha = 0;
    }
    return _pocketView;
}

- (UIImageView *)pocketMaskView {
    if (!_pocketMaskView) {
        _pocketMaskView = [UIImageView new];
        _pocketMaskView.image = [UIImage imageNamed:@"pocket_2"];
        _pocketMaskView.alpha = 0;
    }
    return _pocketMaskView;
}

- (UIImageView *)cloudView {
    if (!_cloudView) {
        _cloudView = [UIImageView new];
        _cloudView.image = [UIImage imageNamed:@"cloud_1"];
        _cloudView.alpha = 0;
    }
    return _cloudView;
}

- (UIImageView *)cloudViewEmpty {
    if (!_cloudViewEmpty) {
        _cloudViewEmpty = [UIImageView new];
        _cloudViewEmpty.image = [UIImage imageNamed:@"cloud_2"];
        _cloudViewEmpty.alpha = 1;
    }
    return _cloudViewEmpty;
}

- (UILabel *)titleView {
    
    if (!_titleView) {
        _titleView = [UILabel new];
//        _titleView.lines = 2;
//        _titleView.maxNum = MaxWordNum;
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.alpha = 0;
    }
    return _titleView;
}

- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [UIButton new];
        _openBtn.backgroundColor = [UIColor clearColor];
        [_openBtn addTarget:self action:@selector(didClickOpen:) forControlEvents:UIControlEventTouchUpInside];
        _openBtn.hidden = NO;
    }
    return _openBtn;
}

- (UIImageView *)tipView {
    if (!_tipView) {
        _tipView = [UIImageView new];
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
        self.tipLab.text = [NSString stringWithFormat:@"待拆红包 %@ 个", _count];
    }
}

- (UIImageView *)noPocketView {
    if (!_noPocketView) {
        _noPocketView = [UIImageView new];
        _noPocketView.backgroundColor = [UIColor clearColor];
        _noPocketView.image = [UIImage imageNamed:@"nopocket"];
        _noPocketView.alpha = 0;
    }
    return _noPocketView;
}

- (void)setTitle:(NSString *)title {
    
    if (_title != title) {
        _title = title;
//        _titleView.title = _title;
        _titleView.text = _title;
    }
}
@end
