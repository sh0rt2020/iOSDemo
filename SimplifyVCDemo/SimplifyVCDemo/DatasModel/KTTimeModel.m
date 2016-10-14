//
//  KTTimeModel.m
//  RedPackageTest
//
//  Created by CoolKi on 16/9/9.
//  Copyright © 2016年 CoolKi. All rights reserved.
//

#import "KTTimeModel.h"

@implementation KTTimeModel


+ (KTTimeModel *)timeModelWithTimeString:(NSString *)timeString{
    KTTimeModel * timeModel = [[KTTimeModel alloc]init];
    
    if (timeString) {
        
        NSArray * timeTwoComponentArr = [timeString componentsSeparatedByString:@" "];
        NSLog(@"Two~%@",timeTwoComponentArr);
        
        NSArray * ymdArr = [timeTwoComponentArr[0] componentsSeparatedByString:@"-"];
        NSLog(@"day~%@",ymdArr);
        
        NSArray * hmsArr = [timeTwoComponentArr[1] componentsSeparatedByString:@":"];
        NSLog(@"second~%@",hmsArr);
        
        timeModel.year = [ymdArr[0] integerValue];
        timeModel.month = [ymdArr[1] integerValue];
        timeModel.day = [ymdArr[2] integerValue];
        
        timeModel.hour = [hmsArr[0] integerValue];
        timeModel.minute = [hmsArr[1] integerValue];
        timeModel.second = [hmsArr[2] integerValue];
    }
    
    return timeModel;
}

@end
