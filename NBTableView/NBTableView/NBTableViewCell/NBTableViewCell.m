//
//  NBTableViewCell.m
//  NBTableView
//
//  Created by sunwell on 2016/10/27.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "NBTableViewCell.h"

@interface NBTableViewCell () <UIGestureRecognizerDelegate> {
    UIPanGestureRecognizer *panGestureRecognizer;
    CGPoint startPoint;
}

DEFINE_PROPERTY_STRONG(CAGradientLayer *, gradientLayer);

@end

@implementation NBTableViewCell
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.actionsView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.selectedBackgroundView];
        [self.contentView addSubview:self.textLabel];
        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        
        INIT_SUBVIEW_SELF(NBSeparationLine, self.topSeparationLine);
        INIT_SUBVIEW_SELF(NBSeparationLine, self.bottomSeparationLine);
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
    self.actionsView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    
    self.textLabel.frame = CGRectMake(0, 0, 50, self.bounds.size.height);
    
    if (self.isSelected) {
        self.selectedBackgroundView.frame = self.contentView.bounds;
        self.selectedBackgroundView.hidden = NO;
    } else {
        self.selectedBackgroundView.hidden = YES;
    }
    
    [self bringSubviewToFront:self.topSeparationLine];
    [self bringSubviewToFront:self.bottomSeparationLine];
    
    LAYOUT_SUBVIEW_TOP_FILL_WIDTH(_topSeparationLine, 0, 0, 1);
    LAYOUT_SUBVIEW_BOTTOM_FILL_WIDTH(_bottomSeparationLine, 0, 0, 1);
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
    //获取到startColor中的white 和 alpha的值
    if ([startColor getWhite:&white alpha:&alpha]) {
        NSLog(@"white=%f  alpha=%f", white, alpha);
    }
    
    self.gradientLayer.colors = @[(id)startColor.CGColor, (id)end.CGColor];
    self.topSeparationLine.lineColor = startColor;
    self.bottomSeparationLine.lineColor = end;
}

#pragma mark - private method
- (void)prepareForReused {
    self.index = NSNotFound;
    [self setIsSelected:NO];
}

#pragma mark - getter&setter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        [self setNeedsLayout];
    }
    return _contentView;
}

- (UIView *)selectedBackgroundView {
    if (!_selectedBackgroundView) {
        _selectedBackgroundView = [UIView new];
        _selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    }
    return _selectedBackgroundView;
}

- (NBCellActionsView *)actionsView {
    if (!_actionsView) {
        _actionsView = [NBCellActionsView new];
    }
    return _actionsView;
}


- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        [self setNeedsLayout];
    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
    }
    return _textLabel;
}
@end
