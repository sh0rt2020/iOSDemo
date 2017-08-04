//
//  GSPlayerHelper.h
//  VideoDemo
//
//  Created by iosdevlope on 2017/7/27.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern "C" {
//#include <libavcodec/avcodec.h>
//#include <libavformat/avformat.h>
//    
//#include <libswscale/swscale.h>
//}

@class GSMpegPlayer;

@interface GSPlayerHelper : UIView

+ (instancetype)sharedPlayerHelper;
- (void)playWithFilePath:(NSString *)filePath;

@property (nonatomic, strong) GSMpegPlayer *playerView;
@end
