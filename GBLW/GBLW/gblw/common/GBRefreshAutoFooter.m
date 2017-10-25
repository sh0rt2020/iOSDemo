//
//  GBRefreshAutoFooter.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/23.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBRefreshAutoFooter.h"

@implementation GBRefreshAutoFooter

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.stateLabel setTextColor:ColorHex(@"acacac")];
        [self setTitle:@"我们是有底线的o(｀ω´ )o" forState:MJRefreshStateNoMoreData];
    }
    return self;
}

@end
