//
//  TipView.h
//  YeWen
//
//  Created by Luye on 16/7/30.
//  Copyright © 2016年 YiGeMed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoAccessDelegate <NSObject>

- (void)hidenNoaccess;

@end

@interface NoAccess : UIView

- (void)show;

- (void)hide;
@property(nonatomic,weak)id<NoAccessDelegate>delegate;

@end