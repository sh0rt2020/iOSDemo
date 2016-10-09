//
//  WSProgressHUD.h
//  WSProgressHUD
//
//  Created by Wilson-Yuan on 15/7/17.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSErrorInfo;

@interface WSProgressHUD : UIView



//imageSize is 28*28

+ (void)showSuccessWithStatus: (NSString *)string;
+ (void)showError:(SSErrorInfo *)info;
+ (void)dismiss;

@end
