//
//  ViewController.m
//  NoAccessDemo
//
//  Created by Yige on 2016/10/27.
//  Copyright © 2016年 Yige. All rights reserved.
//

#import "ViewController.h"
//#import "NoAccess.h"
#import "NewNoAccessView.h"

@interface ViewController () <NewNoAccessViewDelegate>

//@property (nonatomic) NoAccess *tipView;
@property (nonatomic) NewNoAccessView *subTipView;
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

#pragma mark - delegate method
- (void)newNoAccessViewWillDisappear {
    [self.subTipView hiddenFromView:[UIApplication sharedApplication].keyWindow animated:NO];
}

#pragma mark - event response
- (IBAction)showTip:(UIButton *)sender {
    
    [self.newTipNew showInView:[UIApplication sharedApplication].keyWindow animated:NO];
    self.subTipView.subTitleOne = @"第一副标题换了";
}


#pragma mark - setter&getter
- (NewNoAccessView *)newTipNew {
    _subTipView = [[NewNoAccessView alloc] initWithSubTitleOne:@"1、第一副标题" subTitleTwo:@"2、第二副标题"];
    _subTipView.delegate = self;
    return _subTipView;
}
@end
