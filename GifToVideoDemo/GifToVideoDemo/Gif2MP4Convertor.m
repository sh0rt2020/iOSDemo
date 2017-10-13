//
//  Gif2MP4Convertor.m
//  GifToVideoDemo
//
//  Created by iosdevlope on 2017/10/13.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "Gif2MP4Convertor.h"
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define FPS 30

NSString * const kGIF2MP4ConversionErrorDomain = @"GIF2MP4ConversionError";

@implementation Gif2MP4Convertor

+ (NSOperationQueue*) requestQueue {
    static NSOperationQueue* requestQueue = nil;
    if( !requestQueue ) {
        requestQueue = [NSOperationQueue new];
        requestQueue.maxConcurrentOperationCount = 5;
        
    }
    return requestQueue;
}

static __strong NSMutableArray* requests = nil;
+ (BOOL) queueContainsRequest: (NSURLRequest*) request {
    if( !requests ) {
        requests = [NSMutableArray new];
    }
    
    return [requests containsObject: request.URL.absoluteString];
}

+ (void) removeRequest: (NSURLRequest*) request {
    [requests removeObject: request.URL.absoluteString];
}

+ (void) addRequest: (NSURLRequest*) request {
    [requests addObject: request.URL.absoluteString];
}

+ (void) sendAsynchronousRequest: (NSString*) srcURLPath
                downloadFilePath: (NSString*) filePath
               thumbnailFilePath: (NSString *)thumbFilePath
                       completed: (kGIF2MP4ConversionCompleted)handler {
    
    if( !srcURLPath )
        return;
    
    if( !filePath )
        return;
    
    if( !handler )
        return;
    
    NSParameterAssert(srcURLPath);
    NSParameterAssert(filePath);
    NSParameterAssert(handler);
    
    NSURL* URL = [NSURL URLWithString: srcURLPath];
    NSURLRequest* request = [NSURLRequest requestWithURL: URL];
    
    if( [self queueContainsRequest: request] ) {
        NSError* error = [NSError errorWithDomain: kGIF2MP4ConversionErrorDomain
                                             code: kGIF2MP4ConversionErrorAlreadyProcessing
                                         userInfo: nil];
        handler(filePath, error);
        return;
    }
    
    [self addRequest: request];
    
    [[self requestQueue] addOperationWithBlock: ^{
        
#if DEBUG
        NSLog(@"Start writing: %@", filePath.lastPathComponent);
#endif
        //NSURLResponse* response = nil;
        NSError* error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest: request
                                             returningResponse: NULL
                                                         error: &error];
        
        if( error ) {
            [self queueContainsRequest: request];
            handler(filePath, error);
        }
        else {
            if( [[NSFileManager defaultManager] fileExistsAtPath: filePath] ) {
                [[NSFileManager defaultManager] removeItemAtPath: filePath
                                                           error: &error];
                if( error ) {
                    [self queueContainsRequest: request];
                    handler(filePath, error);
                }
            }
            
            NSURL* outFilePath = [NSURL fileURLWithPath: filePath];
            
            kGIF2MP4ConversionCompleted completionHandler = ^(NSString* path, NSError* error) {
                [self removeRequest: request];
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(path, error);
                });
                
            };
            
            [self processGIFData: data toFilePath: outFilePath thumbFilePath: thumbFilePath completed: completionHandler];
        }
#if DEBUG
        NSLog(@"Finish writing: %@", filePath.lastPathComponent);
#endif
    }];
}

