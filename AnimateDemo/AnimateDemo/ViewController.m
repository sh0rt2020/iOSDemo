//
//  ViewController.m
//  AnimateDemo
//
//  Created by Yige on 2016/11/14.
//  Copyright © 2016年 Yige. All rights reserved.
//

#import "ViewController.h"
#import "RPViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response

- (IBAction)startAnimate:(UIButton *)sender {
    
    RPViewController *rpVC = [[RPViewController alloc] init];
    [self.navigationController pushViewController:rpVC animated:YES];
}


@end
