//
//  CoreAnimationViewController.m
//  CoreAnimationDemo
//
//  Created by iosdevlope on 2017/5/25.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "CoreAnimationViewController.h"
//#import "GS_RotationGuestreRecognizer.h"
#import "GSAnimateView.h"

@interface CoreAnimationViewController ()
@property (nonatomic, strong) GSAnimateView *smallView;
@property (nonatomic, strong) UIButton *animateButton;
@end

@implementation CoreAnimationViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBorderLine];
    
    self.smallView = [[GSAnimateView alloc] initWithFrame:CGRectMake(50, 300, 200, 88)];
    self.smallView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.smallView];
    
    
//    [self checkView:self.smallView transform:self.smallView.transform isFirstTime:YES];
    
    
    self.animateButton = [[UIButton alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height-100, 44, 44)];
    self.animateButton.backgroundColor = [UIColor redColor];
    [self.animateButton addTarget:self action:@selector(handleAnimate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.animateButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - event response
- (void)handleAnimate:(UIButton *)sender {
    [UIView animateWithDuration:1 animations:^{
        self.smallView.transform = CGAffineTransformTranslate(self.smallView.transform, 100, 100);
    }];
}

#pragma mark - private method
- (void)addBorderLine {
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(10, 64+10, [UIScreen mainScreen].bounds.size.width-20, 1)];
    topLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:topLine];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(10, 64+10, 1, [UIScreen mainScreen].bounds.size.height-64-20)];
    leftLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-10, 64+10, 1, [UIScreen mainScreen].bounds.size.height-64-20)];
    rightLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:rightLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height-10, [UIScreen mainScreen].bounds.size.width-20, 1)];
    bottomLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottomLine];
}

#pragma mark - getter & setter

@end
