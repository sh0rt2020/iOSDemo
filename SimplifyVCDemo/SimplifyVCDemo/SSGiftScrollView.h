//
//  SSGiftScrollView.h
//  SpiderSubscriber
//
//  Created by Czh on 15/9/7.
//  Copyright (c) 2015年 spider. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSGiftScrollViewDelegate <NSObject>

- (void)giftScrollViewDidTapped;

@end

/**
 *  礼品数组的滑动视图
 */
@interface SSGiftScrollView : UIScrollView

@property (nonatomic, weak) id<SSGiftScrollViewDelegate>  giftScrollViewDelegate;
@property (nonatomic, strong) NSArray *ssGiftArr;       //礼品数组

- (void)setSsGiftArr:(NSArray *)ssGiftArr;  //系统set方法

@end
