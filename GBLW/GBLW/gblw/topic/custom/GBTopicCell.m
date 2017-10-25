//
//  GBTopicCell.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/20.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBTopicCell.h"
#import "GBGroupInfo.h"

@interface GBTopicCell ()
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UIButton *attentionBtn;
@end

@implementation GBTopicCell
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headImgView];
        [self addSubview:self.nickNameLab];
        [self addSubview:self.subTitleLab];
        [self addSubview:self.attentionBtn];
        
        [self configSubviews];
    }
    return self;
}

#pragma mark - public
- (void)configData:(id)data {
    if ([data isKindOfClass:[GBGroupInfo class]]) {
        GBGroupInfo *topic = (GBGroupInfo *)data;
        
        [self.headImgView yy_setImageWithURL:[NSURL URLWithString:topic.headPortrait] placeholder:ImageNamed(@"default_header")];
        self.nickNameLab.text = topic.title;
        self.subTitleLab.text = topic.desc;
        
        if (topic.beFollowed) {
            [self.attentionBtn setImage:ImageNamed(@"attention_cancel") forState:UIControlStateNormal];
        } else {
            [self.attentionBtn setImage:ImageNamed(@"attention") forState:UIControlStateNormal];
        }
    }
}

#pragma mark - event
- (void)handleButtonAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicCellHandleAttention:index:)]) {
        [self.delegate topicCellHandleAttention:sender index:self.index];
    }
}

#pragma mark - private
- (void)configSubviews {
    WEAKSELF;
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.equalTo(weakself).mas_offset(14);
        make.centerY.mas_equalTo(weakself.mas_centerY);
    }];
    
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_W-40-80-40);
        make.top.mas_equalTo(weakself.headImgView.mas_top);
        make.left.equalTo(weakself.headImgView.mas_right).mas_offset(10);
    }];
    
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_W-40-80-40);
        make.top.equalTo(weakself.nickNameLab.mas_bottom).mas_offset(4);
        make.left.equalTo(weakself.headImgView.mas_right).mas_offset(10);
    }];
    
    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
        make.right.equalTo(weakself).mas_offset(-14);
        make.centerY.mas_equalTo(weakself.mas_centerY);
    }];
}


#pragma mark - getter & setter
- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.layer.cornerRadius = 20;
        _headImgView.layer.masksToBounds = YES;
    }
    return _headImgView;
}

- (UILabel *)nickNameLab {
    if (!_nickNameLab) {
        _nickNameLab = [[UILabel alloc] init];
        _nickNameLab.font = [UIFont systemFontOfSize:16];
        _nickNameLab.textColor = ColorHex(@"333333");
        _nickNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLab;
}

- (UILabel *)subTitleLab {
    if (!_subTitleLab) {
        _subTitleLab = [[UILabel alloc] init];
        _subTitleLab.font = [UIFont systemFontOfSize:14];
        _subTitleLab.textColor = ColorHex(@"999999");
        _subTitleLab.textAlignment = NSTextAlignmentLeft;
        _subTitleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _subTitleLab;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [[UIButton alloc] init];
        [_attentionBtn addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}
@end
