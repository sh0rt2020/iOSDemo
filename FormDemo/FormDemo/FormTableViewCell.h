//
//  FormTableViewCell.h
//  FormDemo
//
//  Created by Yige on 2016/12/8.
//  Copyright © 2016年 Yige. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormTableViewCell : UITableViewCell

@property (nonatomic, nonnull) NSArray *contentArr; //内容数组
@property (nonatomic, nonnull) NSArray *heightArr;  //高度数组
@property (nonatomic, nonnull) NSArray *widthArr;  //宽度数组

@end
