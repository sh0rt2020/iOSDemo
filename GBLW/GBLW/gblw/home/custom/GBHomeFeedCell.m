//
//  GBHomeFeedCell.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/17.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBHomeFeedCell.h"
#import "GBListItemInfo.h"
#import "GBContentView.h"


#define BtnWidth  (SCREEN_W-16)/4
static CGFloat const HeaderHeight = 44.0;

@interface GBHomeFeedCell ()
@property (nonatomic, strong) UILabel *tipLab;  //热门、广告等标识
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) GBContentView *conView;
@property (nonatomic, strong) UIButton *favorBtn;
@property (nonatomic, strong) UIButton *unfavorBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) GBListItemInfo *item;
@end

@implementation GBHomeFeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.tipLab];
        [self.contentView addSubview:self.headImgView];
        [self.contentView addSubview:self.nickNameLab];
        [self.contentView addSubview:self.conView];
        [self.contentView addSubview:self.favorBtn];
        [self.contentView addSubview:self.unfavorBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.shareBtn];
        
        [self configSubviews];
    }
    return self;
}

- (void)configData:(id)data {
    
    if ([data isKindOfClass:[GBListItemInfo class]]) {
        GBListItemInfo *item = (GBListItemInfo *)data;
        self.item = item;
        
        [self.conView configWithContent:self.item.content imgs:self.item.pictures];
        [self.favorBtn setTitle:[self.item.favor stringValue] forState:UIControlStateNormal];
        [self.unfavorBtn setTitle:[self.item.unfavor stringValue] forState:UIControlStateNormal];
        [self.commentBtn setTitle:[self.item.comment stringValue] forState:UIControlStateNormal];
        [self.headImgView yy_setImageWithURL:[NSURL URLWithString:self.item.publisherPortrait] placeholder:ImageNamed(@"default_header")];
        self.nickNameLab.text = self.item.publisherName;
        
        self.favorBtn.selected = NO;
        self.unfavorBtn.selected = NO;
        switch ([self.item.actionType integerValue]) {
            case 1:
                self.favorBtn.selected = YES;
                break;
            case 2:
                self.unfavorBtn.selected = YES;
                break;
            case 3: {
                self.unfavorBtn.selected = YES;
                self.favorBtn.selected = YES;
            }
                break;
            default:
                break;
        }
        
        
        CGFloat contentHeight = [item cacheCellHeight:item];
        contentHeight -= 2*HeaderHeight;
        
        WEAKSELF;
        [self.conView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentHeight);
            make.width.mas_equalTo(SCREEN_W);
            make.left.equalTo(weakself).mas_offset(0);
            make.top.equalTo(weakself.headImgView.mas_bottom).mas_offset(7);
        }];
    }
}

