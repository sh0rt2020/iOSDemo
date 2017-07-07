//
//  ViewController.m
//  FilterDemo
//
//  Created by iosdevlope on 2017/7/6.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "ViewController.h"
#import "GlobalDefs.h"
#import "FilterViewController.h"

@interface ViewController ()

@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *pushButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, SCREENW-40, 44)];
    [pushButton setTitle:@"Push" forState:UIControlStateNormal];
    pushButton.backgroundColor = [UIColor orangeColor];
    [pushButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(handlePush:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
- (void)handlePush:(UIButton *)sender {
    FilterViewController *filterVC = [FilterViewController new];
    [self.navigationController pushViewController:filterVC animated:YES];
}

@end
