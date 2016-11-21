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

@property (nonatomic) UILabel *labbb;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.lab = [[NBLabel alloc] initWithFrame:CGRectMake(10, 100, Screen_Width-20, 80)];
    self.lab.maxNum = 30;
    self.lab.lines = 2;
    self.lab.title = @"的部位被分什么大家你是\n爱五耳边风啊是的宏伟俺怕死的h这是什么鬼i欧微分爱是极好的";
    self.lab.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.lab];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

@end
