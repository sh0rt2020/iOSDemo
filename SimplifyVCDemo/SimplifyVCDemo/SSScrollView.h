//
//  SSScrollView.h
//  SpiderSubscriber
//
//  Created by sunwell on 15/9/9.
//  Copyright (c) 2015年 spider. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSScrollViewDelegate <NSObject>

- (void)refreshTableWithTitleIndex:(NSInteger)titleIndex;

@end

@interface SSScrollView : UIScrollView

@property (nonatomic) BOOL isTipViewShow;
@property (nonatomic) NSString *titleColor;  //标题颜色
@property (nonatomic, copy) NSString *ssTitleIndex; //标题索引
@property (nonatomic, weak) id<SSScrollViewDelegate> ssDelegate;
@property (nonatomic) NSArray *titleArr;

- (void)configData:(NSArray *)titleArr;
- (void)setTitleArr:(NSArray *)titleArr;
@end
