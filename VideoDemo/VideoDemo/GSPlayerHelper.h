//
//  GSPlayerHelper.h
//  VideoDemo
//
//  Created by iosdevlope on 2017/7/27.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import <Foundation/Foundation.h>

extern "C" {
#include <libswscale/swscale.h>
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
}

@interface GSPlayerHelper : NSObject

- (void)playWithFilePath:(NSString *)filePath;
@end
