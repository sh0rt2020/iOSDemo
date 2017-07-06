//
//  ViewController.m
//  FilterDemo
//
//  Created by iosdevlope on 2017/7/6.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *pushButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, SCREENW-40, 44)];
    [pushButton setTitle:@"Push" forState:UIControlStateNormal];
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
    
}

@end
