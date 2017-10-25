//
//  GBGlobalDef.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/17.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef GBGlobalDef_h
#define GBGlobalDef_h

//arc
#define WEAKSELF __weak typeof(self) weakself = self

//screen
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SCREEN   [UIScreen mainScreen].bounds

#define ImgWidth  (SCREEN_W-14*2-2)/3

//image
#define IMAGE(name, type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]]
#define ImageNamed(A) [UIImage imageNamed:A]

//Log
#ifndef DEBUG_MODE
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#define OMGLog(...) NSLog(__VA_ARGS__);[OMGToast showWithText:[NSString stringWithFormat:__VA_ARGS__]];
#else
#define DLog( s, ... )
#define OMGLog(...)
#endif

//appversion
#define AppVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#endif /* GBGlobalDef_h */
