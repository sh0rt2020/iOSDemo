//
//  GBContentView.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/17.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBContentView.h"

@interface GBContentView ()
@property (nonatomic, strong) UILabel *contentLab;
@end

@implementation GBContentView

- (void)configWithContent:(NSString *)content imgs:(NSArray *)imgs {
    
    NSArray *subViews = [self subviews];
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
    
    CGFloat contentHeight = 0;
    if (content && content.length > 1) {
        [self addSubview:self.contentLab];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.lineSpacing = 6;
        NSDictionary *attDict = [NSDictionary dictionaryWithObjectsAndKeys:style, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:16], NSFontAttributeName, nil];
        CGRect contentRect = [content gb_stringRectWithStyle:attDict limitSize:CGSizeMake(SCREEN_W-14*2, 0)];
        contentHeight = contentRect.size.height;
        
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:content attributes:attDict];
        self.contentLab.attributedText = attString;
        
        WEAKSELF;
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakself).mas_offset(0);
            make.left.equalTo(weakself).mas_offset(14);
            make.right.equalTo(weakself).mas_offset(-14);
            make.height.mas_equalTo(contentHeight);
        }];
    }
    
    
    NSMutableArray *imgViews = [NSMutableArray array];
    for (NSString *img in imgs) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.masksToBounds = YES;
        [imgView setYy_imageURL:[NSURL URLWithString:img]];
        [imgViews addObject:imgView];
    }
    
    switch (imgViews.count) {
        case 1: {
            UIImageView *imgView = [imgViews firstObject];
            imgView.frame = CGRectMake(14, contentHeight+4, SCREEN_W-14*2, (SCREEN_W-14*2)/4*3);
            [self addSubview:imgView];
        }
            break;
        case 2:
        case 3: {
            int i = 0;
            CGFloat startX = (SCREEN_W-ImgWidth*imgViews.count-(imgViews.count-1))/2;
            for (UIImageView *imgView in imgViews) {
                imgView.frame = CGRectMake(startX+ImgWidth*i+i, contentHeight+4, ImgWidth, ImgWidth);
                [self addSubview:imgView];
                i += 1;
            }
        }
            break;
        case 4: {
            int i = 0;
            CGFloat startX = (SCREEN_W-ImgWidth*2-1)/2;
            for (UIImageView *imgView in imgViews) {
                if (i < 2) {
                    imgView.frame = CGRectMake(startX+ImgWidth*i+i, contentHeight+4, ImgWidth, ImgWidth);
                } else {
                    imgView.frame = CGRectMake(startX+ImgWidth*(i-2)+(i-2), contentHeight+ImgWidth+4+1, ImgWidth, ImgWidth);
                }
                [self addSubview:imgView];
                i += 1;
            }
        }
            break;
        case 5:
        case 6: {
            int i = 0;
            CGFloat startX = 14;
            for (UIImageView *imgView in imgViews) {
                if (i < 3) {
                    imgView.frame = CGRectMake(startX+ImgWidth*i+i, contentHeight+4, ImgWidth, ImgWidth);
                } else {
                    imgView.frame = CGRectMake(startX+ImgWidth*(i-3)+(i-3), contentHeight+ImgWidth+4+1, ImgWidth, ImgWidth);
                }
                [self addSubview:imgView];
                i += 1;
            }
        }
            break;
        case 7:
        case 8:
        case 9: {
            int i = 0;
            CGFloat startX = 14;
            for (UIImageView *imgView in imgViews) {
                if (i < 3) {
                    imgView.frame = CGRectMake(startX+ImgWidth*i+i, contentHeight+4, ImgWidth, ImgWidth);
                } else if (i >= 3 && i < 6) {
                    imgView.frame = CGRectMake(startX+ImgWidth*(i-3)+(i-3), contentHeight+ImgWidth+4+1, ImgWidth, ImgWidth);
                } else if (i >= 6 && i < 9) {
                    imgView.frame = CGRectMake(startX+ImgWidth*(i-6)+(i-6), contentHeight+ImgWidth*2+4+2, ImgWidth, ImgWidth);
                }
                [self addSubview:imgView];
                i += 1;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - setter & getter
- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentLeft;
        _contentLab.textColor = ColorHex(@"666666");
        _contentLab.numberOfLines = 0;
        _contentLab.font = [UIFont systemFontOfSize:16];
    }
    return _contentLab;
}

@end
