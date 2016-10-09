//
//  SpiderLoading.h
//  WSProgressHUD
//
//  Created by Czh on 15/10/30.
//  Copyright © 2015年 wilson-yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  加载框
 */
@interface SpiderLoading : UIView

+ (SpiderLoading *)shareInstance;

/**
 *  设置frame 1 漏出导航栏 2 漏出tabbar 3导航栏tabbar都漏出 不传全屏
 *
 *  @param type
 */
+ (void)showLoading:(NSString *)title;

+ (void)dismiss;

@end
