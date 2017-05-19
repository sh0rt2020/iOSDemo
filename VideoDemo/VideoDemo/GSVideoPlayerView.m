//
//  GSVideoPlayerView.m
//  VideoDemo
//
//  Created by sunwell on 2017/4/23.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "GSVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface GSVideoPlayerView ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation GSVideoPlayerView

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        //属性初始化
        NSLog(@"不为空");
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

#pragma mark - public method
- (void)setVideoUrl:(NSString *)url play:(BOOL)isPlay {
    if (!self.player && url) {
        self.player = [AVPlayer playerWithURL:[NSURL URLWithString:url]];
        self.player.automaticallyWaitsToMinimizeStalling = NO;
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(videoFinished:)
//                                                     name:AVPlayerItemDidPlayToEndTimeNotification
//                                                   object:self.player.currentItem];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStalled:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    }
    
    if (!self.playerLayer && self.player) {
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.bounds;
        [self.layer addSublayer:self.playerLayer];
    }
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    if (self.playerLayer && isPlay) {
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {//状态发生改变
        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"正在播放..，视频总长度为:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    } else if ( [keyPath isEqualToString:@"loadedTimeRanges"] ) {//缓冲区域变化
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//已缓冲范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

#pragma mark - notification
- (void)videoFinished:(NSNotification *)notification {
    AVPlayerItem *playItem = notification.object;
    [playItem seekToTime:kCMTimeZero];
}

- (void)videoStalled:(NSNotification *)notification {
    NSLog(@"video stalled");
}


#pragma mark - getter & setter 
//- (AVPlayer *)player {
//    return self.playerLayer.player;
//}
//
//- (void)setPlayer:(AVPlayer *)player {
//    self.playerLayer.player = player;
//}
//
//- (AVPlayerLayer *)playerLayer {
//    return (AVPlayerLayer *)self.playerLayer;
//}

#pragma mark - over ride uiview method
//+ (Class)layerClass {
//    return [AVPlayerLayer class];
//}

@end
