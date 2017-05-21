//
//  ViewController.m
//  VideoDemo
//
//  Created by sunwell on 2017/4/23.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "ViewController.h"
#import "GSVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const video_url = @"http://gifs.51gif.com/20161202/video/2531892.mp4";
//static NSString * const video_url = @"http://gifs.51gif.com/20161213/video/2786942.mp4";
//static NSString * const video_url = @"http://gifs.51gif.com/20170405/video/8464480.mp4";
static NSString * const cell_identifier = @"video_cell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) GSVideoPlayerView *playerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSURL *videoUrl;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self.view addSubview:self.tableView];
    self.videoUrl = [[NSBundle mainBundle] URLForResource:@"2531892" withExtension:@"mp4"];
    //[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.player = [[AVPlayer alloc] initWithURL:self.videoUrl];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    UIView *playView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    self.playerLayer.frame = playView.bounds;
    [playView.layer addSublayer:self.playerLayer];
    [self.view addSubview:playView];
    
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStalled:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    AVPlayerItem *player = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
            
            [self.player play];
            NSLog(@"正在播放..，视频总长度为:%.2f",CMTimeGetSeconds(player.duration));
        }
    }else if ( [keyPath isEqualToString:@"loadedTimeRanges"] ) {
        NSArray *array = player.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

- (void)videoStalled:(NSNotification *)notification {
    NSLog(@"video stalled");
}

- (void)videoFinished:(NSNotification *)notification {
    NSLog(@"video finished");
}

#pragma mark - delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier];
    }
    
    GSVideoPlayerView *playerView = nil;
    if (![cell.contentView viewWithTag:99]) {
        playerView = [[GSVideoPlayerView alloc] initWithFrame:CGRectMake(10, 2, 60, tableView.rowHeight-4)];
        playerView.tag = 99;
        [cell.contentView addSubview:playerView];
    } else {
        playerView = [cell.contentView viewWithTag:99];
    }
    
    [playerView setVideoUrl:video_url play:YES];
    
    return cell;
}

#pragma mark - private method


#pragma mark - getter & setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
    }
    return _tableView;
}
@end
