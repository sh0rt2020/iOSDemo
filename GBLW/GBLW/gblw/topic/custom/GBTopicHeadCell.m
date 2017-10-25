//
//  GBTopicHeadCell.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/24.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBTopicHeadCell.h"
#import "GBGroupInfo.h"

static CGFloat const HeadRadius = 35.0;

@interface GBTopicHeadCell ()
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UIButton *followBtn;

@property (nonatomic, strong) GBGroupInfo *topic;
@end

@implementation GBTopicHeadCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.bgImgView];
        [self addSubview:self.headImgView];
        [self addSubview:self.nickNameLab];
        [self addSubview:self.descLab];
        [self addSubview:self.followBtn];
        
        [self configSubviews];
    }
    return self;
}

#pragma mark - public
- (void)configData:(id)data {
    if ([data isKindOfClass:[GBGroupInfo class]]) {
        GBGroupInfo *topic = (GBGroupInfo *)data;
        self.topic = topic;
        
        [self.headImgView yy_setImageWithURL:[NSURL URLWithString:topic.headPortrait] placeholder:ImageNamed(@"default_header")];
        self.nickNameLab.text = topic.title;
        self.descLab.text = [NSString stringWithFormat:@"订阅人数:%@  帖子:%@", [topic.followCount stringValue], [topic.feedCount stringValue]];
        if (topic.beFollowed) {
            self.followBtn.selected = YES;
        } else {
            self.followBtn.selected = NO;
        }
    }
}

#pragma mark - event
- (void)handleBtnAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicHeadCellFollowAction:beFollowed:)]) {
        [self.delegate topicHeadCellFollowAction:sender beFollowed:self.topic.beFollowed];
    }
    
    sender.selected = !sender.selected;
}

#pragma mark - private
- (void)configSubviews {
    WEAKSELF;
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(weakself);
        make.left.top.mas_equalTo(weakself);
    }];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(2*HeadRadius);
        make.left.equalTo(weakself).mas_offset(14);
        make.top.equalTo(weakself).mas_offset(84);
    }];
    
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_W-90-95);
        make.height.mas_equalTo(20);
        make.left.equalTo(weakself.headImgView.mas_right).mas_offset(10);
        make.top.equalTo(weakself.headImgView.mas_top).mas_offset(10);
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_W-90-95);
        make.height.mas_equalTo(20);
        make.left.equalTo(weakself.headImgView.mas_right).mas_offset(10);
        make.top.equalTo(weakself.nickNameLab.mas_bottom).mas_offset(4);
    }];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
        make.right.equalTo(weakself).mas_offset(-14);
        make.centerY.mas_equalTo(weakself.headImgView.mas_centerY);
    }];
}

#pragma mark - getter & setter
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        [_bgImgView setImage:ImageNamed(@"topic_header")];
    }
    return _bgImgView;
}

- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.layer.cornerRadius = HeadRadius;
        _headImgView.layer.masksToBounds = YES;
    }
    return _headImgView;
}

- (UILabel *)nickNameLab {
    if (!_nickNameLab) {
        _nickNameLab = [UILabel new];
        _nickNameLab.textColor = [UIColor whiteColor];
        _nickNameLab.font = [UIFont systemFontOfSize:16];
        _nickNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLab;
}

- (UILabel *)descLab {
    if (!_descLab) {
        _descLab = [UILabel new];
        _descLab.textColor = [UIColor whiteColor];
        _descLab.font = [UIFont systemFontOfSize:12];
        _descLab.textAlignment = NSTextAlignmentLeft;
        _descLab.text = @"订阅人数:0  帖子:0";
    }
    return _descLab;
}

- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [UIButton new];
        [_followBtn setImage:ImageNamed(@"attention") forState:UIControlStateNormal];
        [_followBtn setImage:ImageNamed(@"attention_cancel") forState:UIControlStateSelected];
        [_followBtn addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}

@end
