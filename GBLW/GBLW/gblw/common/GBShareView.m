//
//  GBShareView.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/19.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBShareView.h"

static NSInteger const wxTag = 5000;
static NSInteger const pyqTag = 5001;
static NSInteger const qqTag = 5002;
static NSInteger const kjTag = 5003;

@interface GBShareView ()

@property (nonatomic, strong) UIView *shareContentView;
@property (nonatomic, strong) UIView *bgview;
@end

@implementation GBShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        self.shareContentView = [[UIView alloc] init];
        _shareContentView.backgroundColor = [UIColor whiteColor];
        self.shareContentView.alpha = 1.0;
        [self addSubview:_shareContentView];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_shareContentView addSubview:cancelButton];
        
        UIView *separateView = [[UIView alloc] init];
        separateView.backgroundColor = ColorHex(@"dddddd");
        [cancelButton addSubview:separateView];
        
        [self createShareButtons];
        
        WEAKSELF;
        [_shareContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakself.mas_bottom);
            make.left.right.equalTo(weakself);
            make.height.mas_equalTo(188);
        }];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(weakself.shareContentView);
            make.height.mas_equalTo(49);
        }];
        
        [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(cancelButton);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)createShareButtons {
    
    NSMutableArray *shareImageArray = [NSMutableArray array];
    NSMutableArray *shareTitleArray =[NSMutableArray array];
    NSArray *shareTagArray = @[[NSNumber numberWithInteger:wxTag], [NSNumber numberWithInteger:pyqTag], [NSNumber numberWithInteger:qqTag], [NSNumber numberWithInteger:kjTag]];
    
    [shareImageArray addObjectsFromArray:@[@"wechat", @"wechat_timeline",  @"qq", @"qq_timeline"]];
    [shareTitleArray addObjectsFromArray:@[@"微信", @"朋友圈", @"QQ", @"QQ空间"]];
    
    
//    UMSocialManager *umManager = [UMSocialManager defaultManager];
//
//    if ([umManager isInstall:UMSocialPlatformType_WechatSession]) {
//        [shareImageArray addObjectsFromArray:@[@"xiangqing_fenxiang_wechat",@"xiangqing_fenxiang_pengyouquan"]];
//        [shareTitleArray addObjectsFromArray:@[@"微信",@"朋友圈"]];
//    }
//
//    if ([umManager isInstall:UMSocialPlatformType_QQ]) {
//        [shareImageArray addObjectsFromArray:@[@"xiangqing_fenxiang_qq",@"xiangqing_fenxiang_kongjian"]];
//        [shareTitleArray addObjectsFromArray:@[@"QQ",@"QQ空间"]];
//    }

    
    
    CGFloat buttonWidth = SCREEN_W/4;
    CGFloat buttonHeight = 68;
    
    for (int i = 0; i <shareImageArray.count; i ++) {
        
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth*i, 0, buttonWidth, buttonHeight)];
        shareBtn.centerY = 188/2;
        
        NSString *imageName = shareImageArray[i];
        NSString *title = shareTitleArray[i];
        NSInteger tag = [shareTagArray[i] integerValue];
        
        [shareBtn setImage:ImageNamed(imageName) forState:UIControlStateNormal];
        [shareBtn setTitle:title forState:UIControlStateNormal];
        shareBtn.tag = tag;

        [shareBtn setTitleColor:ColorHex(@"999999") forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        CGSize imageSize = CGSizeMake(50, 50);
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(buttonWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        CGFloat totalHeight = imageSize.height + titleSize.height + 4;
        
        [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width)];
        [shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -imageSize.width, -(totalHeight - titleSize.height), 0.0)];
        
        [self.shareContentView addSubview:shareBtn];
    }
}

- (void)didMoveToWindow {
    [self layoutIfNeeded];
    
    [self.superview bringSubviewToFront:self];
    WEAKSELF;
    [_shareContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.mas_bottom).offset(-252);
        make.left.right.equalTo(weakself);
        make.height.mas_equalTo(252);
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)buttonAction:(UIButton *)button {
    
}

- (void)shareViewButtonSeleted:(ButtonBlock)block {
    _buttonBlcok = block;
}

- (void)cancelButtonAction:(UIButton *)button {
    [self removeSelfFromSuperview];
}

- (void)tapAction:(UIGestureRecognizer *)recognizer {
    
    CGPoint point = [recognizer locationInView:self];
    if (point.y < self.height - 252) {
        [self cancelButtonAction:nil];
    }
    
}

- (void)removeSelfFromSuperview {
    WEAKSELF;

    [_shareContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.mas_bottom);
        make.left.right.equalTo(weakself);
        make.height.mas_equalTo(252);
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
