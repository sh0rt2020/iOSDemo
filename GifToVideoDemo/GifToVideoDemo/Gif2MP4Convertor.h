//
//  Gif2MP4Convertor.h
//  GifToVideoDemo
//
//  Created by iosdevlope on 2017/10/13.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gif2MP4Convertor : NSObject

FOUNDATION_EXTERN NSString * const kGIF2MP4ConversionErrorDomain;
typedef enum {
    kGIF2MP4ConversionErrorInvalidGIFImage = 0,
    kGIF2MP4ConversionErrorAlreadyProcessing,
    kGIF2MP4ConversionErrorBufferingFailed,
    kGIF2MP4ConversionErrorInvalidResolution,
    kGIF2MP4ConversionErrorTimedOut,
} kGIF2MP4ConversionError;

typedef void (^kGIF2MP4ConversionCompleted) (NSString* outputFilePath, NSError* error);

+ (void) sendAsynchronousRequest: (NSString*) srcPath
                downloadFilePath: (NSString*) filePath
               thumbnailFilePath: (NSString*) thumbFilePath
                       completed: (kGIF2MP4ConversionCompleted) handler;

@end
