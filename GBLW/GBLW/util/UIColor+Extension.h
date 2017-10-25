//
//  UIColor+Extension.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/18.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ColorHex(__HEX__) [UIColor hexStringColor:__HEX__]

@interface UIColor (Extension)
@property(nonatomic)NSString*hexString;

+(instancetype)hexStringColor:(NSString*)hexColor;
@end
