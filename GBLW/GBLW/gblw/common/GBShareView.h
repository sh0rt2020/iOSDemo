//
//  GBShareView.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/19.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GBShareTypeWX = 1,
    GBShareTypePYQ,
    GBShareTypeQQ,
    GbShareTypeKJ,
} GBShareType;

typedef void(^ButtonBlock)(NSInteger sender);

@interface GBShareView : UIView

@property (nonatomic, copy) ButtonBlock buttonBlcok;

- (void)shareViewButtonSeleted:(ButtonBlock)block;

- (void)removeSelfFromSuperview;

@end
