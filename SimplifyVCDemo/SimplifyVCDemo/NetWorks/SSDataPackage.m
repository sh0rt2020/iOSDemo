//
//  SSDataPackage.m
//  SpiderSubscribe
//
//  Created by spider on 14/11/5.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import "SSDataPackage.h"
//#import "ASIFormDataRequest.h"
//#import "Reachability.h"
#import "SSDatasInfo.h"
#import "AFNetworking.h"
#import "SSCache.h"
#import <CommonCrypto/CommonDigest.h>

//#define DATA(X) [X dataUsingEncoding:NSUTF8StringEncoding]

#define NER_ERROR @"蜘蛛君偷懒了，稍后试试吧"

static NSString const *jsonError = @"蜘蛛君偷懒了，稍后试试吧";

@implementation SSDataPackage

- (NSString *)md5l:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (id)init{

    self = [super init];
    if (self) {
        
    }
    return self;
}

// 网络请求 get 请求
- (void)requestURLWithGET:(NSString *)url
            cacheStrategy:(NETWORK_CACHE_TYPE)cacheStrategy
                  success:(SSDataPackageSuccess)success
                  failure:(SSDataPackageFailure)failure{
//    NSLog(@"%@", url);
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *keyUrl = [NSURL URLWithString:url];
//    NSString *key = keyUrl.path;
    NSString *key = [NSString stringWithFormat:@"%@%@", url, [NSURL URLWithString:url].path];
    //是否从缓存文件里获取数据
    if (cacheStrategy == NETWORK_CACHE_TYPE_CUSTUM) {
        if ([self connectWithNetWorkType:cacheStrategy key:key success:success]) {
            return;
        }
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"get request success");
        [self dataSuccess:cacheStrategy key:key response:responseObject request:task success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败后，判断请求类型，是否从缓存中提取数据
        SSErrorInfo *errorInfo = [[SSErrorInfo alloc] init];
        errorInfo.message = NER_ERROR;
        NSLog(@"%@", NER_ERROR);
        if (cacheStrategy == NETWORK_CACHE_TYPE_SYSTEM) {
            if ([self connectWithNetWorkType:cacheStrategy key:key success:success]) {
                return;
            }
            failure(errorInfo);
        } else {
            failure(errorInfo);
        }
        NSLog(@"下载错误 is %@",error);
    }];
    
    
//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//         NSLog(@"get request success");
//         [self dataSuccess:cacheStrategy key:key request:operation success:success failure:failure];
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             //请求失败后，判断请求类型，是否从缓存中提取数据
//         SSErrorInfo *errorInfo = [[SSErrorInfo alloc] init];
//         errorInfo.message = NER_ERROR;
//             NSLog(@"%@", NER_ERROR);
//             if (cacheStrategy == NETWORK_CACHE_TYPE_SYSTEM) {
//                 if ([self connectWithNetWorkType:cacheStrategy key:key success:success]) {
//                     return;
//                 }
//                 failure(errorInfo);
//             } else {
//                 failure(errorInfo);
//             }
//             NSLog(@"下载错误 is %@",error);
//         }];
}

// 网络请求 get 请求
- (void)requestURLWithGET:(NSString *)url
                   params:(NSDictionary *)params
            cacheStrategy:(NETWORK_CACHE_TYPE)cacheStrategy
                  success:(SSDataPackageSuccess)success
                  failure:(SSDataPackageFailure)failure{
    
    NSString *urlString = [self getUrlStringByGet:url params:params];
    
    //是否从缓存文件里获取数据
    if ([self connectWithNetWorkType:cacheStrategy key:urlString success:success]) {
        return;
    }
}

// 网络请求 post 请求
- (void)requestURLWithPOST:(NSString *)url
                   params:(NSDictionary *)params
            cacheStrategy:(NETWORK_CACHE_TYPE)cacheStrategy
                  success:(SSDataPackageSuccess)success
                  failure:(SSDataPackageFailure)failure{
    
    //是否从缓存文件里获取数据
    if (cacheStrategy != NETWORK_CACHE_TYPE_SYSTEM) {
        if ([self connectWithNetWorkType:cacheStrategy key:url success:success]) {
            return;
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    NSDictionary *params = @{@"page" : @"2"};//表示第几页
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.operationQueue cancelAllOperations];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"ADFASDFAsdf111111111");
        [self dataSuccess:cacheStrategy key:url response:responseObject request:task success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(NER_ERROR);
    }];
    
    
//    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"ADFASDFAsdf111111111");
//        [self dataSuccess:cacheStrategy key:url request:operation success:success failure:failure];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failure(NER_ERROR);
//    }];
}

// 上传图片 post 请求
- (void)uploadImageWithPOST:(NSString *)url
                    params:(NSDictionary *)params
             cacheStrategy:(NETWORK_CACHE_TYPE)cacheStrategy
                   success:(SSDataPackageSuccess)success
                   failure:(SSDataPackageFailure)failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    for (NSString *key in params) {
        if ([key isEqualToString:@"header"]) {
            //头像图片
            [dataDic setObject:params[key] forKey:key];
        } else {
            //参数
            [userDic setObject:params[key] forKey:key];
        }
    }
    
    [manager POST:url parameters:userDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:dataDic[@"header"] name:@"myfiles" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dataSuccess:cacheStrategy key:url response:responseObject request:task success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(NER_ERROR);
    }];
    
