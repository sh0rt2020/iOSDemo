//
//  GBDetailCommentCell.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/19.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBDetailCommentCell.h"
#import "GBComment.h"

static CGFloat const HeadWidth = 30.0;

@interface GBDetailCommentCell ()
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *favorBtn;

@property (nonatomic, strong) GBComment *comment;
@end

@implementation GBDetailCommentCell
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.headImg];
        [self addSubview:self.nickNameLab];
        [self addSubview:self.favorBtn];
        [self addSubview:self.contentLab];
        
        [self configSubviews];
    }
    return self;
}

#pragma mark - public
- (void)configData:(id)data {
    if ([data isKindOfClass:[GBComment class]]) {
        
        GBComment *comment = (GBComment *)data;
        self.comment = comment;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.lineSpacing = 6;
        NSDictionary *attDict = [NSDictionary dictionaryWithObjectsAndKeys:style, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:16], NSFontAttributeName, nil];
        CGRect contentRect = [comment.content gb_stringRectWithStyle:attDict limitSize:CGSizeMake(SCREEN_W-14*2, 0)];
        
        CGFloat contentHeight = contentRect.size.height;
        
        WEAKSELF;
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentHeight);
            make.left.equalTo(weakself.headImg.mas_right).mas_offset(14);
            make.right.equalTo(weakself).mas_offset(-14);
            make.top.equalTo(weakself.nickNameLab.mas_bottom).mas_offset(12);
        }];
        
        self.nickNameLab.text = comment.publisherName;
        self.contentLab.attributedText = [[NSAttributedString alloc] initWithString:comment.content attributes:attDict];
        [self.headImg yy_setImageWithURL:[NSURL URLWithString:comment.publisherPortrait] placeholder:ImageNamed(@"default_header")];
        
        if ([comment.actionType integerValue] == 1) {
            self.favorBtn.selected = YES;
        } else {
            self.favorBtn.selected = NO;
        }
        [self.favorBtn setTitle:[comment.favor stringValue] forState:UIControlStateNormal];
        
        CGSize imageSize = self.favorBtn.currentImage.size;
        CGSize titleSize = [[comment.favor stringValue] boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        CGFloat totalWidth = (imageSize.width + titleSize.width + 12);
        [_favorBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(totalWidth-titleSize.width)*2, 0, 0)];
        [_favorBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(totalWidth-imageSize.width)*2)];
    }
}

#pragma mark - event
- (void)handleFavorAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCommentCellHandleFavor:)]) {
        [self.delegate detailCommentCellHandleFavor:sender];
    }
    
    if (!sender.selected) {
        if ([self.comment.actionType integerValue] != 1) {
            self.comment.actionType = [NSNumber numberWithInt:1];
        }
        
        sender.selected = !sender.selected;
        [sender setTitle:[[NSNumber numberWithInteger:[sender.currentTitle integerValue] + 1]  stringValue] forState:UIControlStateNormal];
    }
}

#pragma mark - private
- (void)configSubviews {
    WEAKSELF;
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.height.width.mas_equalTo(HeadWidth);
        make.top.mas_equalTo(12);
    }];
    
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.headImg.mas_right).mas_offset(14);
        make.top.equalTo(weakself).mas_offset(12);
        make.right.equalTo(weakself.favorBtn).mas_offset(8);
        make.height.mas_equalTo(20);
    }];
    
    [self.favorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.centerY.mas_equalTo(weakself.nickNameLab.mas_centerY);
        make.right.equalTo(weakself).mas_offset(-8);
    }];
}

#pragma mark - getter & setter
- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [UIImageView new];
        _headImg.layer.cornerRadius = 15.0;
        _headImg.layer.masksToBounds = YES;
    }
    return _headImg;
}

- (UILabel *)nickNameLab {
    if (!_nickNameLab) {
        _nickNameLab = [UILabel new];
        _nickNameLab.textAlignment = NSTextAlignmentLeft;
        _nickNameLab.font = [UIFont systemFontOfSize:13];
        _nickNameLab.textColor = ColorHex(@"999999");
    }
    return _nickNameLab;
}

- (UIButton *)favorBtn {
    if (!_favorBtn) {
        _favorBtn = [UIButton new];
        [_favorBtn addTarget:self action:@selector(handleFavorAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_favorBtn setTitle:@"338" forState:UIControlStateNormal];
        _favorBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_favorBtn setImage:ImageNamed(@"favor_comment_unsel") forState:UIControlStateNormal];
        [_favorBtn setImage:ImageNamed(@"favor_comment_sel") forState:UIControlStateSelected];
        [_favorBtn setTitleColor:ColorHex(@"999999") forState:UIControlStateNormal];
        _favorBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _favorBtn;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.textColor = [UIColor blackColor];
        _contentLab.font = [UIFont systemFontOfSize:16];
        _contentLab.textAlignment = NSTextAlignmentLeft;
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLab;
}

@end
