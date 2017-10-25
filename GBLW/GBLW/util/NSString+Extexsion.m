//
//  NSString+Extexsion.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/17.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "NSString+Extexsion.h"

@implementation NSString (Extexsion)

- (CGRect)gb_stringRectWithStyle:(NSDictionary *)attDict limitSize:(CGSize)size  {
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attDict context:nil];
    return rect;
}
@end
