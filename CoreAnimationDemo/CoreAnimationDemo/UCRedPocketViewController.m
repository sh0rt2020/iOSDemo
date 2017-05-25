//
//  UCRedPocketViewController.m
//  CoreAnimationDemo
//
//  Created by sunwell on 2017/5/25.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "UCRedPocketViewController.h"
#import "RPViewController.h"

@interface UCRedPocketViewController ()

@end

@implementation UCRedPocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *startAnimate = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 300, 44)];
    [startAnimate setTitle:@"startAnimate" forState:UIControlStateNormal];
    [startAnimate addTarget:self action:@selector(handleAnimateStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startAnimate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleAnimateStart:(UIButton *)sender {
    RPViewController *vc = [[RPViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
