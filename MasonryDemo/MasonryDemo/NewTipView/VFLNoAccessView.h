//
//  VFLNoAccessView.h
//  NoAccessDemo
//
//  Created by Yige on 2016/10/27.
//  Copyright © 2016年 Yige. All rights reserved.
//


//用VFL来实现页面布局
#import <UIKit/UIKit.h>

@protocol VFLNoAccessViewDelagate <NSObject>

- (void)newNoAccessViewWillDisappear;
@end

@interface VFLNoAccessView : UIView


@property (nonatomic) UIImageView *imgView;
@property (nonatomic) UILabel *titleLab;
@property (nonatomic) UILabel *subTitleOneLab;
@property (nonatomic) UILabel *subTitleTwoLab;
@property (nonatomic) UIButton *okBtn;

//two subtitles
@property (nonatomic, copy) NSString *subTitleOne;
@property (nonatomic, copy) NSString *subTitleTwo;

@property (nonatomic, weak) id<VFLNoAccessViewDelagate> delegate;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)hiddenFromView:(UIView *)view animated:(BOOL)animated;

-(id)initWithSubTitleOne:(NSString *)subTitleOne subTitleTwo:(NSString *)subTitleTwo;

@end
