//
//  ViewController.m
//  CoreAnimationDemo
//
//  Created by sunwell on 2017/5/24.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "ViewController.h"
#import "CoreAnimationViewController.h"

@interface ViewController ()

@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *moveToCoreAnimationPage = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width-20, 44)];
    [moveToCoreAnimationPage setTitle:@"MoveToCoreAnimationPage" forState:UIControlStateNormal];
    [moveToCoreAnimationPage setBackgroundColor:[UIColor greenColor]];
    [moveToCoreAnimationPage addTarget:self action:@selector(moveToCoreAnimationPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moveToCoreAnimationPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event reponse
- (void)moveToCoreAnimationPage:(UIButton *)sender {
    CoreAnimationViewController *vc = [[CoreAnimationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
