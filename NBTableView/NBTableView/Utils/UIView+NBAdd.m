//
//  UIView+NBAdd.m
//  NBTableView
//
//  Created by sunwell on 2016/11/13.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "UIView+NBAdd.h"

@implementation UIView (NBAdd)

- (void)addTapTarget:(id)target selector:(SEL)selecotr {
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selecotr];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
}
@end
