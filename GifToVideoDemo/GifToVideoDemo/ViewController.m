//
//  ViewController.m
//  GifToVideoDemo
//
//  Created by iosdevlope on 2017/10/13.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//


#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.button];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate 

#pragma mark - event
- (void)handleButtonAction:(UIButton *)sender {
    [self merge];
}

#pragma mark - private
- (void)merge {
    //路径
    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSURL *audioUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"五环之歌" ofType:@"mp3"]];
    NSURL *videoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"雪碧" ofType:@"mp4"]];
    
    
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
    NSString *outFilePath = [documents stringByAppendingPathComponent:@"merge.mp4"];
    NSURL *outFileUrl = [NSURL fileURLWithPath:outFilePath];
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
    playerLayer.frame = self.imageView.frame;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.imageView.layer addSublayer:playerLayer];
    
    [player play];
}

#pragma mark - setter & getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, SCREENW, 300);
        _imageView.backgroundColor = [UIColor orangeColor];
    }
    return _imageView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.frame = CGRectMake(0, self.imageView.frame.size.height + 50, SCREENW, 100);
        _button.backgroundColor = [UIColor greenColor];
        [_button setTitle:@"开始合成" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
@end
