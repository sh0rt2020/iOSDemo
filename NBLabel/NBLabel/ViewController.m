//
//  ViewController.m
//  NBLabel
//
//  Created by sunwell on 2016/11/20.
//  Copyright © 2016年 sunwell. All rights reserved.
//


#define Screen_Width   [[UIScreen mainScreen] bounds].size.width
#define Screen_Height  [[UIScreen mainScreen] bounds].size.height

#import "ViewController.h"
#import "NBLabel.h"

@interface ViewController ()
@property (nonatomic) NBLabel *lab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.lab = [[NBLabel alloc] initWithFrame:CGRectMake(10, 100, Screen_Width-20, 80)];
    self.lab.maxNum = 20;
    self.lab.lines = 2;
    self.lab.title = @"阿哈哈\n爱五耳边风";
    self.lab.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.lab];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

@end
