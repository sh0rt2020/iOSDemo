//
//  SSInterFace.m
//  SpiderSubscriber
//
//  Created by royal on 14/11/27.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import "SSInterFace.h"
//#import "SSDataParse.h"
#import "SSUrlAPI.h"
#import <Mantle/Mantle.h>

static SSInterFace *requestInterFace;

@implementation SSInterFace
+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestInterFace = [super allocWithZone:zone];
    });
    return requestInterFace;
}

+ (instancetype)shareInterFace {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestInterFace = [[SSInterFace alloc] init];
    });
    return requestInterFace;
}

- (id)copyWithZone:(NSZone *)zone {
    return requestInterFace;
}

#pragma mark - 订阅有礼列表
- (void)getSubscribeGiftListInfo_interface:(NSString *)urlStr
                                   success:(SSDataPackageSuccess)success
                                   failure:(SSDataPackageFailure)failure {
    [self requestURLWithGET:urlStr cacheStrategy:NETWORK_CACHE_TYPE_SYSTEM success:^(id responseData) {

        NSError *err = nil;
        NSArray *result = [MTLJSONAdapter modelsOfClass:SSGiftPaperInfo.class fromJSONArray:responseData[@"papers"] error:&err];
        if (result) {
            success(result);
        }
    } failure:^(id errorData) {
        failure(errorData);
    }];
}


#pragma mark - 获取订阅有礼分类数据
- (void)getGiftCate_interface:(NSString *)urlString
                      success:(SSDataPackageSuccess)success
                      failure:(SSDataPackageFailure)failure {
    [self requestURLWithGET:urlString cacheStrategy:NETWORK_CACHE_TYPE_NONE success:^(id responseData) {
        
        NSError *err = nil;
        NSArray *result = [MTLJSONAdapter modelsOfClass:SSCategoryInfo.class fromJSONArray:responseData[@"itemList"] error:&err];
        if (!err) {
            success(result);
        }
    } failure:^(id errorData) {
        failure(errorData);
    }];
}

@end
