//
//  NBTableViewCell.m
//  NBTableView
//
//  Created by sunwell on 2016/10/27.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "NBTableViewCell.h"
#import "NBCellActionsView.h"

@interface NBTableViewCell () <UIGestureRecognizerDelegate> {
    UIPanGestureRecognizer *panGestureRecognizer;
    CGPoint startPoint;
}

DEFINE_PROPERTY_STRONG(CAGradientLayer *, gradientLayer);
DEFINE_PROPERTY_STRONG(UIView *, contentView);
DEFINE_PROPERTY_STRONG(UIView *, selectedBackgroundView);
DEFINE_PROPERTY_STRONG(NBCellActionsView *, actionsView);
DEFINE_PROPERTY_ASSIGN(NSInteger, index);
DEFINE_PROPERTY_STRONG(NSString *, identifiy);

@end

@implementation NBTableViewCell
#pragma mark - life cycle
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
        
        NBCellActionsView *actionView = [[NBCellActionsView alloc] init];
        [self setActionsView:actionView];
        
//        INIT_SUBVIEW_SELF(<#class#>, <#name#>)
    }
    return self;
}

//根据标识符来初始化cell
- (instancetype)initWithIdentifiy:(NSString *)identifiy {
    self = [super init];
    if (self) {
        self.identifiy = identifiy;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.actionsView.frame = self.bounds;
    if (self.isSelected) {
        self.selectedBackgroundView.frame = self.contentView.bounds;
        self.selectedBackgroundView.hidden = NO;
        [self.contentView insertSubview:self.selectedBackgroundView atIndex:0];
    } else {
        self.selectedBackgroundView.hidden = YES;
    }
    
//    self
    self.gradientLayer.frame = self.contentView.bounds;
    [self.contentView.layer insertSublayer:self.gradientLayer atIndex:0];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return YES;
}

#pragma mark - 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setIsSelected:YES];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
//    [self ]
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setIsSelected:NO];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setIsSelected:NO];
}

#pragma mark - event response
- (void) handlePanGestureRecognizer:(UIPanGestureRecognizer*)prcg {
    //响应手势的时候  自身的位置没有变化吗？？？
    if ([(UIScrollView *)self.superview isDragging]) {
        return ;
    }
    
    CGPoint point = [prcg locationInView:self];
    if (prcg.state == UIGestureRecognizerStateBegan) {
        startPoint = point;
    } else if (prcg.state == UIGestureRecognizerStateChanged) {
        //位置在变化 把变化的位置给到
        float offset = point.x - startPoint.x;
        self.contentView.frame = CGRectOffset(self.bounds, offset, 0);
        [self.actionsView setEnableItemWithMaskOffSet:offset];
    } else if (prcg.state == UIGestureRecognizerStateCancelled) {
        self.contentView.frame = self.bounds;
    } else if (prcg.state == UIGestureRecognizerStateEnded) {
        //在手势结束的时候将事件传递给下层进行处理???
        if (self.actionsView.abledItem) {
            [self.actionsView.abledItem sendActionsForControlEvents:UIControlEventAllEvents];
        }
        self.contentView.frame = self.bounds;
    }
}

- (void)showGradientStart:(UIColor *)startColor endColor:(UIColor *)end {
    CGFloat white;
    CGFloat alpha;
    if ([startColor getWhite:&white alpha:&alpha]) {
        NSLog(@"");
    }
    
    self.gradientLayer.colors = @[(id)startColor.CGColor, (id)end.CGColor];
}

#pragma mark - private method
- (void)prepareForReused {
    self.index = NSNotFound;
    [self setIsSelected:NO];
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

- (void)setActionsView:(NBCellActionsView *)actionsView {
    if (_actionsView != actionsView) {
        [_actionsView removeFromSuperview];
        _actionsView = actionsView;
        [self insertSubview:actionsView atIndex:0];
        [self setNeedsLayout];
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        [self setNeedsLayout];
    }
}
@end
