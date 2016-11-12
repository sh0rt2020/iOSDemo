//
//  NBTableViewCell.m
//  NBTableView
//
//  Created by sunwell on 2016/10/27.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "NBTableViewCell.h"
#import "NBGlobalDefines.h"

@interface NBTableViewCell () <UIGestureRecognizerDelegate> {
    UIPanGestureRecognizer *panGestureRecognizer;
    CGPoint startPoint;
}

DEFINE_PROPERTY_STRONG(CAGradientLayer *, gradientLayer);
DEFINE_PROPERTY_STRONG(UIView *, contentView);
DEFINE_PROPERTY_STRONG(UIView *, selectedBackgroundView);

@end

@implementation NBTableViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.gradientLayer = [CAGradientLayer layer];
        [self.layer addSublayer:self.gradientLayer];
        
        UIView *contentV = [UIView new];
        contentV.backgroundColor = [UIColor clearColor];
        [self setContentView:contentV];
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor lightGrayColor];
        [self setSelectedBackgroundView:bgView];
        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        
        
    }
    return self;
}

#pragma mark - event response
- (void) handlePanGestureRecognizer:(UIPanGestureRecognizer*)prcg {
    
}


#pragma mark - getter&setter
- (void)setContentView:(UIView *)contentView {
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        INIT_SUBVIEW_SELF(UIView, contentView);
        [self setNeedsLayout];
    }
}

- (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView {
    if (_selectedBackgroundView != selectedBackgroundView) {
        [_selectedBackgroundView removeFromSuperview];
        _selectedBackgroundView = selectedBackgroundView;
        INIT_SUBVIEW_SELF(UIView, selectedBackgroundView);
        [self setNeedsLayout];
    }
}
@end
