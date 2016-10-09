//
//  KTTimeModel.h
//  RedPackageTest
//
//  Created by CoolKi on 16/9/9.
//  Copyright © 2016年 CoolKi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTTimeModel : NSObject

@property (nonatomic,assign) NSInteger year;
@property (nonatomic,assign) NSInteger month;
@property (nonatomic,assign) NSInteger day;
@property (nonatomic,assign) NSInteger hour;
@property (nonatomic,assign) NSInteger minute;
@property (nonatomic,assign) NSInteger second;
@property (nonatomic,copy) NSString * status;

+ (KTTimeModel *)timeModelWithTimeString:(NSString *)timeString;

@end
