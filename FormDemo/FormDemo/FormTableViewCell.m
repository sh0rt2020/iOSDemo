//
//  FormTableViewCell.m
//  FormDemo
//
//  Created by Yige on 2016/12/8.
//  Copyright © 2016年 Yige. All rights reserved.
//


#import "FormTableViewCell.h"

@interface FormTableViewCell ()


@end

@implementation FormTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - private method
- (void)configFormViewWithArr:(NSArray *)dataArr {
    
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (dataArr && dataArr.count > 0) {
        for (int i = 0; i < dataArr.count; i++) {
            originX = 0;
            originY += height;
            
            height = [self.heightArr[i] floatValue];
            NSArray *cellArr = dataArr[i];
            
            UIColor *bgColor = [UIColor whiteColor];
            UIColor *textColor = [UIColor redColor];
            UIFont *textFont = [UIFont systemFontOfSize:14.0];
//            if (i == 0) {
//                //表头
//                bgColor = [UIColor lightGrayColor];
//                textColor = [UIColor greenColor];
//                textFont = [UIFont boldSystemFontOfSize:14.0];
//            }
            
            
            for (int j = 0; j < cellArr.count; j++) {
                id item = cellArr[j];
                if (j != 0) {
                    originX += width;
                }
                width = [self.widthArr[j] floatValue];
                if ([item isKindOfClass:[NSString class]]) {
                    //字符串元素 直接显示出来
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
                    lab.backgroundColor = bgColor;
                    lab.font = textFont;
                    lab.textColor = textColor;
                    lab.textAlignment = NSTextAlignmentCenter;
                    lab.text = item;
                    lab.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    lab.layer.borderWidth = 0.5;
                    lab.numberOfLines = 2;
                    [self.contentView addSubview:lab];
                } else if ([item isKindOfClass:[NSDictionary class]]) {
                    //字典元素 表头value之间用“——”分割  内容value之间用“|”分割
                    
                    if (i == 0) {
                        //表头数据
                        if([cellArr lastObject] == item&&cellArr.count < _widthArr.count) {
                            for (int k=j+1; k < _widthArr.count; k++) {
                                width += [self.widthArr[k] floatValue];
                            }
                        }
                        
                        NSString *title = [[item allKeys] firstObject];
                        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, width, height/2)];
                        titleLab.backgroundColor = bgColor;
                        titleLab.textColor = textColor;
                        titleLab.font = textFont;
                        titleLab.textAlignment = NSTextAlignmentCenter;
                        titleLab.text = title;
                        titleLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
                        titleLab.layer.borderWidth = 0.5;
                        titleLab.numberOfLines = 2;
                        [self.contentView addSubview:titleLab];
                        
                        NSArray *allValues = [[item allValues] firstObject];
                        width = width/allValues.count;
                        for (int k = 0; k < allValues.count; k++) {
//                            textFont = [UIFont systemFontOfSize:12.0];
//                            textColor = [UIColor orangeColor];
                            
                            if (k != 0) {
                                originX += width;
                            }
                            UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(originX, height/2, width, height/2)];
                            valueLab.backgroundColor = bgColor;
                            valueLab.textColor = textColor;
                            valueLab.font = textFont;
                            valueLab.textAlignment = NSTextAlignmentCenter;
                            valueLab.text = allValues[k];
                            valueLab.numberOfLines = 2;
                            valueLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
                            valueLab.layer.borderWidth = 0.5;
                            [self.contentView addSubview:valueLab];
                        }
                    } else {
                        //表内容数据
                        NSString *title = [[item allKeys] firstObject];
                        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, width/2, height)];
                        titleLab.backgroundColor = bgColor;
                        titleLab.textColor = textColor;
                        titleLab.font = textFont;
                        titleLab.textAlignment = NSTextAlignmentCenter;
                        titleLab.text = title;
                        titleLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
                        titleLab.layer.borderWidth = 0.5;
                        titleLab.numberOfLines = 2;
                        [self.contentView addSubview:titleLab];
                        
                        NSArray *allValues = [[item allValues] firstObject];
                        for (int k = 0; k < allValues.count; k++) {
                            CGFloat originYY = originY;
                            originYY += height/allValues.count*k;
                            UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(originX+width/2, originYY, width/2, height/allValues.count)];
                            valueLab.backgroundColor = bgColor;
                            valueLab.textColor = textColor;
                            valueLab.font = textFont;
                            valueLab.textAlignment = NSTextAlignmentCenter;
                            valueLab.text = allValues[k];
                            valueLab.numberOfLines = 2;
                            valueLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
                            valueLab.layer.borderWidth = 0.5;
                            [self.contentView addSubview:valueLab];
                        }
                    }
                } else if ([item isKindOfClass:[NSArray class]]) {
                    //数组元素 元素之间用“————”分割
                    for (int k = 0; k < ((NSArray *)item).count; k++) {
                        CGFloat originYY = originY;
                        if (k != 0) {
                            originYY += height/((NSArray *)item).count;
                        }
                        
                        id meta = ((NSArray *)item)[k];
                        if ([meta isKindOfClass:[NSString class]]) {
                            //字符串
                            UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(originX, originYY, width, height/((NSArray *)item).count)];
                            contentLab.backgroundColor = bgColor;
                            contentLab.textColor = textColor;
                            contentLab.font = textFont;
                            contentLab.textAlignment = NSTextAlignmentCenter;
                            contentLab.text = meta;
                            contentLab.numberOfLines = 2;
                            contentLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
                            contentLab.layer.borderWidth = 0.5;
                            [self.contentView addSubview:contentLab];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - setter & getter
- (void)setContentArr:(NSArray *)contentArr {
    if (_contentArr != contentArr) {
        _contentArr = contentArr;
        [self configFormViewWithArr:_contentArr];
    }
}

@end
