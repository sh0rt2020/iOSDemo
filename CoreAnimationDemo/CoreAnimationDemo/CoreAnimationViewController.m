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
    
    self.smallView = [[GSAnimateView alloc] initWithFrame:CGRectMake(10, 100, 300, 88)];
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

#pragma mark - getter & setter

@end
