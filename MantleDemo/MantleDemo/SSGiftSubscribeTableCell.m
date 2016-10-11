//
//  SSGiftSubscribeTableCell.m
//  SpiderSubscriber
//
//  Created by sunwell on 15/9/14.
//  Copyright (c) 2015年 spider. All rights reserved.
//

#define IMG_SERVER_ADDRESS @"http://pic.spider.com.cn/pic/"
#define BTN_WIDTH  22

#import "SSGiftSubscribeTableCell.h"
#import "UIImageView+WebCache.h"
//#import "SSImageMacros.h"
#import "SSUrlAPI.h"
//#import "SSToolsMacros.h"

@interface SSGiftSubscribeTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ssImgView;
@property (weak, nonatomic) IBOutlet UILabel *ssTitle;
@property (weak, nonatomic) IBOutlet UILabel *ssSpiderPrice;
@property (weak, nonatomic) IBOutlet UILabel *ssMarketPrice;
@property (weak, nonatomic) IBOutlet UIView *ssGiftSubView;
@property (weak, nonatomic) IBOutlet UIView *ssContainerView;
@end

@implementation SSGiftSubscribeTableCell

- (SSGiftScrollView *)ssGiftV {
    if (!_ssGiftV) {
        self.ssGiftV = [[SSGiftScrollView alloc] initWithFrame:CGRectZero];
    }
    return _ssGiftV;
}

- (void)awakeFromNib {
    // Initialization code
    self.ssGiftV.frame = CGRectMake(0, 15, ScreenWidth-16, self.ssGiftSubView.frame.size.height-15);
    [self.ssGiftSubView addSubview:self.ssGiftV];
}

- (void)configCellWithData:(SSGiftPaperInfo *)info {
    
    self.ssImgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.ssImgView.layer.shadowColor = [SSToolsClass hexColor:@"bbbbbb"].CGColor;
    self.ssImgView.layer.shadowOpacity = 1;
    self.ssImgView.layer.shadowPath = [UIBezierPath  bezierPathWithRect:self.ssImgView.bounds].CGPath;
    self.ssContainerView.layer.shadowOffset = CGSizeMake(0, 0);
    self.ssContainerView.layer.shadowColor = [SSToolsClass hexColor:@"bbbbbb"].CGColor;
    self.ssContainerView.layer.shadowOpacity = 1;
    self.ssContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ScreenWidth-16, 260)].CGPath;
    
    NSArray *tmpArr = [NSArray arrayWithObjects: [NSDictionary dictionaryWithObjectsAndKeys:@"全", @"name", @"f", @"period", @"ff7d7d", @"color", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"半", @"name", @"h", @"period", @"efcb22", @"color", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"季", @"name", @"j", @"period", @"59d03e", @"color", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"月", @"name", @"s", @"period", @"42cafc", @"color", nil], nil];
    self.ssImgView.contentMode = UIViewContentModeCenter;
    [self.ssImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_SERVER_ADDRESS, info.ssPicture]] placeholderImage:ImageNamed(@"default") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.ssImgView.contentMode = UIViewContentModeScaleToFill;
        }
    }];
    self.ssTitle.text = info.ssTitle;
    
    NSArray *periodArr = [info.ssPricePeriod componentsSeparatedByString:@"|"];
    CGFloat y = 89;
    CGFloat gapWidth = (ScreenWidth-16-119-periodArr.count*22-(periodArr.count-1)*8)/2;
    CGFloat x = 119+gapWidth;
    
    for (int i=0; i<4; i++) {
        [[self.ssContainerView viewWithTag:10000+i] removeFromSuperview];
    }
    
    for (int i=0; i<periodArr.count; i++) {
        for (int j=0; j<tmpArr.count; j++) {
            NSDictionary *dic = tmpArr[j];
            if ([periodArr[i] isEqualToString:dic[@"period"]]) {
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x+(BTN_WIDTH+8)*i, y, BTN_WIDTH, BTN_WIDTH)];
                lab.tag = 10000+i;
                lab.backgroundColor = [SSToolsClass hexColor:dic[@"color"]];
                lab.text = dic[@"name"];
                lab.layer.cornerRadius = 2;
                lab.layer.masksToBounds = YES;
                lab.textColor = [UIColor whiteColor];
                lab.textAlignment = NSTextAlignmentCenter;
                [self.ssContainerView addSubview:lab];
                break;
            }
        }
    }
    
    
    NSString *period = [SSToolsClass getUnitWith:periodArr[0]];
    NSString *attMarketPrice = [NSString stringWithFormat:@"￥%.2f/%@", [info.ssPrice floatValue], period];
    self.ssMarketPrice.attributedText = [SSToolsClass addAttributeToString:attMarketPrice font:0 color:nil range:NSMakeRange(0, attMarketPrice.length)];
    
    self.ssSpiderPrice.text = [NSString stringWithFormat:@"￥%.2f/%@", [info.ssSpiderPrice floatValue], period];
    
    if (info.ssGifts.count > 0) {
        [self.ssGiftV setSsGiftArr:info.ssGifts];
    }
}
@end