+ (BOOL) processGIFData: (NSData*) data
             toFilePath: (NSURL*) outFilePath
          thumbFilePath: (NSString*) thumbFilePath
              completed: (kGIF2MP4ConversionCompleted) completionHandler {
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    unsigned char *bytes = (unsigned char*)data.bytes;
    NSError* error = nil;
    
    if( !CGImageSourceGetStatus(source) == kCGImageStatusComplete ) {
        error = [NSError errorWithDomain: kGIF2MP4ConversionErrorDomain
                                    code: kGIF2MP4ConversionErrorInvalidGIFImage
                                userInfo: nil];
        CFRelease(source);
        completionHandler(outFilePath.absoluteString, error);
        return NO;
    }
    
    size_t sourceWidth = bytes[6] + (bytes[7]<<8), sourceHeight = bytes[8] + (bytes[9]<<8);
    //size_t sourceFrameCount = CGImageSourceGetCount(source);
    __block size_t currentFrameNumber = 0;
    __block Float64 totalFrameDelay = 0.f;
    
    AVAssetWriter* videoWriter = [[AVAssetWriter alloc] initWithURL: outFilePath
                                                           fileType: AVFileTypeQuickTimeMovie
                                                              error: &error];
    if( error ) {
        CFRelease(source);
        completionHandler(outFilePath.absoluteString, error);
        return NO;
    }
    
    if( sourceWidth > 640 || sourceWidth == 0) {
        CFRelease(source);
        error = [NSError errorWithDomain: kGIF2MP4ConversionErrorDomain
                                    code: kGIF2MP4ConversionErrorInvalidResolution
                                userInfo: nil];
        completionHandler(outFilePath.absoluteString, error);
        return NO;
    }
    
    if( sourceHeight > 480 || sourceHeight == 0 ) {
        CFRelease(source);
        error = [NSError errorWithDomain: kGIF2MP4ConversionErrorDomain
                                    code: kGIF2MP4ConversionErrorInvalidResolution
                                userInfo: nil];
        completionHandler(outFilePath.absoluteString, error);
        return NO;
    }
    
    size_t totalFrameCount = CGImageSourceGetCount(source);
    size_t thumbnailFrameCount = floorf( totalFrameCount * 0.05 );
    
    if( totalFrameCount <= 0 ) {
        CFRelease(source);
        error = [NSError errorWithDomain: kGIF2MP4ConversionErrorDomain
                                    code: kGIF2MP4ConversionErrorInvalidGIFImage
                                userInfo: nil];
        completionHandler(outFilePath.absoluteString, error);
        return NO;
    }
    
    NSAssert(sourceWidth <= 640, @"%lu is too wide for a video", sourceWidth);
    NSAssert(sourceHeight <= 480, @"%lu is too tall for a video", sourceHeight);
    
    NSDictionary *videoSettings = @{
                                    AVVideoCodecKey : AVVideoCodecH264,
                                    AVVideoWidthKey : @(sourceWidth),
                                    AVVideoHeightKey : @(sourceHeight)
                                    };
    
    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType: AVMediaTypeVideo
                                                                              outputSettings: videoSettings];
    videoWriterInput.expectsMediaDataInRealTime = YES;
    
    NSAssert([videoWriter canAddInput: videoWriterInput], @"Video writer can not add video writer input");
    [videoWriter addInput: videoWriterInput];
    
    NSDictionary* attributes = @{
                                 (NSString*)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32ARGB),
                                 (NSString*)kCVPixelBufferWidthKey : @(sourceWidth),
                                 (NSString*)kCVPixelBufferHeightKey : @(sourceHeight),
                                 (NSString*)kCVPixelBufferCGImageCompatibilityKey : @YES,
                                 (NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES
                                 };
    
    AVAssetWriterInputPixelBufferAdaptor* adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput: videoWriterInput
                                                                                                                     sourcePixelBufferAttributes: attributes];
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime: CMTimeMakeWithSeconds(totalFrameDelay, FPS)];
    
    while(1) {
        if( videoWriterInput.isReadyForMoreMediaData ) {
#if DEBUG
            //NSLog(@"Drawing frame %lu/%lu", currentFrameNumber, totalFrameCount);
#endif
            NSDictionary* options = @{(NSString*)kCGImageSourceTypeIdentifierHint : (id)kUTTypeGIF};
            CGImageRef imgRef = CGImageSourceCreateImageAtIndex(source, currentFrameNumber, (__bridge CFDictionaryRef)options);
            if( imgRef ) {
                CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(source, currentFrameNumber, NULL);
                CFDictionaryRef gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
                
                //Save our thumbnail
                if( thumbnailFrameCount == currentFrameNumber ) {
                    if( [[NSFileManager defaultManager] fileExistsAtPath: thumbFilePath] ) {
                        [[NSFileManager defaultManager] removeItemAtPath: thumbFilePath error: nil];
                    }
                    
                    UIImage *img = [UIImage imageWithCGImage: imgRef];
                    [UIImagePNGRepresentation(img) writeToFile: thumbFilePath atomically: YES];
                }
                
                if( gifProperties ) {
                    CVPixelBufferRef pxBuffer = [self newBufferFrom: imgRef
                                                withPixelBufferPool: adaptor.pixelBufferPool
                                                      andAttributes: adaptor.sourcePixelBufferAttributes];
                    if( pxBuffer ) {
                        NSNumber* delayTime = CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
                        totalFrameDelay += delayTime.floatValue;
                        CMTime time = CMTimeMakeWithSeconds(totalFrameDelay, FPS);
                        
                        if( ![adaptor appendPixelBuffer: pxBuffer withPresentationTime: time] ) {
                            TFLog(@"Could not save pixel buffer!: %@", videoWriter.error);
                            CFRelease(properties);
                            CGImageRelease(imgRef);
                            CVBufferRelease(pxBuffer);
                            break;
                        }
                        
                        CVBufferRelease(pxBuffer);
                    }
                }
                
                if( properties ) CFRelease(properties);
                CGImageRelease(imgRef);
                
                currentFrameNumber++;
            } else {
                //was no image returned -> end of file?
                [videoWriterInput markAsFinished];
                
                void (^videoSaveFinished)(void) = ^{
                    completionHandler(outFilePath.absoluteString, nil);
                };
                
                if( [videoWriter respondsToSelector: @selector(finishWritingWithCompletionHandler:)]) {
                    [videoWriter finishWritingWithCompletionHandler: videoSaveFinished];
                }
                else {
                    [videoWriter finishWriting];
                    videoSaveFinished();
                }
                break;
            }
        }
        else {
            //NSLog(@"Was not ready...");
            [NSThread sleepForTimeInterval: 0.1];
        }
    };
    
    CFRelease(source);
    
    return YES;
};

+ (CVPixelBufferRef) newBufferFrom: (CGImageRef) frame
               withPixelBufferPool: (CVPixelBufferPoolRef) pixelBufferPool
                     andAttributes: (NSDictionary*) attributes {
    NSParameterAssert(frame);
    
    size_t width = CGImageGetWidth(frame);
    size_t height = CGImageGetHeight(frame);
    size_t bpc = 8;
    CGColorSpaceRef colorSpace =  CGColorSpaceCreateDeviceRGB();
    
    CVPixelBufferRef pxBuffer = NULL;
    CVReturn status = kCVReturnSuccess;
    
    if( pixelBufferPool )
        status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &pxBuffer);
    else {
        status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef)attributes, &pxBuffer);
    }
    
    NSAssert(status == kCVReturnSuccess, @"Could not create a pixel buffer");
    
    CVPixelBufferLockBaseAddress(pxBuffer, 0);
    void *pxData = CVPixelBufferGetBaseAddress(pxBuffer);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pxBuffer);
    
    
    CGContextRef context = CGBitmapContextCreate(pxData,
                                                 width,
                                                 height,
                                                 bpc,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSAssert(context, @"Could not create a context");
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), frame);
    
    CVPixelBufferUnlockBaseAddress(pxBuffer, 0);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return pxBuffer;
}

@end
