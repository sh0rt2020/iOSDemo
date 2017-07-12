//
//  ViewController.m
//  OpenGLDemo
//
//  Created by iosdevlope on 2017/6/20.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLView.h"
#import "OpenGLTextureView.h"

#import "IFFiltersViewController.h"

@interface ViewController ()
//@property (nonatomic, strong) OpenGLView *bgView;
@property (nonatomic, strong) OpenGLTextureView *bgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    self.bgView = [[OpenGLTextureView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.bgView];
    
//    UIButton *push = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width-40, 44)];
//    [push setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [push setTitle:@"PushToFilterView" forState:UIControlStateNormal];
//    [push addTarget:self action:@selector(handlePush:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:push];t
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
- (void)handlePush:(UIButton *)sender {
    IFFiltersViewController *filter = [IFFiltersViewController new];
//    [self.navigationController pushViewController:filter animated:YES];
    [self presentViewController:filter animated:YES completion:^{
        
    }];
}
@end
