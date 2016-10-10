//
//  SSUrlAPI.h
//  SpiderSubscriber
//
//  Created by royal on 14/12/9.
//  Copyright (c) 2014年 spider. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SSInterFace.h"
#import "SSToolsClass.h"


@interface SSUrlAPI : NSObject

#pragma mark - 订阅有礼分类列表
+ (NSString *)getGiftCategory;


#pragma mark - 订阅有礼列表
/**
 *  @param itemId 分类id
 *  @param page       页码
 *  @param count      容量
 */
+ (NSString *)getGiftListURLWithItemId:(NSString *)itemId page:(int)page count:(NSString *)count;
@end
