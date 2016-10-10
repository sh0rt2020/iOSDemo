//
//  SSUrlAPI.m
//  SpiderSubscriber
//
//  Created by royal on 14/12/9.
//  Copyright (c) 2014年 spider. All rights reserved.
//
#import "SSUrlAPI.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
# import <CommonCrypto/CommonDigest.h>

//正式环境
#define SERVER_ADDRESS @"http://m.spider.com.cn"


//预发布环境
//#define SERVER_ADDRESS @"http://mtest.spider.com.cn"

//测试环境
//#define SERVER_ADDRESS @"http://192.168.1.129:8080/spiderwap"       //启源
//#define SERVER_ADDRESS @"http://192.168.1.120:8080/spiderwap"    //张凯
//#define SERVER_ADDRESS @"http://192.168.1.121:8080/spiderwap"    //王春晖
//#define SERVER_ADDRESS @"http://192.168.1.233:9180/spiderwap"    //彭堃
//#define SERVER_ADDRESS @"http://192.168.1.121:8080/spiderwap"  //小宝
// #define SERVER_ADDRESS   @"http://192.168.1.123:9090/spiderwap"//小范
//环信
//#define IM_ADDRESS @"http://192.168.1.129:8080"       //启源
#define IM_ADDRESS @"http://passporttest.spider.com.cn"
//#define IM_ADDRESS @"http://passport.spider.com.cn"

//登录
//#define THIRDLOGIN_ADDRESS @"http://192.168.1.233:8146"
//#define THIRDLOGIN_ADDRESS @"http://passporttest.spider.com.cn"
#define THIRDLOGIN_ADDRESS @"http://passport.spider.com.cn"


#define SSAPI_KEY                @"spidersubscriber"
#define SSTHIRD_KEY              @"66d4315c7ae88cea829bd13e9d55d7e2"  //第三方登录key
#define SSAPI_SECRET_KEY         @"hdif36gh46346fgjl#kmb@yuyer76"
#define SSAPI_SOURCE             @"蜘蛛书报亭"
#define SSAPI_CHANNELID          @"apple"
#define SSAPI_PLATFORMID         @"1"//1:ios
#define SSAPI_PRIKEY             @"0824549901"//蛛元充值Key
#define SSTHIRD_KEY              @"66d4315c7ae88cea829bd13e9d55d7e2"  //B端聊天key


inline static NSString* baseForInterFace(NSString* interface, NSString* sign) {
    
    NSString *keyString;
    keyString = [NSString stringWithFormat:@"%@/app20/%@.action?key=%@&sign=%@&fileType=json&platformId=1", SERVER_ADDRESS,interface,SSAPI_KEY,sign];
    return keyString;
}

//老接口拼接不带app20
inline static NSString* baseForInterFaceIII(NSString* interface, NSString* sign) {
    
    NSString *keyString;
    keyString = [NSString stringWithFormat:@"%@/%@.action?key=%@&sign=%@&fileType=json&platformId=1", SERVER_ADDRESS,interface,SSAPI_KEY,sign];
    return keyString;
}

//B端用户注册环信账号
inline static NSString* baseForInterFaceII(NSString* interface, NSString* sign) {
    
    NSString *keyString;
    keyString = [NSString stringWithFormat:@"%@/%@.action?key=%@&sign=%@&fileType=json&platform=1", IM_ADDRESS,interface,SSTHIRD_KEY,sign];
    return keyString;
}

//B端的
inline static NSString* B_baseForInterFace(NSString* interface, NSString* sign) {
    
    NSString *keyString;
    keyString = [NSString stringWithFormat:@"%@/appmerch20/%@.action?key=%@&sign=%@&fileType=json&platformId=1", SERVER_ADDRESS,interface,SSAPI_KEY,sign];
    return keyString;
}



@implementation SSUrlAPI

