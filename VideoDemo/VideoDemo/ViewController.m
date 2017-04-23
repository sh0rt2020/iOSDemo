//
//  ViewController.m
//  VideoDemo
//
//  Created by sunwell on 2017/4/23.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "ViewController.h"
#import "GSVideoPlayerView.h"

static NSString * const video_url = @"http://gifs.51gif.com/20170405/video/8464480.mp4";
static NSString * const cell_identifier = @"video_cell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GSVideoPlayerView *playerView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    
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
    
//    if (indexPath.row == 0) {
//        cell.textLabel.text = @"";
//        
        if (![cell.contentView viewWithTag:99]) {
            [cell.contentView addSubview:self.playerView];
            [self play];
        }
//    } else {
//        cell.textLabel.text = [NSString stringWithFormat:@"index : %ld", indexPath.row];
//    }
    
    return cell;
}

#pragma mark - private method
- (void)play {
    [self.playerView setVideoUrl:video_url play:YES];
}

#pragma mark - getter & setter
- (GSVideoPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [GSVideoPlayerView new];
        _playerView.tag = 99;
        _playerView.frame = CGRectMake(8, 2, 40, 40);
    }
    return _playerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
    }
    return _tableView;
}
@end
