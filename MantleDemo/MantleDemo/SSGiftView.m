//
//  SSGiftView.m
//  SpiderSubscriber
//
//  Created by Czh on 15/9/7.
//  Copyright (c) 2015年 spider. All rights reserved.
//

#import "SSGiftView.h"
#import "SSToolsClass.h"
#import "UIImageView+WebCache.h"

@interface SSGiftView ()
{
    UIImageView *giftImage;
    UILabel *giftTitle;
}

@end

@implementation SSGiftView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor magentaColor];
        giftImage = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 94) / 2.0, 0, 88, 80)];
        giftImage.userInteractionEnabled = NO;
        giftImage.contentMode = UIViewContentModeCenter;
        [self addSubview:giftImage];
        giftTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 80, frame.size.width - 16, 35)];
        giftTitle.textColor = [SSToolsClass hexColor:@"606060"];
        giftTitle.font = [UIFont systemFontOfSize:13.0];
        giftTitle.numberOfLines = 2;
        [self addSubview:giftTitle];
    }
    return self;
}

- (void)setSsGiftInfo:(SSGiftInfo *)ssGiftInfo {
    [giftImage sd_setImageWithURL:[NSURL URLWithString:ssGiftInfo.ssGiftPicture] placeholderImage:[UIImage imageNamed:@"default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            giftImage.contentMode = UIViewContentModeScaleToFill;
        }
    }];
    giftTitle.text = ssGiftInfo.ssGiftTitle;
}
@end
