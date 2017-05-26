//
//  GSNewPlayerViewController.m
//  VideoDemo
//
//  Created by iosdevlope on 2017/5/23.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "GSNewPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

//static NSString * const video_url = @"http://gifs.51gif.com/20161202/video/2531892.mp4";
//static NSString * const video_url = @"http://gifs.51gif.com/20170405/video/8464480.mp4";

@interface GSNewPlayerViewController ()
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) NSMutableArray *imgRefArr;
@property (nonatomic, copy) NSURL *videoUrl;
@end

@implementation GSNewPlayerViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.videoUrl = [[NSBundle mainBundle] URLForResource:@"2531892" withExtension:@"mp4"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.playView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
    [self.view addSubview:self.playView];
    
    [self decodeVideoAsset:self.videoUrl];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)decodeVideoAsset:(id)url {

        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
//    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:nil];
    //    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:url]];
    NSError *error;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];

    int m_pixelFormatType = kCVPixelFormatType_32BGRA;
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt: (int)m_pixelFormatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVAssetReaderTrackOutput *videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:options];
    [reader addOutput:videoReaderOutput];
    [reader startReading];

    // 读取视频每一个buffer转换成CGImageRef
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     CMSampleBufferRef audioSampleBuffer = NULL;
     while ([reader status] == AVAssetReaderStatusReading && videoTrack.nominalFrameRate > 0) {
         CMSampleBufferRef sampleBuffer = [videoReaderOutput copyNextSampleBuffer];
         if (!sampleBuffer) {
             return ;
         }
         
         CGImageRef image = [self imageFromSampleBuffer:sampleBuffer];
         [self mMovieDecoder:self onNewVideoFrameReady:image];
         if (self.imgRefArr) {
             [self.imgRefArr addObject:(__bridge id _Nonnull)(image)];
         } else {
             self.imgRefArr = [NSMutableArray array];
             [self.imgRefArr addObject:(__bridge id _Nonnull)(image)];
         }
         
         if(sampleBuffer) {
             if(audioSampleBuffer) { // release old buffer.
                 CFRelease(audioSampleBuffer);
                 audioSampleBuffer = nil;
             }
             audioSampleBuffer = sampleBuffer;
         } else {
             break;
         }
         
         // 休眠的间隙刚好是每一帧的间隔
         [NSThread sleepForTimeInterval:CMTimeGetSeconds(videoTrack.minFrameDuration)];
     }
     // decode finish
     float durationInSeconds = CMTimeGetSeconds(asset.duration);
     if (self.imgRefArr && self.imgRefArr.count > 0) {
         [self mMovieDecoderOnDecodeFinished:self images:self.imgRefArr duration:durationInSeconds];
     }
    });
}
                     
                     
- (CGImageRef)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    //Generate image to edit
    unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return image;
}


- (void)mMovieDecoder:(id)decoder
 onNewVideoFrameReady:(CGImageRef)imgRef {
    
    __weak UIView *weakView = self.playView;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakView.layer.contents = (__bridge id _Nullable)(imgRef);
    });
}


//images即每一帧传上来的CGImageRef的数组
- (void)mMovieDecoderOnDecodeFinished:(id)decoder
                               images:(NSArray *)imgs
                             duration:(float)duration {
    
    __weak UIView *weakView = self.playView;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakView.layer.contents = nil;
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath: @"contents"];
        animation.calculationMode = kCAAnimationDiscrete;
        animation.duration = duration;
        animation.repeatCount = HUGE; //循环播放
        animation.values = imgs; // NSArray of CGImageRefs
        [weakView.layer addAnimation:animation forKey: @"contents"];
    });
}
@end
