//
//  GSAnimateView.m
//  CoreAnimationDemo
//
//  Created by iosdevlope on 2017/6/7.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "GSAnimateView.h"
#import "GS_RotationGuestreRecognizer.h"


@interface GSAnimateView ()
@property (nonatomic, strong) UIButton *delButton;
@property (nonatomic, strong) UIButton *scaleButton;
@property (nonatomic, strong) UIButton *rotaButton;

@property (nonatomic, assign) BOOL isRotateZoom;
@end

@implementation GSAnimateView
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.delButton];
        [self addSubview:self.scaleButton];
        [self addSubview:self.rotaButton];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGesture];
        
        GS_RotationGuestreRecognizer *scaleGesture = [[GS_RotationGuestreRecognizer alloc] initWithTarget:self action:@selector(xsHandle:)];
        scaleGesture.effectView = self;
        scaleGesture.isZoom = YES;
        [self.scaleButton addGestureRecognizer:scaleGesture];
        
        
        GS_RotationGuestreRecognizer *rotateGesture = [[GS_RotationGuestreRecognizer alloc] initWithTarget:self action:@selector(xsHandle:)];
        rotateGesture.effectView = self;
        rotateGesture.isZoom = NO;
        [self.rotaButton addGestureRecognizer:rotateGesture];
        
        return self;
    }
    return nil;
}

#pragma mark - overide
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    
    CGPoint rotateP = [self convertPoint:point toView:self.rotaButton];
    CGPoint scaleP = [self convertPoint:point toView:self.scaleButton];
    
    if ([self.rotaButton pointInside:rotateP withEvent:event]) {
        _isRotateZoom = YES;
        return self.rotaButton;
    } else {
        _isRotateZoom = false;
    }
    
    if ([self.scaleButton pointInside:scaleP withEvent:event]) {
        _isRotateZoom = YES;
        return self.scaleButton;
    } else {
        _isRotateZoom = false;
    }
    
    CGPoint deleteP = [self convertPoint:point toView:self.delButton];
    if ([self.delButton pointInside:deleteP withEvent:event]) {
        return self.delButton;
    }
    
    return [super hitTest:point withEvent:event];
}

#pragma mark - handle gesture
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        CGPoint touch = [pan translationInView:self];
        
        self.transform = CGAffineTransformTranslate(self.transform, touch.x, touch.y);
        [pan setTranslation:CGPointZero inView:self];
    }
}

-(void)xsHandle:(GS_RotationGuestreRecognizer *)recognizer {
    
    
    if (_isRotateZoom) {
        recognizer.effectView.transform = CGAffineTransformRotate(recognizer.effectView.transform, recognizer.rotation);
        recognizer.rotation = 0;
        //设置缩放为yes后可以缩放这个视图
        if (recognizer.isZoom) {
            recognizer.effectView.transform = CGAffineTransformScale(recognizer.effectView.transform, recognizer.scale, recognizer.scale);
        }
    }
}

#pragma mark - event response
- (void)handleDelAction:(UIButton *)sender {
    
}

#pragma mark - getter & setter
- (UIButton *)delButton {
    if (!_delButton) {
        _delButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, -10, 20, 20)];
        [_delButton setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [_delButton addTarget:self action:@selector(handleDelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delButton;
}

- (UIButton *)scaleButton {
    if (!_scaleButton) {
        _scaleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-10, -10, 20, 20)];
        [_scaleButton setImage:[UIImage imageNamed:@"scale"] forState:UIControlStateNormal];
    }
    return _scaleButton;
}

- (UIButton *)rotaButton {
    if (!_rotaButton) {
        _rotaButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-10, self.bounds.size.height-10, 20, 20)];
        [_rotaButton setImage:[UIImage imageNamed:@"edit_rotateZoom"] forState:UIControlStateNormal];
    }
    return _rotaButton;
}
@end
