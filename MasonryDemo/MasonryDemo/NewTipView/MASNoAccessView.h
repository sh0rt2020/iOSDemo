//
//  MASNoAccessView.h
//  NoAccessDemo
//
//  Created by Yige on 2016/10/27.
//  Copyright © 2016年 Yige. All rights reserved.
//


//用Masonry来实现页面布局
#import <UIKit/UIKit.h>

@protocol MASNoAccessViewDelagate <NSObject>
- (void)newNoAccessViewWillDisappear;
@end

@interface MASNoAccessView : UIView

//two subtitles
@property (nonatomic, copy) NSString *subTitleOne;
@property (nonatomic, copy) NSString *subTitleTwo;

@property (nonatomic, weak) id<MASNoAccessViewDelagate> delegate;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)hiddenFromView:(UIView *)view animated:(BOOL)animated;

-(id)initWithSubTitleOne:(NSString *)subTitleOne subTitleTwo:(NSString *)subTitleTwo;

@end
