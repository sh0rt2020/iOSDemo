//
//  VideoAndAudioMerger.m
//  GifToVideoDemo
//
//  Created by iosdevlope on 2017/10/13.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "VideoAndAudioMerger.h"
#import <AVFoundation/AVFoundation.h>
#import "Gif2MP4Convertor.h"


@interface VideoAndAudioMerger ()

@property (nonatomic, strong)  UIImageView *videoContainer;
@end

@implementation VideoAndAudioMerger

#pragma mark - public
- (id)initWithVideoContainer:(UIImageView *)videoContainer {
    self = [super init];
    if (self) {
        self.videoContainer = videoContainer;
    }
    return self;
}

- (void)convertAndMerge {
    //路径
    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSURL *videoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mp4"]];
//    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"gif"];
    NSString *gifUrlString = @"http://gifs.51gif.com/20170912/preview/995b7d613e684aee8d2422103e8e4050_p.gif";
    NSString *videoPath = [documents stringByAppendingPathComponent:@"video.mp4"];
    NSString *thumbPath =[documents stringByAppendingPathComponent:@"thumb/"];
    
//    __weak typeof(self) weakSelf = self;
    [Gif2MP4Convertor sendAsynchronousRequest:gifUrlString downloadFilePath:videoPath thumbnailFilePath:thumbPath completed:^(NSString *outputFilePath, NSError *error) {
        
        NSURL *outFileUrl = [NSURL URLWithString:[documents stringByAppendingPathComponent:@"merge.mp4"]];
        NSURL *audioUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mp3"]];
        NSURL *videoUrl = [NSURL URLWithString:outputFilePath];
        
//        __strong typeof(self) strongSelf = weakSelf;
        [self mergeWithAudioUrl:audioUrl videoUrl:videoUrl outFileUrl:outFileUrl];
    }];
}

- (void)mergeWithAudioUrl:(NSURL *)audioUrl videoUrl:(NSURL *)videoUrl outFileUrl:(NSURL *)outFileUrl {
    
    //合成
    CMTime nextCliStartTime = kCMTimeZero;
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    //视频采集
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextCliStartTime error:nil];
    
    //音频采集
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioUrl options:nil];
    CMTimeRange audioTimeRange = videoTimeRange;
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:audioTimeRange ofTrack:audioAssetTrack atTime:nextCliStartTime error:nil];
    
    //创建输出
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPreset640x480];
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    assetExport.outputURL = outFileUrl;
    assetExport.shouldOptimizeForNetworkUse = YES;
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playVideoWithUrl:outFileUrl];
        });
    }];
}


- (void)playVideoWithUrl:(NSURL *)videoUrl {
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.videoContainer.frame;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.videoContainer.layer addSublayer:playerLayer];
    
    [player play];
}

#pragma mark - private



@end