//    [manager POST:url parameters:userDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//        [formData appendPartWithFileData:dataDic[@"header"] name:@"myfiles" fileName:fileName mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self dataSuccess:cacheStrategy key:url request:operation success:success failure:failure];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failure(NER_ERROR);
//    }];
}

//获取缓存 的 key
- (NSString *)getUrlStringByGet:(NSString *)url params:(NSDictionary *)params{
    
    NSString *urlString = url;
    NSString *sign = @"";
    for (NSString *key in params) {
        
        NSString *value = [params objectForKey:key];
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
        sign = [sign stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
    }
    
    sign = [sign stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"spidersubscriber",@"hdif36gh46346fgjl#kmb@yuyer76"]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",@"sign",[self md5l:sign]]];
    
    return urlString;
}

//根据缓存类型和网络判断是否 从缓存文件获取缓存数据
- (BOOL)connectWithNetWorkType:(NETWORK_CACHE_TYPE)cachType key:(NSString *)key success:(SSDataPackageSuccess)success{
    if (cachType == NETWORK_CACHE_TYPE_CUSTUM) {
        if ([[SSCache sharedCache] hasCacheForKey:key]) {
            //抛出缓存数据
            success([[SSCache sharedCache] dictionaryForKey:key]);
            
            return YES;
        }
    }
    
    if (cachType == NETWORK_CACHE_TYPE_SYSTEM) {
        if ([[SSCache sharedCache] hasCacheForKey:key]) {
            //抛出缓存数据
            success([[SSCache sharedCache] dictionaryForKey:key]);
            
            return NO;
        }
    }
    /*
     *  没网络提示。。。
     */
    
    return NO;
}


//网络请求成功返回的数据处理（包括解析、缓存）
- (void)dataSuccess:(NETWORK_CACHE_TYPE)cacheType
                key:(NSString *)key
           response:(id)response
            request:(NSURLSessionDataTask *)task
            success:(SSDataPackageSuccess)success
            failure:(SSDataPackageFailure)failure{
    
    NSString *queueName = [NSString stringWithFormat:@"request_MyQueue%@",task.response.URL];
    dispatch_queue_t workQueue = dispatch_queue_create([queueName UTF8String], NULL);
    dispatch_async(workQueue,^{
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSError *error = nil;
        id results = nil;
        NSString *jsonString = response;
        //解析数据
        if ([key hasPrefix:@"https://graph.qq.com/oauth2.0/me"]) {
            NSString *string = [[jsonString stringByReplacingOccurrencesOfString:@");" withString:@""] stringByReplacingOccurrencesOfString:@"callback(" withString:@""];
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        }else{

            results = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
        }
        //是否缓存数据
        if (cacheType != NETWORK_CACHE_TYPE_NONE && results != nil && [results isKindOfClass:[NSDictionary class]]) {
            if ([[SSCache sharedCache] hasCacheForKey:key]) {
                [[SSCache sharedCache] removeCacheForKey:key];
                [[SSCache sharedCache] setNSDictionary:(NSDictionary *)results forKey:key];
            }else{
                [[SSCache sharedCache] setNSDictionary:(NSDictionary *)results forKey:key];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            SSErrorInfo *errorInfo = [[SSErrorInfo alloc] init];
            if (results == nil) {
                //解析出错
                errorInfo.message = @"解析出错";
                errorInfo.errorCode = @"100";
                failure(errorInfo);
//                NSLog(@"json解析出错");
            }else{
                //成功抛出数据
//                NSLog(@"request.responseString == %@", request.responseString);
                NSLog(@"results == %@", results);
                NSString *resultCode = @"";
                if ([results[@"result"] isKindOfClass:[NSNumber class]]) {
                    resultCode = [results[@"result"] stringValue];
                } else {
                    resultCode = results[@"result"];
                }
                
                //过滤第三方登录
                BOOL isThirdLogin = NO;
                NSString *urlStr = [task.response.URL absoluteString];
                if ([urlStr hasPrefix:@"https://api.weixin.qq.com"]) {
                    //微信
                    isThirdLogin = YES;
                } else if ([urlStr hasPrefix:@"https://api.weibo.com/oauth2/access_token?"]||[urlStr hasPrefix:@"https://api.weibo.com/2/users/show.json?"]) {
                    //微博
                    isThirdLogin = YES;
                } else if ([urlStr hasPrefix:@""]) {
                    //支付宝
                    isThirdLogin = YES;
                } else if ([urlStr hasPrefix:@"https://graph.qq.com/oauth2.0/me?"]||[urlStr hasPrefix:@"https://graph.qq.com/user/get_user_info"]) {
                    //qq
                    isThirdLogin = YES;
                }
                
                if (results && [resultCode isEqualToString:@"0"]&&!isThirdLogin) {
                    success(results);
                } else if (results && isThirdLogin) {
                    isThirdLogin = NO;
                    success(results);
                } else {
                    errorInfo.message = results[@"message"];
                    errorInfo.errorCode = results[@"result"];
                    failure(errorInfo);
                }
            }
        });
    });
}


//停止请求
- (void)cancelHttpRequest{
    
    [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
}


@end
