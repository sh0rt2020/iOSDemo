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
#import "MASNoAccessView.h"
#import <Masonry.h>
#import "RedPocketViewController.h"

@interface ViewController ()<MASNoAccessViewDelagate, VFLNoAccessViewDelagate, NewNoAccessViewDelegate>

//@property (nonatomic) NoAccess *tipView;
//@property (nonatomic) NewNoAccessView *subTipView;
//@property (nonatomic) VFLNoAccessView *subTipView;
@property (nonatomic) MASNoAccessView *subTipView;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate method
- (void)newNoAccessViewWillDisappear {
    [self.subTipView hiddenFromView:[UIApplication sharedApplication].keyWindow animated:YES];
}

#pragma mark - event response
//- (IBAction)showTip:(UIButton *)sender {
    
//    [self.subTipView showInView:[UIApplication sharedApplication].keyWindow animated:NO];
//    self.subTipView.subTitleOne = @"第一副标题换了";
    
//    [self.subTipView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo([UIApplication sharedApplication].keyWindow);
//        make.size.mas_equalTo(CGSizeMake(226, 180));
//    }];
//}


#pragma mark - setter&getter
- (MASNoAccessView *)subTipView {
    _subTipView = [[MASNoAccessView alloc] initWithSubTitleOne:@"1、第一副标题" subTitleTwo:@"2、第二副标题"];
    _subTipView.delegate = self;
    return _subTipView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%s", __func__);

//    if ([segue.identifier isEqualToString:@"RedPocketViewController"]) {
//        RedPocketViewController *red = [[RedPocketViewController alloc] init];
//        [self.navigationController pushViewController:red animated:YES];
//    }
}


@end
