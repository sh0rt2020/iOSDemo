//
//  ToolsMacros.h
//  SingletonTemplate
//
//  Created by spider on 14/10/31.
//  Copyright (c) 2014年 KindAzrael. All rights reserved.
//

#ifndef SingletonTemplate_ToolsMacros_h
#define SingletonTemplate_ToolsMacros_h

#import "SSUserInfo.h"
#import "SSDatasInfo.h"
#import "SSToolsClass.h"
#import "SSDataPackage.h"
#import <zlib.h>
#import "SSLineation.h"
#import "SSConstant.h"
#import "SpiderLoading.h"
#import "SSUrlAPI.h"


#define SS_IMAGE_CACHE_DIR @"ssImageCache" //图片缓存目录名

/*---------------------------------- 字体大小------------------------------*/
#define rightBarItemFont [UIFont boldSystemFontOfSize:15]  //导航栏右边按钮的字体大小

//----------------------字符串---------------------------
#ifndef nilToEmpty
#define nilToEmpty(object) (object!=nil)?object:@""
#endif

#ifndef formatStringOfObject
#define formatStringOfObject(object) [NSString stringWithFormat:@"%@", object]
#endif

#ifndef nilToEmptyFormatStringOfObject
#define nilToEmptyFormatStringOfObject(object) formatStringOfObject(nilToEmpty(object))
#endif

/************颜色*************/

//背景 #f6f6f6
#define SS_BACKGROUND_COLOR [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1.0f]

//线条颜色 #eeeeee
#define SS_LINE_COLOR [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0f]

//----------------------颜色类---------------------------
#define RGBA(r, g, b, a)              [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                  RGBA(r, g, b, 1.0f)
// rgb颜色转换（16进制->10进制）
#define HEXCOLOR(c)                   [UIColor colorWithRed:((c>>16)&0xFF)/255.0f green:((c>>8)&0xFF)/255.0f blue:(c&0xFF)/255.0f alpha:1.0f];
//背景色
#define BACKGROUND_COLOR              [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
//清除背景色
#define CLEARCOLOR                    [UIColor clearColor]

//----------------------debug---------------------------
#define debug(...)                    NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

//----------------------尺寸大小-------------------------
#define ScreenWidth                   [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                  [[UIScreen mainScreen] bounds].size.height
#define ViewWidth(v)                  v.frame.size.width
#define ViewHeight(v)                 v.frame.size.height
#define ViewX(v)                      v.frame.origin.x
#define ViewY(v)                      v.frame.origin.y
#define SelfViewWidth                 self.view.bounds.size.width
#define SelfViewHeight                self.view.bounds.size.height
#define RectX(rect)                   rect.origin.x
#define RectY(rect)                   rect.origin.y
#define RectWidth(rect)               rect.size.width
#define RectHeight(rect)              rect.size.height
#define RectSetWidth(rect, w)         CGRectMake(RectX(rect), RectY(rect), w, RectHeight(rect))
#define RectSetHeight(rect, h)        CGRectMake(RectX(rect), RectY(rect), RectWidth(rect), h)
#define RectSetX(rect, x)             CGRectMake(x, RectY(rect), RectWidth(rect), RectHeight(rect))
#define RectSetY(rect, y)             CGRectMake(RectX(rect), y, RectWidth(rect), RectHeight(rect))
#define RectSetSize(rect, w, h)       CGRectMake(RectX(rect), RectY(rect), w, h)
#define RectSetOrigin(rect, x, y)     CGRectMake(x, y, RectWidth(rect), RectHeight(rect))
#define ViewScaleHeight(h)            ScreenWidth * h/320
//----------------------G－C－D-------------------------
#define BACK(block)                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block)                   dispatch_async(dispatch_get_main_queue(),block)

//----------------------图片加载-------------------------
#define LOADIMAGE(file,type)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
//定义UIImage对象
#define IMAGE(A)                      [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]
//定义UIImage对象
#define ImageNamed(_pointer)          [UIImage imageNamed:_pointer]
//  图片：
#ifndef imagePath
#define imagePath(imageName)          [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"]]
#endif

//----------------------系统版本-------------------------
#define APP_VERSION                   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUILD                     ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])  //应用程序版本号
#define IOS_VERSION                   [[[UIDevice currentDevice] systemVersion] floatValue]   //ios系统版本号
#define CurrentLanguage               ([[NSLocale preferredLanguages] objectAtIndex:0]) //语言

//----------------------主要单例-------------------------
#define DeviceUUID  [[[UIDevice alloc] init] identifierForVendor].UUIDString
#define UserDefaults                 [NSUserDefaults standardUserDefaults]
#define NotificationCenter           [NSNotificationCenter defaultCenter]
#define SharedApplication            [UIApplication sharedApplication]
#define Bundle                       [NSBundle mainBundle]
#define MainScreen                   [UIScreen mainScreen]
#define ApplicationDelegate          ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define KeyWindow                    [UIApplication sharedApplication].keyWindow
#define Nib(s)                        [UINib nibWithNibName:s bundle:nil]


//----------------------网络指示-------------------------
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x

#endif
