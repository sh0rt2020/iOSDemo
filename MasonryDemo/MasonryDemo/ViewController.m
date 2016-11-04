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
#import "VFLNoAccessView.h"

@interface ViewController ()<VFLNoAccessViewDelagate, NewNoAccessViewDelegate>

//@property (nonatomic) NoAccess *tipView;
//@property (nonatomic) NewNoAccessView *subTipView;
@property (nonatomic) VFLNoAccessView *subTipView;
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
    
    [self.subTipView showInView:[UIApplication sharedApplication].keyWindow animated:NO];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_subTipView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_subTipView]" options:NSLayoutFormatAlignAllCenterX|NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
//    [_subTipView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_subTipView.imgView(80)]-2-[_subTipView.titleLab(20)]-2-[_subTipView.subTitleOneLab(20)]-2-[_subTipView.subTitleTwoLab(20)]-2-[_subTipView.okBtn(20)]" options:0 metrics:nil views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-65-[_imgView(95)]" options:0 metrics:nil views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleLab]-0-|" options:0 metrics:nil views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_subTitleOneLab]-0-|" options:0 metrics:nil views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_subTitleTwoLab]-0-|" options:0 metrics:nil views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_okBtn]-0-|" options:0 metrics:nil views:views]];
    self.subTipView.subTitleOne = @"第一副标题换了";
}


#pragma mark - setter&getter
- (VFLNoAccessView *)subTipView {
    _subTipView = [[VFLNoAccessView alloc] initWithSubTitleOne:@"1、第一副标题" subTitleTwo:@"2、第二副标题"];
    _subTipView.delegate = self;
    return _subTipView;
}
@end
