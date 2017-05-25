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
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 300, 44)];
    [button addTarget:self action:@selector(handleAnimationStart:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"startAnimate" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)handleAnimationStart:(UIButton *)sender {
    RPViewController *vc = [[RPViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
