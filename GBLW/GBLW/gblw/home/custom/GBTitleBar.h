//
//  GBTitleBar.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/17.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBTitleBarDelegate <NSObject>
@required
- (void)titleBarDidSelected:(NSInteger)index;
@end

@interface GBTitleBar : UIView

@property (nonatomic, weak) id<GBTitleBarDelegate> delegate;
- (id)initWithTitles:(NSArray *)titles;
@end
