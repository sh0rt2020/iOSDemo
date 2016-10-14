//
//  SSScrollView.m
//  SpiderSubscriber
//
//  Created by sunwell on 15/9/9.
//  Copyright (c) 2015年 spider. All rights reserved.
//

#define SSTITLEBTNW 75.0 //单个标题的宽度

#import "SSScrollView.h"
#import "SSToolsClass.h"

@interface SSScrollView() {
    UIView *tipView;
    NSInteger btnIndex;
    CGFloat btnWidth;
}

@end

@implementation SSScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        return self;
    }
    return nil;
}

//配置数据
- (void)configData:(NSArray *)titleArr {
    
    if (self.subviews&&self.subviews.count > 0) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    
    if (SSTITLEBTNW*titleArr.count < ScreenWidth)
        btnWidth = ScreenWidth/titleArr.count;
    else
        btnWidth = SSTITLEBTNW;
    
    self.contentSize = CGSizeMake(btnWidth*titleArr.count, self.frame.size.height);
    
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, self.frame.size.height-2)];
        NSString *title;
        if ([titleArr[i] isKindOfClass:[SSCategoryInfo class]]) {
            title = [(SSCategoryInfo *)titleArr[i] ssName];
        } else {
            title = titleArr[i];
        }
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        if (i == [self.ssTitleIndex integerValue]) {
            [btn setTitleColor:[SSToolsClass hexColor:self.titleColor] forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:[SSToolsClass hexColor:@"606060"] forState:UIControlStateNormal];
        }
        btnIndex = [self.ssTitleIndex integerValue]+100;
        [btn addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.tag = 100+i;
    }
    
    //原生属性配置
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    //提示
    if (self.isTipViewShow) {
        tipView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, btnWidth, 2)];
        tipView.backgroundColor = [SSToolsClass hexColor:self.titleColor];
        [self addSubview:tipView];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}


#pragma mark - event response
- (void)clickTitle:(UIButton *)sender {
    
    //判断点击的title是不是完全显示
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
        [sender setTitleColor:[SSToolsClass hexColor:self.titleColor] forState:UIControlStateNormal];
        if (sender.tag != btnIndex) {
            UIButton *btn = [self viewWithTag:btnIndex];
            [btn setTitleColor:[SSToolsClass hexColor:@"606060"] forState:UIControlStateNormal];
        }
    } else {
        sender.tintColor = [SSToolsClass hexColor:self.titleColor];
        if (sender.tag != btnIndex) {
            UIButton *btn = [self viewWithTag:btnIndex];
            btn.tintColor = [SSToolsClass hexColor:@"606060"];
        }
    }
    
    
    
    sender.selected = YES;
    CGRect rect = sender.frame;
    NSInteger tag = sender.tag - 100;
    if (tag < 4) {
        if (tag == 0) {
            rect = sender.frame;
        } else {
            rect.size = CGSizeMake(-75, rect.size.height);
        }
    } else {
        rect.size = CGSizeMake(rect.size.width+75, rect.size.height);
    }
    [self scrollRectToVisible:rect animated:YES];

    //动画
    CGRect tmpRect = sender.frame;
    if (self.isTipViewShow) {
        [UIView animateWithDuration:0.3 animations:^{
            tipView.frame = CGRectMake(tmpRect.origin.x, self.frame.size.height-2, btnWidth , 2);
        }];
    }
    if ([self.ssDelegate respondsToSelector:@selector(refreshTableWithTitleIndex:)]) {
        [self.ssDelegate refreshTableWithTitleIndex:sender.tag - 100];
    }
    btnIndex = sender.tag;
}

#pragma mark - setter&&getter
- (void)setSsTitleIndex:(NSString *)ssTitleIndex {
    if (ssTitleIndex) {
        _ssTitleIndex = ssTitleIndex;
        
        UIButton *btn = [self viewWithTag:[ssTitleIndex integerValue]+100];
        [self clickTitle:btn];
    }
}


- (void)setTitleArr:(NSArray *)titleArr {
    if (titleArr) {
        _titleArr = titleArr;
        
        for (int i=0; i<titleArr.count; i++) {
            UIButton *btn = [self viewWithTag:100+i];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        }
    }
}

@end
