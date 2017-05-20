//
//  ViewController.m
//  VideoDemo
//
//  Created by sunwell on 2017/4/23.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "ViewController.h"
#import "GSVideoPlayerView.h"

//static NSString * const video_url = @"2531892.mp4";
//static NSString * const video_url = @"http://gifs.51gif.com/20161202/video/2531892.mp4";
//static NSString * const video_url = @"http://gifs.51gif.com/20161213/video/2786942.mp4";
static NSString * const video_url = @"http://gifs.51gif.com/20170405/video/8464480.mp4";
static NSString * const cell_identifier = @"video_cell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) GSVideoPlayerView *playerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *videoUrl;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    self.videoUrl = [[NSBundle mainBundle] pathForResource:@"8464480" ofType:@"mp4"];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//- (GSVideoPlayerView *)playerView {
//    if (!_playerView) {
//        _playerView = [GSVideoPlayerView new];
//        _playerView.tag = 99;
//        _playerView.frame = CGRectMake(8, 2, 40, 40);
//    }
//    return _playerView;
//}

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
