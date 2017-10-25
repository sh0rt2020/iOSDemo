//
//  GBDetailCell.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/19.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBDetailHeadCell.h"
#import "GBListItemInfo.h"
#import "GBContentView.h"


#define BtnWidth  (SCREEN_W-16)/3
static CGFloat const HeaderHeight = 44.0;

@interface GBDetailHeadCell ()

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) GBContentView *conView;
@property (nonatomic, strong) UIButton *favorBtn;
@property (nonatomic, strong) UIButton *unfavorBtn;
@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) GBListItemInfo *item;
@end

@implementation GBDetailHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImgView];
        [self.contentView addSubview:self.nickNameLab];
        [self.contentView addSubview:self.attentionBtn];
        [self.contentView addSubview:self.conView];
        [self.contentView addSubview:self.favorBtn];
        [self.contentView addSubview:self.unfavorBtn];
        [self.contentView addSubview:self.commentBtn];
        
        [self configSubviews];
    }
    return self;
}

- (void)configData:(id)data {
    
    if ([data isKindOfClass:[GBListItemInfo class]]) {
        self.item = (GBListItemInfo *)data;
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
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.lineSpacing = 6;
        NSDictionary *attDict = [NSDictionary dictionaryWithObjectsAndKeys:style, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:16], NSFontAttributeName, nil];
        CGRect contentRect = [self.item.content gb_stringRectWithStyle:attDict limitSize:CGSizeMake(SCREEN_W-14*2, 0)];
        
        CGFloat contentHeight = contentRect.size.height;
        
        if (!self.item.pictures || self.item.pictures.count == 0) {
            
            WEAKSELF;
            [self.conView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight);
                make.width.mas_equalTo(SCREEN_W);
                make.left.equalTo(weakself).mas_offset(0);
                make.top.equalTo(weakself.headImgView.mas_bottom).mas_offset(7);
            }];
            
            return ;
        }
        
        switch (self.item.pictures.count) {
            case 1: {
                NSString *imgUrl = [self.item.pictures firstObject];
                UIImageView *imgView = [[UIImageView alloc] init];
                [imgView setYy_imageURL:[NSURL URLWithString:imgUrl]];
                contentHeight += imgView.image.size.height;
            }
                break;
            case 2:
            case 3: {
                contentHeight += ImgWidth;
            }
                break;
            case 4:
            case 5:
            case 6: {
                contentHeight += 2*ImgWidth+1;
            }
                break;
            case 7:
            case 8:
            case 9: {
                contentHeight += 3*ImgWidth+2;
            }
                break;
            default:
                break;
        }
        
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailHeadCellHandleAction:)]) {
        [self.delegate detailHeadCellHandleAction:sender];
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
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HeaderHeight-14);
        make.width.mas_equalTo(HeaderHeight-14);
        make.left.equalTo(weakself).mas_offset(14);
        make.top.equalTo(weakself).mas_offset(7);
    }];
    
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HeaderHeight);
        make.left.equalTo(weakself.headImgView.mas_right).mas_offset(8);
        make.right.equalTo(weakself).mas_offset(8);
        make.centerY.equalTo(weakself.headImgView.mas_centerY);
    }];
    
    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself).mas_offset(-14);
        make.centerY.mas_equalTo(weakself.headImgView.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    
    [self.favorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.mas_bottom).mas_offset(-10);
        make.left.equalTo(weakself).mas_offset(8);
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
- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        [_headImgView setYy_imageURL:[NSURL URLWithString:@"http://p3.pstatp.com/medium/3e780000ae46686a6b53"]];
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
        _nickNameLab.text = @"卢本伟牛逼";
    }
    return _nickNameLab;
}

- (GBContentView *)conView {
    if (!_conView) {
        _conView = [[GBContentView alloc] init];
    }
    return _conView;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [[UIButton alloc] init];
        [_attentionBtn setImage:ImageNamed(@"attention") forState:UIControlStateNormal];
        [_attentionBtn addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _attentionBtn.tag = AttentionTag;
        _attentionBtn.hidden = YES;
    }
    return _attentionBtn;
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

@end
