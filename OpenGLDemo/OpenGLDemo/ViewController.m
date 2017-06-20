//
//  ViewController.m
//  OpenGLDemo
//
//  Created by iosdevlope on 2017/6/20.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLView.h"

@interface ViewController ()
@property (nonatomic, strong) OpenGLView *bgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    self.bgView = [[OpenGLView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.alpha = 1.0;
    [self.view addSubview:self.bgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
