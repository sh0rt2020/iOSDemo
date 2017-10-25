//
//  GBHttpManager.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/12.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^RequestSuccess)(id response);
typedef void(^RequestFailed)(id task, id error);

typedef enum : NSUInteger {
    HttpMethodTypeGet,
    HttpMethodTypePost,
} HttpMethodType;


@interface GBHttpManager : AFHTTPSessionManager

+ (instancetype)sharedHttpManager;


/**
 get请求
 @param server 接口地址
 @param params 接口参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getRequest:(NSString *)server
            params:(NSDictionary *)params
           success:(RequestSuccess)success
           failure:(RequestFailed)failure;


/**
 post请求
 @param server 接口地址
 @param params 接口参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)postReuqest:(NSString *)server
             params:(NSDictionary *)params
            success:(RequestSuccess)success
            failure:(RequestFailed)failure;
@end
