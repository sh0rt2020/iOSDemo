//
//  NBLabel.m
//  NBLabel
//
//  Created by sunwell on 2016/11/20.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "NBLabel.h"

@interface NBLabel ()

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
        
        int length = (int)(lineOne.length-lineTwo.length);
        length = abs(length);
        NSString *space = @"我";
        if (lineOne.length > lineTwo.length) {
            if (lineOne.length > 15 && lineOne.length <= 17) {
                space = @"    ";
            } else if (lineOne.length == 19) {
                space = @"你";
            }
        }
        
        
        if (lineOne.length <= self.maxNum) {
            for (int i = 0; i < self.lines; i++) {
                newFrame.size.height = height;
                newFrame.origin.y = height*i;
                
                if (i == 0) {
                    CGFloat wordWidth = 0;
                    CGRect lineFrame;
                    if (lineTwo.length > lineOne.length) {
                        wordWidth = self.bounds.size.width/lineTwo.length;
                        lineFrame = CGRectMake(self.bounds.size.width/2-lineOne.length*wordWidth/2, newFrame.origin.y, lineOne.length*wordWidth, newFrame.size.height);
                    } else {
                        lineFrame = newFrame;
                    }

                    self.labOne = [[UILabel alloc] initWithFrame:lineFrame];
                    self.labOne.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
                    self.labOne.adjustsFontSizeToFitWidth = YES;
                    self.labOne.font = [UIFont systemFontOfSize:22];
                    self.labOne.textAlignment = NSTextAlignmentCenter;
                    self.labOne.text = titleArr[i];
                    [self addSubview:self.labOne];
                } else {
                    CGFloat wordWidth = 0;
                    CGRect lineFrame;
                    if (lineTwo.length < lineOne.length) {
                        wordWidth = self.bounds.size.width/lineOne.length;
                        lineFrame = CGRectMake(self.bounds.size.width/2-lineTwo.length*wordWidth/2, newFrame.origin.y, lineTwo.length*wordWidth, newFrame.size.height);
                    } else {
                        lineFrame = newFrame;
                    }
                    
                    UILabel *lab = [[UILabel alloc] initWithFrame:lineFrame];
                    lab.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
                    lab.font = [UIFont systemFontOfSize:22];
                    lab.adjustsFontSizeToFitWidth = YES;
                    lab.textAlignment = NSTextAlignmentCenter;
                    lab.text = titleArr[i];
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

- (void)setLabOne:(UILabel *)labOne {
    if (_labOne != labOne) {
        _labOne = labOne;
    }
}

@end