#pragma mark - event
- (void)handleBtnAction:(UIButton *)sender {

    if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedCellHandleAction:index:)]) {
        [self.delegate homeFeedCellHandleAction:sender index:self.index];
    }
    
    switch (sender.tag) {
        case FavorBtnTag:
            if (!sender.selected) {
                if ([self.item.actionType integerValue] == 2) {
                    self.item.actionType = [NSNumber numberWithInt:3];
                } else {
                    self.item.actionType = [NSNumber numberWithInt:1];
                }
                
                NSString *title = [[NSNumber numberWithInteger:([sender.currentTitle integerValue] + 1)] stringValue];
                [sender setTitle:title forState:UIControlStateNormal];
                sender.selected = !sender.selected;
            }
            break;
        case UnfavorBtnTag: {
            if (!sender.selected) {
                if ([self.item.actionType integerValue] == 1) {
                    self.item.actionType = [NSNumber numberWithInt:3];
                } else {
                    self.item.actionType = [NSNumber numberWithInt:2];
                }
               
                NSString *title = [[NSNumber numberWithInteger:([sender.currentTitle integerValue] + 1)] stringValue];
                [sender setTitle:title forState:UIControlStateNormal];
                sender.selected = !sender.selected;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - helper
- (void)configSubviews {
    WEAKSELF;
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HeaderHeight-10);
        make.width.mas_equalTo(14);
        make.leading.mas_equalTo(0);
        make.top.mas_equalTo(10/2);
    }];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HeaderHeight-14);
        make.width.mas_equalTo(HeaderHeight-14);
        make.left.equalTo(weakself.tipLab.mas_right).mas_offset(0);
        make.centerY.equalTo(weakself.tipLab.mas_centerY);
    }];
    
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HeaderHeight);
        make.left.equalTo(weakself.headImgView.mas_right).mas_offset(8);
        make.right.equalTo(weakself).mas_offset(8);
        make.centerY.equalTo(weakself.headImgView.mas_centerY);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.mas_bottom).mas_offset(-10);
        make.left.equalTo(weakself).mas_offset(8);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(BtnWidth);
    }];
    
    [self.favorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.mas_bottom).mas_offset(-10);
        make.left.equalTo(weakself.shareBtn.mas_right).mas_offset(8);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(BtnWidth);
    }];
    
    [self.unfavorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.mas_bottom).mas_offset(-10);
        make.left.equalTo(weakself.favorBtn.mas_right).mas_offset(8);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(BtnWidth);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.mas_bottom).mas_offset(-10);
        make.right.equalTo(weakself.mas_right).mas_offset(-8);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(BtnWidth);
    }];
}

#pragma mark - getter & setter
- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.font = [UIFont systemFontOfSize:12];
        _tipLab.text = @"热门";
        _tipLab.numberOfLines = 2;
        _tipLab.textColor = [UIColor whiteColor];
        _tipLab.backgroundColor = [UIColor redColor];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.hidden = YES;
    }
    return _tipLab;
}

- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.layer.cornerRadius = 15;
        _headImgView.layer.masksToBounds = YES;
    }
    return _headImgView;
}

- (UILabel *)nickNameLab {
    if (!_nickNameLab) {
        _nickNameLab = [[UILabel alloc] init];
        _nickNameLab.font = [UIFont systemFontOfSize:13];
        _nickNameLab.textColor = [UIColor lightGrayColor];
        _nickNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLab;
}

- (GBContentView *)conView {
    if (!_conView) {
        _conView = [[GBContentView alloc] init];
    }
    return _conView;
}

- (UIButton *)favorBtn {
    if (!_favorBtn) {
        _favorBtn = [[UIButton alloc] init];
        [_favorBtn setTitle:@"184" forState:UIControlStateNormal];
        [_favorBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _favorBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _favorBtn.tag = FavorBtnTag;
        [_favorBtn setImage:ImageNamed(@"favor_unsel") forState:UIControlStateNormal];
        [_favorBtn setImage:ImageNamed(@"favor_sel") forState:UIControlStateSelected];
        [_favorBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [_favorBtn addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favorBtn;
}

- (UIButton *)unfavorBtn {
    if (!_unfavorBtn) {
        _unfavorBtn = [[UIButton alloc] init];
        [_unfavorBtn setTitle:@"917" forState:UIControlStateNormal];
        [_unfavorBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _unfavorBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _unfavorBtn.tag = UnfavorBtnTag;
        [_unfavorBtn setImage:ImageNamed(@"unfavor_unsel") forState:UIControlStateNormal];
        [_unfavorBtn setImage:ImageNamed(@"unfavor_sel") forState:UIControlStateSelected];
        [_unfavorBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [_unfavorBtn addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unfavorBtn;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] init];
        [_commentBtn setTitle:@"888" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _commentBtn.tag = CommentBtnTag;
        [_commentBtn setImage:ImageNamed(@"comment_unsel") forState:UIControlStateNormal];
        [_commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [_commentBtn addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] init];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _shareBtn.tag = ShareBtnTag;
        [_shareBtn setImage:ImageNamed(@"share_unsel") forState:UIControlStateNormal];
        [_shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [_shareBtn addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

@end
