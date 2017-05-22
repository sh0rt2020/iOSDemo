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
//        NSLog(@"不为空");
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

#pragma mark - public method
- (void)setVideoUrl:(NSString *)url play:(BOOL)isPlay {
    if (!self.player) {
        //self.player = [AVPlayer playerWithURL:[NSURL URLWithString:url]];
        
        AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:url]];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
        self.player = [AVPlayer playerWithPlayerItem:item];
        //self.player.automaticallyWaitsToMinimizeStalling = NO;
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        [self addNotification];
        [self addObserver];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeObserver];
        
        AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:url]];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
        [self.player replaceCurrentItemWithPlayerItem:item];
        
        [self addNotification];
        [self addObserver];
    }
    
    if (!self.playerLayer && self.player) {
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.bounds;
        [self.layer addSublayer:self.playerLayer];
    }
    
    
    if (self.playerLayer && isPlay) {
        //[self.player seekToTime:kCMTimeZero];
        [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        //[self.player play];
    }
}

#pragma mark - notification&observer handler
- (void)videoFinished:(NSNotification *)notification {
    AVPlayerItem *playItem = notification.object;
    //[playItem seekToTime:kCMTimeZero];
    [playItem seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)videoStalled:(NSNotification *)notification {
    NSLog(@"video stalled");
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
            
            [self.player play];
            NSLog(@"正在播放..，视频总长度为:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    } else if ( [keyPath isEqualToString:@"loadedTimeRanges"] ) {
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}


#pragma mark - notification&observer
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStalled:) name:AVPlayerItemPlaybackStalledNotification object:nil];
}

- (void)addObserver {
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    [self.player pause];
    
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

#pragma mark - getter & setter


#pragma mark - over ride uiview method

@end
