//
//  ViewController.m
//  OpenGLDemo
//
//  Created by iosdevlope on 2017/6/19.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLView.h"

@interface ViewController ()
@property (nonatomic, strong) OpenGLView *bgView;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    UIButton *push = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, [UIScreen mainScreen].bounds.size.width-40, 44)];
//    [push addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
//    [push setBackgroundColor:[UIColor blueColor]];
//    [push setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [push setTitle:@"Push to OpenGL View" forState:UIControlStateNormal];
//    [self.view addSubview:push];
    
    self.bgView = [[OpenGLView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.bgView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
- (void)handlePush:(UIButton *)sender {
    
}
@end