//加密
+ (NSString *)md5l:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (uint32_t)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//验签
+ (NSString *)getParameterSign:(NSDictionary *)parameters {
    
    NSMutableDictionary *mutableParaDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (!mutableParaDict) {
        mutableParaDict = [NSMutableDictionary dictionary];
    }

    [mutableParaDict setObject:@"1" forKey:@"platformId"];
    [mutableParaDict setObject:SSAPI_KEY forKey:@"key"];
    [mutableParaDict setObject:@"json" forKey:@"fileType"];
    
    NSArray *keys = [NSArray arrayWithArray:[mutableParaDict allKeys]];
    NSArray *comparedKeyArr = [keys sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *keyValues = [NSMutableArray array];
    if (mutableParaDict) {
        for (int i = 0; i < comparedKeyArr.count; i++) {
            NSString *value = mutableParaDict[comparedKeyArr[i]];
            if (value && value.length > 0) {
                if ([comparedKeyArr[i] isEqualToString:@"fileType"]) {
                    [keyValues addObject:[NSString stringWithFormat:@"%@json", comparedKeyArr[i]]];
                } else if ([comparedKeyArr[i] isEqualToString:@"key"]) {
                    [keyValues addObject:[NSString stringWithFormat:@"%@%@", comparedKeyArr[i], SSAPI_KEY]];
                }else if ([comparedKeyArr[i] isEqualToString:@"platformId"]) {
                    [keyValues addObject:[NSString stringWithFormat:@"%@1", comparedKeyArr[i]]];
                } else {
                    [keyValues addObject:[NSString stringWithFormat:@"%@%@", comparedKeyArr[i], value]];
                }
            }
        }
    }
    
    NSString *signStr =[NSString stringWithFormat:@"%@%@", [keyValues componentsJoinedByString:@""], SSAPI_SECRET_KEY];
    signStr = [self filterStringWithEmptyString:signStr];
    NSString *sign = [self md5l:signStr].uppercaseString;
    return sign;
}


//B端验签
+ (NSString *)getParameterSignII:(NSDictionary *)parameters {
    NSArray *keys = [parameters allKeys];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i = 0; i < keys.count; i++) {
        NSString *value = parameters[keys[i]];
        if (value && value.length > 0) {
            [keyValues addObject:[NSString stringWithFormat:@"%@%@", keys[i], value]];
        }
    }
    [keyValues addObject:@"fileTypejson"];
    [keyValues addObject:[NSString stringWithFormat:@"key%@", SSTHIRD_KEY]];
    [keyValues addObject:@"platform1"];
    NSArray *compareArr = [keyValues sortedArrayUsingSelector:@selector(compare:)];
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@", [compareArr componentsJoinedByString:@""]]].uppercaseString;
    return sign;
}

//过滤字符串
+ (NSString *)filter:(NSString *)str {
    if (str && str.length > 0) {
        return str;
    }
    return @"";
}

//得到搜索条件
+ (NSString *)getFilterString:(NSDictionary *)filters {
    NSMutableString *filter = [NSMutableString string];
    for (NSString *key in filters) {
        id info = filters[key];
        NSString *str = @"";
        if ([info isKindOfClass:[SSCategoryInfo class]]) {
            str = [(SSCategoryInfo *)info ssId];
        } else {
            str = info;
        }
        if (str && str.length > 0) {
            if (filter.length > 0) {
                [filter appendString:@"|"];
            }
            [filter appendString:key];
            [filter appendString:@":"];
            [filter appendString:str];
        }
    }
    return filter;
}

//去除字符串中的空格和换行符
+ (NSString *)filterStringWithEmptyString:(NSString *)string {
    string = [[string componentsSeparatedByString:@"\n"] componentsJoinedByString:@""];
    string = [[string componentsSeparatedByString:@" "] componentsJoinedByString:@""];
    return string;
}

//encode字符串
+ (NSString *)encodeString:(NSString *)str num:(NSInteger)num{
    NSString *filterStr = [self filterStringWithEmptyString:str];
    if (num == 1) {
        return [filterStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    } else {
        return [[filterStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

/**
 *  根据字典得到转换后的字符串并去掉换行符
 *
 *  @param dict
 *
 *  @return
 */
+ (NSString *)getJSONStringWith:(id)intance {
    
    NSData *signData = [NSJSONSerialization dataWithJSONObject:intance options:NSJSONWritingPrettyPrinted error:nil];
    NSString *signStr = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
    signStr = [self filterStringWithEmptyString:signStr];
    return signStr;
}

//得到请求接口
+ (NSString *)getUrlWith:(NSString *)baseUrl parameters:(NSDictionary *)parameters {
    NSArray *keys = [parameters allKeys];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i = 0; i < keys.count; i++) {
        NSString *value = parameters[keys[i]];
        if (value && value.length > 0) {
            [keyValues addObject:[NSString stringWithFormat:@"%@=%@", keys[i], value]];
        }
    }
    if (keyValues.count > 0) {
        NSString *url = [NSString stringWithFormat:@"%@&%@", baseUrl,  [keyValues componentsJoinedByString:@"&"]];
        return url;
    } else {
        return baseUrl;
    }
}



#pragma mark - 订阅有礼列表
+ (NSString *)getGiftListURLWithItemId:(NSString *)itemId page:(int)page count:(NSString *)count {
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:[NSString stringWithFormat:@"%d", page]], @"page", [self filter:count], @"count", [self filter:itemId], @"itemId", @"", @"lquerytime", nil];
    NSString *sign = [self getParameterSign:para];
    NSString *baseUrl = baseForInterFace(@"getGiftList", sign);
    NSString *url = [self getUrlWith:baseUrl parameters:para];
    
    NSLog(@"订阅有礼列表：%@", url);
    return url;
}


#pragma mark - 订阅有礼分类列表
+ (NSString *)getGiftCategory {
    
    NSString *sign = [self getParameterSign:[NSDictionary dictionary]];
    NSString *baseUrl = baseForInterFace(@"getItemList", sign);
    NSString *urlString = [self getUrlWith:baseUrl parameters:nil];
    
    NSLog(@"订阅有礼分类列表接口：%@", urlString);
    return urlString;
}

@end

