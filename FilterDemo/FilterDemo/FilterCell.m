//
//  FilterCell.m
//  FilterDemo
//
//  Created by iosdevlope on 2017/7/7.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "FilterCell.h"

@interface FilterCell ()

@end

@implementation FilterCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configCell];
    }
    return self;
}

- (void)configCell {
    [self addSubview:self.imgView];
}

#pragma mark - getter & setter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
    }
    return _imgView;
}
@end
