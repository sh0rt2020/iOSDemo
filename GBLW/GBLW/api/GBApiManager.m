//
//  GBApiManager.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/12.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "GBApiManager.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

@implementation GBApiManager

#pragma mark - public interface
+ (instancetype)sharedApiManager {
    static GBApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GBApiManager alloc] init];
    });
    return manager;
}

+ (NSString *)genApiString:(NSDictionary *)params {
    NSString *apiStr = @"";
    NSArray *allKeys = [params allKeys];
    NSInteger i = 0;
    for (NSString *key in allKeys) {
        if (i == allKeys.count - 1) {
            apiStr = [apiStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, [params objectForKey:key]]];
        } else {
            apiStr = [apiStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, [params objectForKey:key]]];
        }
        
        i++;
    }
    return apiStr;
}

#pragma mark - private helper
+ (NSDictionary *)commonParamsHandle:(NSDictionary *)params {
    NSMutableDictionary *handledParams = [NSMutableDictionary dictionaryWithDictionary:params];
    //TODO: 添加公共参数
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longValue];
    
    [handledParams setValue:[NSNumber numberWithInt:2] forKey:@"SignatureVersion"];
    [handledParams setValue:@"HmacSHA256" forKey:@"SignatureMethod"];
    [handledParams setValue:[NSNumber numberWithLongLong:dTime*1000] forKey:@"Timestamp"];
    
    NSDictionary *finalParams = [GBApiManager sortApiParams:handledParams];
    
    return finalParams;
}

+ (NSDictionary *)sortApiParams:(NSDictionary *)params {
    
    NSArray *allKeys = params.allKeys;
    NSArray *sortedKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
    
    NSMutableDictionary *sortedParams = [NSMutableDictionary dictionary];
    for (NSString *key in sortedKeys) {
        id value = [params objectForKey:key];
        [sortedParams setValue:value forKey:key];
    }
    return (NSDictionary *)sortedParams;
}

+ (NSString *)encryptWithMD5:(NSDictionary *)sortedParams {
    
    //TODO: 参数一定要是排序之后的
    NSString *apiStr = [GBApiManager genApiString:sortedParams];
    
    //TODO: 拼接的路径
    NSString *md5Str = [GBApiManager md5FromString:apiStr];
    
    return md5Str;
}

+ (NSString *)encryptWithHmacSHA256:(NSDictionary *)sortedParams {
    
    //TODO: 参数一定要是排序之后的
    NSString *apiStr = [GBApiManager genApiString:sortedParams];
    
    const char *cData = [apiStr cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *sha256Str = [HMAC base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    return sha256Str;
}

+ (NSString *)md5FromString:(NSString *)str {
    if (str == nil) {
        return nil;
    }
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
