//
//  SSDataPackage.h
//  SpiderSubscribe
//
//  Created by spider on 14/11/5.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SSDataPackageSuccess)(id responseData);
typedef void (^SSDataPackageFailure)(id errorData);

//数据缓存策略
typedef enum {
    /**
     *  默认无缓存
     */
    NETWORK_CACHE_TYPE_NONE,
    /**
     *  只要没有网络连接或者请求失败,就从缓存里查找数据,有网络就是用网络数据
     */
    NETWORK_CACHE_TYPE_SYSTEM,
    /**
     *  先看看有没有缓存数据，如果有，取缓存数据，否则取网络数据
     */
    NETWORK_CACHE_TYPE_CUSTUM,
    /**
     *  先缓存数据 再取网络数据
     */
    NETWORK_CACHE_TYPE_SYSCUS 
} NETWORK_CACHE_TYPE;

@interface SSDataPackage : NSObject
/*
 * 网络请求 GET
 * 参数 url
 */
- (void)requestURLWithGET:(NSString *)url
            cacheStrategy:(NETWORK_CACHE_TYPE)cacheStrategy
                  success:(SSDataPackageSuccess)success
                  failure:(SSDataPackageFailure)failure;

/*
 * 网络请求 GET
 * 参数 url params
 */
- (void)requestURLWithGET:(NSString *)url
                  params:(NSDictionary *)params
           cacheStrategy:(NETWORK_CACHE_TYPE)cacheStrategy
                 success:(SSDataPackageSuccess)success
                 failure:(SSDataPackageFailure)failure;

/*
 * 网络请求 POST
 * 参数 url params
 */
- (void)requestURLWithPOST:(NSString *)url
                   params:(NSDictionary *)params
            cacheStrategy:(NETWORK_CACHE_TYPE)cacheStrategy
                  success:(SSDataPackageSuccess)success
                  failure:(SSDataPackageFailure)failure;

/*
 * 上传图片 post 请求 
 * 参数 url params
 */
- (void)uploadImageWithPOST:(NSString *)url
                    params:(NSDictionary *)params
             cacheStrategy:(NETWORK_CACHE_TYPE)cacheStrategy
                   success:(SSDataPackageSuccess)success
                   failure:(SSDataPackageFailure)failure;

//停止请求
- (void)cancelHttpRequest;

@end
