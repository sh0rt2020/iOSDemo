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
@property (nonatomic, strong) NSMutableDictionary *pointsDic;
//@property (nonatomic, assign) CGRect fatherFrame;
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
    
    
    [self checkView:self.smallView transform:self.smallView.transform isFirstTime:YES];
    
    
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
- (void)checkView:(UIView *)view
        transform:(CGAffineTransform)trans
      isFirstTime:(BOOL)isFirstTime {
    
    if (!self.pointsDic) {
        self.pointsDic = [NSMutableDictionary dictionary];
    }
    
    
    CGPoint topleft = CGPointZero;
    CGPoint topright = CGPointZero;
    CGPoint bottomleft = CGPointZero;
    CGPoint bottomright = CGPointZero;
    if (isFirstTime) {
        
        topleft = view.frame.origin;
        topright = CGPointMake(view.frame.origin.x+view.frame.size.width, view.frame.origin.y);
        bottomleft = CGPointMake(view.frame.origin.x, view.frame.origin.y+view.frame.size.height);
        bottomright = CGPointMake(view.frame.origin.x+view.frame.size.width, view.frame.origin.y+view.frame.size.height);
        
        [self.pointsDic setValue:NSStringFromCGPoint(topleft) forKey:@"topleft"];
        [self.pointsDic setValue:NSStringFromCGPoint(topright) forKey:@"topright"];
        [self.pointsDic setValue:NSStringFromCGPoint(bottomleft) forKey:@"bottomleft"];
        [self.pointsDic setValue:NSStringFromCGPoint(bottomright) forKey:@"bottomright"];
    } else {
        
        topleft = view.frame.origin;
        topright = CGPointApplyAffineTransform(CGPointFromString([self.pointsDic valueForKey:@"topright"]), trans);
        bottomleft = CGPointApplyAffineTransform(CGPointFromString([self.pointsDic valueForKey:@"bottomleft"]), trans);
        bottomright = CGPointApplyAffineTransform(CGPointFromString([self.pointsDic valueForKey:@"bottomright"]), trans);
        
        [self.pointsDic setValue:NSStringFromCGPoint(topleft) forKey:@"topleft"];
        [self.pointsDic setValue:NSStringFromCGPoint(topright) forKey:@"topright"];
        [self.pointsDic setValue:NSStringFromCGPoint(bottomleft) forKey:@"bottomleft"];
        [self.pointsDic setValue:NSStringFromCGPoint(bottomright) forKey:@"bottomright"];
    }
    
    
    if (topleft.x < 10) {
        topleft.x = 11;
        self.smallView.frame = CGRectMake(topleft.x, topleft.y, view.bounds.size.width, view.bounds.size.height);
        return ;
    }
    
    if (topleft.y < 10+64) {
        topleft.y = 11+64;
        self.smallView.frame = CGRectMake(topleft.x, topleft.y, view.bounds.size.width, view.bounds.size.height);
        return ;
    }
    
    if (topright.x > [view superview].bounds.size.width-10) {
        topright.x = [view superview].bounds.size.width-10;
        self.smallView.frame = CGRectMake(topright.x, topright.y, view.bounds.size.width, view.bounds.size.height);
        return ;
    }
    
    if (topright.y < 10) {
        topright.y = 10;
        self.smallView.frame = CGRectMake(topright.x, topright.y, view.bounds.size.width, view.bounds.size.height);
        return ;
    }
    
    if (bottomleft.x < 10) {
        bottomleft.x = 10;
        self.smallView.frame = CGRectMake(bottomleft.x, bottomleft.y, view.bounds.size.width, view.bounds.size.height);
        return ;
    }
    
    if (bottomleft.y > [view superview].bounds.size.height-10) {
        self.smallView.frame = CGRectMake(bottomleft.x, bottomleft.y, view.bounds.size.width, view.bounds.size.height);
        bottomleft.y = [view superview].bounds.size.height-10;
        return ;
    }
    
    if (bottomright.x > [view superview].bounds.size.width-10) {
        self.smallView.frame = CGRectMake(bottomright.x, bottomright.y, view.bounds.size.width, view.bounds.size.height);
        bottomright.x = [view superview].bounds.size.width-10;
        return ;
    }
    
    if (bottomright.y > [view superview].bounds.size.height-10) {
        self.smallView.frame = CGRectMake(bottomright.x, bottomright.y, view.bounds.size.width, view.bounds.size.height);
        bottomright.y = [view superview].bounds.size.height-10;
        return ;
    }
}



#pragma mark - getter & setter

@end
