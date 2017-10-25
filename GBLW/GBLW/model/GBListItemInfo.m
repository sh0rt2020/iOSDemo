//
//  GBListItemInfo.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/12.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBListItemInfo.h"

@implementation GBListItemInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"feedId":@"id",
             @"topicId":@"topicId",
             @"publisherId":@"publisherId",
             @"publisherName":@"publisherName",
             @"publisherPortrait":@"publisherPortrait",
             @"type":@"type",
             @"title":@"title",
             @"content":@"content",
             @"pictures":@"pictureList",
             @"videoUrl":@"videoUrl",
             @"videoDuration":@"videoDuration",
             @"favor":@"favor",
             @"unfavor":@"unfavor",
             @"comment":@"comment",
             @"forward":@"forward",
             @"publishTime":@"publishTime",
             @"actionType":@"actionType",
             };
}


#pragma mark - public
- (CGFloat)cacheCellHeight:(GBListItemInfo *)item {
    
    if (self.contentHeight) {
        return self.contentHeight;
    }
    
    NSString *content = item.content;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.lineSpacing = 6;
    NSDictionary *attDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];
    __block CGFloat stringHeight = [content gb_stringRectWithStyle:attDict limitSize:CGSizeMake(SCREEN_W-28, 0)].size.height;
    
    if (!item.pictures || item.pictures.count == 0) {
        self.contentHeight = stringHeight+88;
        return self.contentHeight;
    }
    
    switch (item.pictures.count) {
        case 1: {
            stringHeight += (SCREEN_W-14*2)/4*3;
        }
            break;
        case 2:
        case 3: {
            stringHeight += ImgWidth;
        }
            break;
        case 4:
        case 5:
        case 6: {
            stringHeight += ImgWidth*2+1;
        }
            break;
        case 7:
        case 8:
        case 9: {
            stringHeight += ImgWidth*3+2;
        }
            break;
        default:
            break;
    }
    self.contentHeight = stringHeight+88;
    return self.contentHeight;
}


@end
