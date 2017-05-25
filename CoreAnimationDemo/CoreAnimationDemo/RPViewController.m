//
//  RPViewController.m
//  AnimateDemo
//
//  Created by Yige on 2016/11/14.
//  Copyright © 2016年 Yige. All rights reserved.
//

#import "RPViewController.h"
#import "UCRedPocketView.h"

@interface RPViewController () <UCRedPocketViewDelegate> {
    UCRedPocketView *rpView;
}
@property (nonatomic, nonnull) UIDynamicAnimator *animator;
@end

@implementation RPViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rpView = [UCRedPocketView new];
    rpView.delegate = self;
    [self.view addSubview:rpView];
//    [rpView setNeedsLayout];
//    [rpView layoutIfNeeded];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(rpView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[rpView]-0-|" options:NSLayoutFormatAlignAllCenterY|NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[rpView]-0-|" options:0 metrics:nil views:views]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:rpView];
//    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[rpView.pocketView]];
//    gravity.gravityDirection = CGVectorMake(0, 1);
//    gravity.magnitude = 1.5;
//    [self.animator addBehavior:gravity];
//    
//    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[rpView.pocketView]];
//    [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, 0, 100, 0)];
//    [self.animator addBehavior:collision];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UCRedPocketViewDelegate
- (void)didClickOpenRedPocket:(UIButton *)sender {
    NSLog(@"%s", __func__);
    [rpView disappearAnimateCompleted:^(UCRedPocketView *ss) {
//        alert = [UCAlertView new];
//        alert.delegate = self;
//        [alert showInView:[UIApplication sharedApplication].keyWindow animated:YES];
//        
//        if (datas.count > 0) {
//            [ss resetView];
//        }
    }];
}

@end
