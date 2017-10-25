//
//  GBGroupInfo.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/12.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBGroupInfo.h"

@implementation GBGroupInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"topicId":@"id",
             @"desc":@"desc",
             @"title":@"title",
             @"headPortrait":@"headPortrait",
             @"ownerId":@"ownerId",
             @"createdTime":@"createdTime",
             @"beFollowed":@"beFollowed",
             @"feedCount":@"feedCount",
             @"followCount":@"followCount",
             };
}
@end
