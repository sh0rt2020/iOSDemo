//
//  VFLNoAccessView.m
//  NoAccessDemo
//
//  Created by Yige on 2016/10/27.
//  Copyright © 2016年 Yige. All rights reserved.
//

#define SELF_FRAME CGRectMake(0, 0, WIDTH, HEIGHT)
#define IMG_FRAME CGRectMake(65, 9, 95, 80)
#define TITLE_FRAME CGRectMake(0, 93, WIDTH, LAB_HEIGHT)
#define SUB_TITLE_ONE_LAB_FRAME CGRectMake(0, 110, WIDTH, LAB_HEIGHT)
#define SUB_TITLE_TWO_LAB_FRAME CGRectMake(0, 129, WIDTH, LAB_HEIGHT)
#define OK_BTN_FRAME CGRectMake(0, 149, WIDTH, LAB_HEIGHT)

#import "VFLNoAccessView.h"

static CGFloat const WIDTH = 226.0;
static CGFloat const HEIGHT = 180.0;
static CGFloat const LAB_HEIGHT = 21.0;

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
}


#pragma mark - event response
- (void)showInView:(UIView *)view animated:(BOOL)animated {
    if (self) {
        UIView *maskView = [UIView new];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.5;
        maskView.tag = 10000;
        [self addTapGesInView:maskView];
        [view addSubview:maskView];
        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(maskView, view);
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[maskView]-0-|" options:0 metrics:nil views:viewsDict]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[maskView]-0-|" options:0 metrics:nil views:viewsDict]];
        view.translatesAutoresizingMaskIntoConstraints = YES;
        [view addSubview:self];
    }
}

- (void)hiddenFromView:(UIView *)view animated:(BOOL)animated {
    if (self) {
        [self removeFromSuperview];
        [[view viewWithTag:10000] removeFromSuperview];
    }
}

- (void)didClickOkBtn:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(newNoAccessViewWillDisappear)]) {
        [self.delegate newNoAccessViewWillDisappear];
    }
}

#pragma mark - private method
- (void)addTapGesInView:(UIView *)view {
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickOkBtn:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
}

#pragma mark - setter&getter
- (UIImageView *)imgView {
    _imgView = [[UIImageView alloc] initWithFrame:IMG_FRAME];
    _imgView.image = [UIImage imageNamed:@"global_no_permission"];
    return _imgView;
}

- (UILabel *)titleLab {
    _titleLab = [[UILabel alloc] initWithFrame:TITLE_FRAME];
    _titleLab.text = TITLE;
    _titleLab.font = [UIFont systemFontOfSize:13];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    return _titleLab;
}

- (UILabel *)subTitleOneLab {
    _subTitleOneLab = [[UILabel alloc] initWithFrame:SUB_TITLE_ONE_LAB_FRAME];
    _subTitleOneLab.textColor = [UIColor lightGrayColor];
    _subTitleOneLab.text = self.subTitleOne;
    _subTitleOneLab.textAlignment = NSTextAlignmentCenter;
    _subTitleOneLab.font = [UIFont systemFontOfSize:12];
    return _subTitleOneLab;
}

- (UILabel *)subTitleTwoLab {
    _subTitleTwoLab = [[UILabel alloc] initWithFrame:SUB_TITLE_TWO_LAB_FRAME];
    _subTitleTwoLab.textAlignment = NSTextAlignmentCenter;
    _subTitleTwoLab.textColor = [UIColor lightGrayColor];
    _subTitleTwoLab.text = self.subTitleTwo;
    _subTitleTwoLab.font = [UIFont systemFontOfSize:12];
    return _subTitleTwoLab;
}

- (UIButton *)okBtn {
    _okBtn = [[UIButton alloc] initWithFrame:OK_BTN_FRAME];
    [_okBtn setTitle:OK_BTN_TITLE forState:UIControlStateNormal];
    [_okBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _okBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_okBtn addTarget:self action:@selector(didClickOkBtn:) forControlEvents:UIControlEventTouchUpInside];
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
