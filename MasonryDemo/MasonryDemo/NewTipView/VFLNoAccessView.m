//
//  VFLNoAccessView.m
//  NoAccessDemo
//
//  Created by Yige on 2016/10/27.
//  Copyright © 2016年 Yige. All rights reserved.
//

#define SELF_FRAME CGRectMake(0, 0, WIDTH, HEIGHT)

#import "VFLNoAccessView.h"

static CGFloat const WIDTH = 226.0;
static CGFloat const HEIGHT = 180.0;

static NSString * const TITLE = @"天呐,竟然看不了!叶师傅说:";
static NSString * const OK_BTN_TITLE = @"知道了";

@interface VFLNoAccessView ()

@property (nonatomic) UIImageView *imgView;
@property (nonatomic) UILabel *titleLab;
@property (nonatomic) UILabel *subTitleOneLab;
@property (nonatomic) UILabel *subTitleTwoLab;
@property (nonatomic) UIButton *okBtn;
@end

@implementation VFLNoAccessView

-(id)initWithFrame:(CGRect)frame {
    frame = SELF_FRAME;
    self = [super initWithFrame:frame];
    if (self) {
        self.center = [UIApplication sharedApplication].keyWindow.center;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        return self;
    }
    return nil;
}

-(id)initWithSubTitleOne:(NSString *)subTitleOne subTitleTwo:(NSString *)subTitleTwo {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _subTitleOne = subTitleOne;
        _subTitleTwo = subTitleTwo;
        
        [self initUI];
        return self;
    }
    return nil;
}

- (void)initUI {
    [self addSubview:self.imgView];
    [self addSubview:self.subTitleOneLab];
    [self addSubview:self.subTitleTwoLab];
    [self addSubview:self.titleLab];
    [self addSubview:self.okBtn];
    
    NSDictionary *metrics = @{@"VerticalGap":@2.0, @"Height":@20.0, @"LeadingGap":@0};
    NSDictionary *views = NSDictionaryOfVariableBindings(_imgView, _titleLab, _subTitleOneLab, _subTitleTwoLab, _okBtn);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_imgView(80)]-VerticalGap-[_titleLab(Height)]-VerticalGap-[_subTitleOneLab(Height)]-VerticalGap-[_subTitleTwoLab(Height)]-VerticalGap-[_okBtn(Height)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-65-[_imgView(95)]" options:NSLayoutFormatAlignAllCenterX|NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-LeadingGap-[_titleLab]-LeadingGap-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-LeadingGap-[_subTitleOneLab]-LeadingGap-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-LeadingGap-[_subTitleTwoLab]-LeadingGap-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-LeadingGap-[_okBtn]-LeadingGap-|" options:0 metrics:metrics views:views]];
}

- (void)layoutSubviews {
}

#pragma mark - event response
- (void)showInView:(UIView *)view animated:(BOOL)animated {
    if (self) {
        UIView *maskView = [[UIView alloc] initWithFrame:view.bounds];
//        UIView *maskView = [UIView new];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.5;
        maskView.tag = 10000;
        [self addTapGesInView:maskView];
        [view addSubview:maskView];
        [view addSubview:self];
        
//        NSDictionary *views = NSDictionaryOfVariableBindings(maskView);
//        NSDictionary *metrics = @{@"ScreenWidth":@([UIScreen mainScreen].bounds.size.width), @"ScreenHeight":@([UIScreen mainScreen].bounds.size.height)};
//        [maskView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[maskView(ScreenWidth)]-0-|" options:NSLayoutFormatAlignAllCenterX|NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
//        [maskView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[maskView(ScreenHeight)]-0-|" options:0 metrics:metrics views:views]];
    }
}

- (void)hiddenFromView:(UIView *)view animated:(BOOL)animated {
    if (self) {
        [[[view subviews] lastObject] removeFromSuperview];
        [[view viewWithTag:10000] removeFromSuperview];
    }
}

- (void)didClickOkBtn:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(newNoAccessViewWillDisappear)]) {
        [self.delegate newNoAccessViewWillDisappear];
    }
}

#pragma mark - private method
//添加手势
- (void)addTapGesInView:(UIView *)view {
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickOkBtn:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
}

#pragma mark - setter&getter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@"global_no_permission"];
        _imgView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imgView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = TITLE;
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLab;
}

- (UILabel *)subTitleOneLab {
    if (!_subTitleOneLab) {
        _subTitleOneLab = [UILabel new];
        _subTitleOneLab.textColor = [UIColor lightGrayColor];
        _subTitleOneLab.text = self.subTitleOne;
        _subTitleOneLab.textAlignment = NSTextAlignmentCenter;
        _subTitleOneLab.font = [UIFont systemFontOfSize:12];
        _subTitleOneLab.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _subTitleOneLab;
}

- (UILabel *)subTitleTwoLab {
    if (!_subTitleTwoLab) {
        _subTitleTwoLab = [UILabel new];
        _subTitleTwoLab.textAlignment = NSTextAlignmentCenter;
        _subTitleTwoLab.textColor = [UIColor lightGrayColor];
        _subTitleTwoLab.text = self.subTitleTwo;
        _subTitleTwoLab.font = [UIFont systemFontOfSize:12];
        _subTitleTwoLab.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _subTitleTwoLab;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [UIButton new];
        [_okBtn setTitle:OK_BTN_TITLE forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_okBtn addTarget:self action:@selector(didClickOkBtn:) forControlEvents:UIControlEventTouchUpInside];
        _okBtn.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _okBtn;
}


- (void)setSubTitleOne:(NSString *)subTitleOne {
    if (subTitleOne) {
        _subTitleOne = subTitleOne;
        _subTitleOneLab.text = _subTitleOne;
    }
}

- (void)setSubTitleTwo:(NSString *)subTitleTwo {
    if (subTitleTwo) {
        _subTitleTwo = subTitleTwo;
        _subTitleTwoLab.text = _subTitleTwo;
    }
}

@end
