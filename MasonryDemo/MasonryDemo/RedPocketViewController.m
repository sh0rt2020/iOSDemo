//
//  RedPocketViewController.m
//  MasonryDemo
//
//  Created by Yige on 2016/11/25.
//  Copyright © 2016年 sunwell. All rights reserved.
//

//红包控制器
#import "RedPocketViewController.h"
#import "UCRedPocketView.h"

@interface RedPocketViewController ()

@property (nonatomic) UCRedPocketView *layout;
@end

@implementation RedPocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.layout = [UCRedPocketView new];
    [self.view addSubview:self.layout];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_layout);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_layout]-0-|" options:NSLayoutFormatAlignAllCenterY|NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_layout]-0-|" options:0 metrics:nil views:views]];
    
    [self.layout appearAnimate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
