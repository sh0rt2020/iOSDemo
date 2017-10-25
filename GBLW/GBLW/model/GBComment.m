//
//  GBComment.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/17.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBComment.h"

@implementation GBComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"publisherId":@"publisherId",
             @"publisherName":@"publisherName",
             @"favor":@"favor",
             @"publisherPortrait":@"publisherPortrait",
             @"content":@"content",
             @"feedId":@"feedId",
             @"commentId":@"id",
             @"publishTime":@"publishTime",
             @"actionType":@"actionType",
             };
}

#pragma mark - public
- (CGFloat)cacheCellHeight:(GBComment *)comment {
    
    if (self.contentHeight) {
        return self.contentHeight;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.lineSpacing = 6;
    NSDictionary *attDict = [NSDictionary dictionaryWithObjectsAndKeys:style, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:16], NSFontAttributeName, nil];
    CGRect contentRect = [comment.content gb_stringRectWithStyle:attDict limitSize:CGSizeMake(SCREEN_W-14*2, 0)];
    
    CGFloat contentHeight = contentRect.size.height;
    self.contentHeight = contentHeight+12*2+20+8;
    return self.contentHeight;
}
@end
