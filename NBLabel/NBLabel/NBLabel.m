//
//  NBLabel.m
//  NBLabel
//
//  Created by sunwell on 2016/11/20.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "NBLabel.h"

@interface NBLabel ()
@property (nonatomic) UILabel *labOne;  //第一行标题
@end

@implementation NBLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)dealWithTitle:(NSString *)text {
    
    BOOL withLineBreak = NO;
    
    NSInteger lineNum = self.lines;
    CGFloat height = self.frame.size.height / lineNum;
    CGRect newFrame = self.bounds;
    NSArray *titleArr = [NSArray array];
    NSString *title = @"";
    
    
    if (text&&text.length > 0) {
        title = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        if ([title containsString:@"\n"]) {
            withLineBreak = YES;
            
            titleArr = [title componentsSeparatedByString:@"\n"];
            title = [NSString string];
            for (NSString *str in titleArr) {
                title = [title stringByAppendingString:str];
            }
        }
        
        NSString *lineOne;
        NSString *lineTwo;
        if (titleArr&&titleArr.count > 0) {
            lineOne = titleArr[0];
            lineTwo = titleArr[1];
        }
        
        UIFont *firFont = nil;
        if (lineOne.length <= self.maxNum) {
            for (int i = 0; i < self.lines; i++) {
                newFrame.size.height = height;
                newFrame.origin.y = height*i;
                
                if (i == 0) {
                    self.labOne = [[UILabel alloc] initWithFrame:newFrame];
                    self.labOne.numberOfLines = 2;
                    self.labOne.lineBreakMode = NSLineBreakByWordWrapping;
                    self.labOne.text = titleArr[i];
                    self.labOne.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
                    self.labOne.adjustsFontSizeToFitWidth = YES;
                    self.labOne.textAlignment = NSTextAlignmentCenter;
                    self.translatesAutoresizingMaskIntoConstraints = NO;
                    [self addSubview:self.labOne];
                } else {
                    UILabel *lab = [[UILabel alloc] initWithFrame:newFrame];
                    lab.numberOfLines = 1;
                    lab.text = titleArr[i];
                    lab.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
                    lab.textAlignment = NSTextAlignmentCenter;
                    [self addSubview:lab];
                }
            }
        } else {
            UILabel *lab = [[UILabel alloc] initWithFrame:self.bounds];
            lab.text = text;
            lab.font = [UIFont systemFontOfSize:22];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.lineBreakMode = NSLineBreakByWordWrapping;
            lab.numberOfLines = self.lines;
            [self addSubview:lab];
        }
    }
}

#pragma mark - getter&setter
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        [self dealWithTitle:_title];
    }
}

@end
