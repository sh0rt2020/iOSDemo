//
//  GBHttpManager.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/12.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBHttpManager.h"

@implementation GBHttpManager

+ (instancetype)sharedHttpManager {
    static GBHttpManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [GBHttpManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", @"application/x-javascript", @"application/x-www-form-urlencoded", nil];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    });
    return manager;
}

#pragma mark - public
- (void)getRequest:(NSString *)server
            params:(NSDictionary *)params
           success:(RequestSuccess)success
           failure:(RequestFailed)failure {
    
    NSMutableDictionary *muParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [self commonParams:muParams];
    
    [[GBHttpManager sharedHttpManager] requestMethod:HttpMethodTypeGet api:server params:params success:^(id response) {
        success(response);
    } failure:^(id task, id error) {
        failure(task, error);
    }];
}

- (void)postReuqest:(NSString *)server
             params:(NSDictionary *)params
            success:(RequestSuccess)success
            failure:(RequestFailed)failure {
    
    NSMutableDictionary *muParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [self commonParams:muParams];
    
    [[GBHttpManager sharedHttpManager] requestMethod:HttpMethodTypePost api:server params:muParams success:^(id response) {
        success(response);
    } failure:^(id task, id error) {
        failure(task, error);
    }];
}

- (void)requestMethod:(HttpMethodType)method
                  api:(NSString *)server
               params:(NSDictionary *)params
              success:(RequestSuccess)success
              failure:(RequestFailed)failure {
    
    switch (method) {
        case HttpMethodTypeGet: {
            [[GBHttpManager sharedHttpManager] GET:server parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [GBHttpManager handleResponse:responseObject Success:success Failed:failure hudInView:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [GBHttpManager handleError:error Failed:failure hudInView:nil];
            }];
        }
            break;
        case HttpMethodTypePost: {
            [[GBHttpManager sharedHttpManager] POST:server parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [GBHttpManager handleResponse:responseObject Success:success Failed:failure hudInView:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [GBHttpManager handleError:error Failed:failure hudInView:nil];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - private
//处理公共参数
- (void)commonParams:(NSMutableDictionary *)muParams {
    [muParams setObject:@3 forKey:@"userId"];
    [muParams setObject:@0 forKey:@"loginId"];
    [muParams setObject:@1 forKey:@"platform"];  //android:0 ios:1
    [muParams setObject:AppVersion forKey:@"appVersionCode"];
}

//处理回调
+ (void)handleResponse:(id)response
              Success:(RequestSuccess)success
               Failed:(RequestFailed)fail
            hudInView:(UIView *)view {

    if([response isKindOfClass:[NSDictionary class]]) {
        NSNumber *status = [response objectForKey:@"statusCode"];
        if([status integerValue] == 200) {
            if (success) {
                success(response);
            }
        } else {
            NSString *reason = [response objectForKey:@"msg"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication].keyWindow makeToast:reason duration:0.3 position:CSToastPositionCenter];
            });

            if (fail) {
                fail(nil, response);
            }
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow makeToast:@"服务器返回格式错误" duration:0.3 position:CSToastPositionCenter];
        });

        if (fail) {
            fail(nil, response);
        }
    }
}


+ (void)handleError:(id)error
            Failed:(RequestFailed)fail
         hudInView:(UIView *)view {

    NSError *myError = error;
    __block NSString *reason = [NSString stringWithFormat:@"%zd: %@", myError.code, myError.userInfo[@"NSLocalizedDescription"]];
    if (myError.userInfo[@"NSLocalizedDescription"] == nil) {
        reason = @"请求服务器失败";
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        //-1009:未连接网络 -1001:请求超时
        if (myError.code == -1009 ) {
            reason = @"未连接网络";
        } else if (myError.code == -1001) {
            reason = @"请求超时";
        }
        
        [[UIApplication sharedApplication].keyWindow makeToast:reason duration:0.3 position:CSToastPositionCenter];
        
        fail(nil, myError);
    });
}

@end
