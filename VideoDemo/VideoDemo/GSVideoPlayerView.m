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
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoFinished:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.player.currentItem];
    }
    
    if (!self.playerLayer && self.player) {
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.bounds;
        [self.layer addSublayer:self.playerLayer];
    }
    
    if (self.playerLayer && isPlay) {
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }
}

#pragma mark - notification
- (void)videoFinished:(NSNotification *)notification {
    AVPlayerItem *playItem = notification.object;
    [playItem seekToTime:kCMTimeZero];
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
