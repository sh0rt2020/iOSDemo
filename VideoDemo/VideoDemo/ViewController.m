//
//  ViewController.m
//  VideoDemo
//
//  Created by sunwell on 2017/4/23.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "ViewController.h"
#import "GSAVPlayerViewController.h"
#import "GSNewPlayerViewController.h"
#import "GSMpegVideoViewController.h"


@interface ViewController ()

@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width-20, 44)];
    [button setTitle:@"PushToPlayerPage" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
- (void)handleButtonClick:(UIButton *)sender {
//    GSAVPlayerViewController *vc = [[GSAVPlayerViewController alloc] init];
//    GSNewPlayerViewController *vc = [[GSNewPlayerViewController alloc] init];
    GSMpegVideoViewController *vc = [[GSMpegVideoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
