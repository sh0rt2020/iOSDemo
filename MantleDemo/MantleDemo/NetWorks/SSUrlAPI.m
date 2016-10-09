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

#pragma mark - 首页接口（搜索热词、榜单说明、分类推荐、好店推荐）
+ (NSString *)getHomeDataWith:(NSString *)provinceCode longtitude:(NSString *)longtitude latitude:(NSString *)latitude {
    NSMutableDictionary *pararmeter = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:provinceCode], @"provinceCode", [self filter:longtitude], @"longtitude",  [self filter:latitude], @"latitude", nil];
    NSString *sign = [self getParameterSign:pararmeter];
    pararmeter[@"provinceCode"] = [self encodeString:provinceCode num:2];
    NSString *baseUrl = baseForInterFace(@"getCoverInfo", sign);
    NSString *url = [self getUrlWith:baseUrl parameters:pararmeter];
    NSLog(@"%@", url);
    return url;
}
#pragma mark - 首页（活动信息，头尾广告）
+ (NSString *)getHomeActivityAndADInfo {
    NSString *sign = [self getParameterSign:nil];
    NSString *baseUrl = baseForInterFace(@"getActivityAndADInfo", sign);
    return baseUrl;
}

#pragma mark - 店铺刊物(搜索)列表
/**
 *  店铺刊物(搜索)列表
 *
 *  @return 接口
 */
+ (NSString *)getStorePaperListWith:(NSString *)storeId page:(int)page filter:(NSDictionary *)filter ptype:(NSString *)ptype sortType:(NSString *)sortType {
    NSString *filters = [self getFilterString:filter];
    NSDictionary *pararmeter = @{@"storeId":[self filter:storeId], @"filter":[self filter: filters], @"count":@"20", @"page":[NSString stringWithFormat:@"%d", page], @"ptype":[self filter:ptype], @"sortType":[self filter:sortType]};
    
    NSString *sign = [self getParameterSign:pararmeter];
    NSString *baseUrl = baseForInterFace(@"getStorePaperList", sign);
    NSMutableDictionary *urlPararmeter= [pararmeter mutableCopy];
    urlPararmeter[@"filter"] = [self encodeString:filters num:2];
    NSString *url = [self getUrlWith:baseUrl parameters:urlPararmeter];
    NSLog(@"店铺刊物(搜索)列表：%@", url);
    return url;
}


#pragma mark - 店铺基本信息
+ (NSString *)getStoreInfoWith:(NSString *)storeId {
    NSDictionary *pararmeter = @{@"userId":[self filter:[[SSToolsClass sharedTool] getUserInfo].ssUserId], @"storeId":[self filter:storeId]};
    NSString *sign = [self getParameterSign:pararmeter];
    NSString *baseUrl = baseForInterFace(@"getStoreInfo", sign);
    return [self getUrlWith:baseUrl parameters:pararmeter];
}

#pragma mark -  店铺评论列表
+ (NSString *)getStoreCommentListWith:(NSString *)storeId {
    NSDictionary *paratemer = @{@"storeId":storeId};
    NSString *sign = [self getParameterSign:paratemer];
    NSString *baseUrl = baseForInterFace(@"getStoreCommentList", sign);
    return [self getUrlWith:baseUrl parameters:paratemer];
}

#pragma mark - 获取分类列表
+ (NSString *)getCategoryList:(NSString *)type {
    NSDictionary *paratemer = @{@"ptype":type};
    NSString *sign = [self getParameterSign:paratemer];
    NSString *baseUrl = baseForInterFace(@"getCategoryList", sign);
    return [self getUrlWith:baseUrl parameters:paratemer];
}

#pragma mark - 获取刊物(搜索)列表
/**
 *  获取刊物列表
 *  @return 接口
 */
+ (NSString *)getPaperList:(NSString *)catalogId page:(int)page ptype:(NSString *)ptype sortType:(NSString *)sortType filter:(NSDictionary *)filter {
    NSString *filters = [self getFilterString:filter];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter: filters], @"filter", @"20", @"count", [NSString stringWithFormat:@"%d", page], @"page", [self filter:sortType], @"sortType", [self filter:ptype], @"ptype", catalogId, @"catalogId", nil];
    
    NSString *sign = [self getParameterSign:paraDic];
    NSString *baseUrl = baseForInterFace(@"getPaperList", sign);
    paraDic[@"filter"] = [self encodeString:filters num:2];
    NSString *url = [self getUrlWith:baseUrl parameters:paraDic];
    NSLog(@"刊物(搜索)列表：%@", url);
    return url;
}



#pragma mark - 搜索配置（商品和店铺的筛选条件）
+ (NSString *)getSearchConfiguration {
    NSString *sign = [self getParameterSign:nil];
    NSString *baseUrl = baseForInterFace(@"getSearchConfiguration", sign);
    return baseUrl;
}

#pragma mark - 店铺配置条件
+ (NSString *)getStoreConfiguration:(NSString *)storeId {
    NSDictionary *paratemer = @{@"storeId":storeId};
    NSString *sign = [self getParameterSign:paratemer];
    NSString *baseUrl = baseForInterFace(@"getStoreConfiguration", sign);
    return [self getUrlWith:baseUrl parameters:paratemer];
}

#pragma mark - 所有市列表
+ (NSString *)getAllCityURLString{
    
    NSString* sign = [self md5l:[NSString stringWithFormat:@"%@%@", SSAPI_KEY, SSAPI_SECRET_KEY]];
    NSString *urlString = [NSString stringWithFormat:@"%@/appallCityList.action?fileType=json&key=%@&platformId=1&sign=%@",SERVER_ADDRESS,SSAPI_KEY,sign];
    NSLog(@"%@", urlString);
    
    return urlString;
}

#pragma mark - 省列表
+ (NSString *)getProvincesURLString{
    NSString* sign = [self getParameterSign:nil];
    NSString *urlString = baseForInterFace(@"provinceList", sign);
    NSLog(@"%@", urlString);
    return urlString;
}

#pragma mark - 城市列表
+ (NSString *)getCityURLString:(NSString *)provinceId{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:provinceId, @"province", nil];
    NSString* sign = [self getParameterSign:paraDic];
    NSString *baseUrl = baseForInterFace(@"cityList", sign);
    paraDic[@"province"] = [self encodeString:provinceId num:2];
    NSString *urlString = [self getUrlWith:baseUrl parameters:paraDic];
    
    return urlString;
}

#pragma mark - 区列表
+ (NSString *)getAreaURLString:(NSString *)provinceId city:(NSString *)cityId{
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:provinceId, @"province", cityId, @"city", nil];
    NSString* sign = [self getParameterSign:paraDic];
    NSString *baseUrl = baseForInterFace(@"regionList", sign);
    paraDic[@"province"] = [self encodeString:provinceId num:2];
    paraDic[@"city"] = [self encodeString:cityId num:2];
    NSString *urlString = [self getUrlWith:baseUrl parameters:paraDic];
    return urlString;

}

#pragma mark - 报刊、杂志、图书
+ (NSString *)getItemDetailUrlString:(NSString *)paperId mainId:(NSString *)mainId cityName:(NSString *)cityName longtitude:(NSString *)longtitude latitude:(NSString *)latitude shopId:(NSString *)shopId userId:(NSString *)userId type:(NSString*)type {
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:paperId], @"paperId", [self filter:mainId], @"mainId", [self filter:cityName], @"cityName", [self filter:longtitude], @"longtitude", [self filter:latitude], @"latitude", [self filter:shopId], @"shopId", [self filter:userId], @"userId", [self filter:type],@"type",  nil];
    NSString *sign = [self getParameterSign:paraDict];
    
    NSString *baseStr = baseForInterFace(@"getPaperInfo", sign);
    [paraDict setObject:[self encodeString:[self filter:cityName] num:2] forKey:@"cityName"];
    NSString *urlString = [self getUrlWith:baseStr parameters:paraDict];
    
    NSLog(@"商品详情页:%@", urlString);
    return urlString;
}


#pragma mark - 登录
+ (NSString *)getLoginURLString:(NSString *)username
                       password:(NSString *)password
                     verifyCode:(NSString *)verifyCode
                        channel:(NSString*)channel
  {

    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:[username uppercaseString]], @"userName", [self filter:[password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], @"password", [self filter:verifyCode], @"verifyCode", DeviceUUID, @"deviceId", @"spidersubscriber_iPhone", @"platform",[self filter:channel] , @"channel",nil];

    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"userLogin", sign);
    
//    [paraDict setObject:[self filter:[[SSToolsClass encodeString:[SSToolsClass encodeString:username]] uppercaseString]] forKey:@"userName"];
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"登录接口：%@", urlString);
    return urlString;
}

#pragma mark - 第三方登录
+ (NSString *)getLoginURLString:(NSString *)thirdSource
                       username:(NSString *)username
                          alias:(NSString *)alias
                          token:(NSString *)token {
    
    
    alias = [alias stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    username = [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *tokens = @"";
    if (token.length > 0) {
        tokens = token;
    }
    NSString *sign = [[self md5l:[NSString stringWithFormat:@"alias%@channelappstoredeviceId%@fileTypejsonkey%@platformsubscriber_iPhonesourcesubscriberthirdSource%@token%@userName%@versionv1.0.0", [alias stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], DeviceUUID, SSTHIRD_KEY, thirdSource, tokens, [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] uppercaseString];
    NSString *url = [NSString stringWithFormat:@"%@/openMemberLogin.html?thirdSource=%@&userName=%@&alias=%@&token=%@&deviceId=%@&sign=%@&source=subscriber&version=v1.0.0&platform=subscriber_iPhone&channel=appstore&fileType=json", THIRDLOGIN_ADDRESS, thirdSource, [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [alias stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], tokens, DeviceUUID, sign];
    
    NSLog(@"第三方登录接口：%@", url);
    return url;
}

#pragma mark - 获取支付宝加密登录
+ (NSString *)getAliPayLoginUrlString {
    NSString *service = @"wap.user.common.login";
    NSString *sign = [self md5l:[NSString stringWithFormat:@"key%@service%@", SSTHIRD_KEY, service]];
    NSString *url = [NSString stringWithFormat:@"%@/alipayMD5.html?service=%@&sign=%@&key=%@", THIRDLOGIN_ADDRESS, service, sign, SSTHIRD_KEY];
    
    NSLog(@"支付宝加密登录：%@", url);
    return url;
}

#pragma mark - 注册
+ (NSString *)getRegisterURLString:(NSString *)mobile
                                          password:(NSString *)password
                                        verifyCode:(NSString *)verifyCode
                                        channel:(NSString*)channel {
    
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:mobile], @"mobile", [self filter:password], @"password", [self filter:[self md5l:verifyCode]], @"verifyCode", DeviceUUID, @"deviceId", @"subscriber_iPhone", @"platform",[self filter:channel],@"channel", nil];
 
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"userRegister", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"注册接口：%@", urlString);
    return urlString;
}

#pragma mark - 发送手机验证码
+ (NSString *)getPhoneVerifyCodeURLString:(NSString *)mobile module:(NSString *)module {
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:mobile], @"mobile", [self filter:module], @"module", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = B_baseForInterFace(@"sendPhoneVerifyCode", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"手机验证码接口：%@", urlString);
    return urlString;
}

#pragma mark - 找回登录密码
+ (NSString *)getResetPasswordURLString:(NSString *)mobile
                             verifyCode:(NSString *)verifyCode
                               password:(NSString *)password {
    //mobile + password + verifyCode +key+私钥)
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:mobile], @"mobile", [self filter:[self md5l:verifyCode]], @"verifyCode", [self filter:password], @"password", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseStr = baseForInterFace(@"resetPassword", sign);
    NSString *urlString = [self getUrlWith:baseStr parameters:paraDict];
    
    NSLog(@"找回密码接口：%@", urlString);
    return urlString;
}

#pragma mark - 加入购物车
+ (NSString *)getAddCartURLString:(NSString *)userId
                                                 item:(SSPublicationInfo *)item
                                        orderNow:(NSString *)orderNow {
    
    NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:item.ssCityName], @"cityName", [self filter:item.ssDTypeId], @"dTypeId", [self filter:item.ssPaperId], @"paperId", [self filter:item.ssPeriod], @"period", [self filter:item.ssGiftId], @"giftId", [self filter:item.ssQuantity], @"quantity", [self filter:item.ssStartDate], @"startDate", [self filter:item.ssStoreId], @"storeId", [self filter:orderNow], @"ordernow",  nil];
    NSString *signStr = [self getJSONStringWith:itemDict];
    
    [itemDict setObject:[self encodeString:[self filter:item.ssCityName] num:1] forKey:@"cityName"];
    NSString *itemStr = [self getJSONStringWith:itemDict];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:signStr], @"cartItem", nil];
    
    NSString *sign = [self getParameterSign:paraDict];
    paraDict[@"cartItem"] = [self filter:itemStr];
    
    NSString *baseString = baseForInterFace(@"addCartItem", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
//    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"加入购物车接口：%@", [self encodeString:urlString num:1]);
    return [self encodeString:urlString num:1];
}

#pragma mark - 收藏
+ (NSString *)getBookmarkPaperWithUserId:(NSString *)userId
                                                           targetId:(NSString *)targetId
                                                                type:(NSString *)type {
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:targetId], @"targetId", [self filter:type], @"type", nil];
    NSString *sign = [self getParameterSign:paraDict];
    paraDict[@"targetId"] = [self filter:[self encodeString:targetId num:1]];
    NSString *baseString = baseForInterFace(@"bookmarkPaper", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"收藏接口：%@", urlString);
    return urlString;
}

#pragma mark - 取消收藏
+ (NSString *)getCancelBoookmarkPaperWithUserId:(NSString *)userId
                                                                 bookmarkId:(NSString *)bookmarkId type:(NSString *)type{
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:bookmarkId], @"bookmarkId", [self filter:type], @"type", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"cancelBookmarkPaper", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"取消收藏接口：%@", urlString);
    return urlString;
}

#pragma mark - 购物车列表
+ (NSString *)getShoppingCartURLString:(NSString *)userId city:(NSString *)city longtitude:(NSString *)longtitude latitude:(NSString *)latitude {
    NSMutableDictionary *parmters = [NSMutableDictionary dictionaryWithObjectsAndKeys: [self filter:userId], @"userId", [self filter:city], @"cityName", [self filter:longtitude], @"longtitude", [self filter:latitude], @"latitude", nil];
    NSString *sign = [self getParameterSign:parmters];
    NSString *baseUrl = baseForInterFace(@"getMyCart", sign);
    parmters[@"cityName"] = [self encodeString:city num:2];
    NSString *url = [self getUrlWith:baseUrl parameters:parmters];
    NSLog(@"购物车列表：%@", url);
    return url;
}

#pragma mark - 获取订单列表
+ (NSString *)getOrderListWithStatus:(NSString *)status
                              userId:(NSString *)userId
                                page:(NSString *)page
                               count:(NSString *)count
                          lQueryTime:(NSString *)lQueryTime {
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:status], @"status", [self filter:userId], @"userId", [self filter:page], @"page", [self filter:count], @"count", [self filter:lQueryTime], @"lquerytime", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"getOrderlist", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"订单列表接口：%@", urlString);
    return urlString;
}

#pragma mark - 获取订单详情
+ (NSString *)getOrderDetailWithUserId:(NSString *)userId
                               orderId:(NSString *)orderId
                         orderdetailId:(NSString *)orderdetailId{
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:orderId], @"orderId", [self filter:orderdetailId], @"orderdetailId", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"getOrderDetail", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"订单详情接口：%@", urlString);
    return urlString;
}

#pragma mark - 获取支付成功订单的所有支付方式

+ (NSString *)getOrderPayTypesWithorderId:(NSString *)orderId userId:(NSString *)userId{
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:orderId], @"orderId", [self filter:userId], @"userId", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"getOrderPayTypes", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"获取支付成功订单的所有支付方式：%@", urlString);
    return urlString;
}

#pragma mark - 获取物流信息
+ (NSString *)getShiplistWithUserId:(NSString *)userId
                            orderId:(NSString *)orderId
                      orderdetailId:(NSString *)orderdetailId {
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:orderId], @"orderId", [self filter:orderdetailId], @"orderdetailId", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"getShiplist", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"获取物流信息：%@", urlString);
    return urlString;
}

#pragma mark - 删除购物车
+ (NSString *)getDeletShopCart:(NSString *)cartId userId:(NSString *)userId{
    NSMutableDictionary *parmters = [NSMutableDictionary dictionaryWithObjectsAndKeys:cartId, @"cartItems", userId, @"userId", nil];
    NSString *sign = [self getParameterSign:parmters];
    NSString *baseUrl = baseForInterFace(@"deleteCartItem", sign);
    parmters[@"cartItems"] = [self filter:[self encodeString:cartId num:1]];
    return [self getUrlWith:baseUrl parameters:parmters];
}

#pragma mark - 清空购物车
+ (NSString *)getClearCart:(NSString *)userId {
    NSDictionary *parmters = [NSDictionary dictionaryWithObjectsAndKeys: userId, @"userId", nil];
    NSString *sign = [self getParameterSign:parmters];
    NSString *baseUrl = baseForInterFace(@"clearCart", sign);
    return [self getUrlWith:baseUrl parameters:parmters];
}

#pragma mark - 修改购物车
+ (NSString *)getChangeCartURLString:(NSString *)userId item:(SSPublicationInfo *)item {
    NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:item.ssCityName], @"cityName", [self filter:item.ssDTypeId], @"dTypeId", [self filter:item.ssGiftId], @"giftId", [self filter:item.ssQuantity] , @"quantity", [self filter:item.ssStartDate], @"startDate", [self filter:item.ssCartId], @"cartItemId",  nil];
    NSString *itemStr = [self getJSONStringWith:itemDict];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userId, @"userId", itemStr, @"cartItem", nil];
    NSString *sign = [self getParameterSign:paraDic];
    paraDic[@"cartItem"] = [self encodeString:itemStr num:2];
    NSString *baseUrl = baseForInterFace(@"updateCartItem", sign);
    NSString *url = [self getUrlWith:baseUrl parameters:paraDic];
    NSLog(@"修改购物车:%@",url);
    return url;
}
#pragma mark - 修改购物车中的商品数量
+ (NSString *)getChangeCartURLString:(NSString *)userId cartId:(NSString *)cartIt cartNum:(NSString *)cartNum {
    NSDictionary *parmters = [NSDictionary dictionaryWithObjectsAndKeys: userId, @"userId", cartIt, @"cartId", cartNum, @"cartNum", nil];
    NSString *sign = [self getParameterSign:parmters];
    NSString *baseUrl = baseForInterFace(@"updateCartNum", sign);
    return [self getUrlWith:baseUrl parameters:parmters];
}

#pragma mark - 修改购物车中配送省份
+ (NSString *)getUpdateCityNameURLString:(NSString *)userId cityName:(NSString *)cityName {
    NSMutableDictionary *parmters = [NSMutableDictionary dictionaryWithObjectsAndKeys: [self filter:userId], @"userId", [self filter:cityName], @"cityName", nil];
    NSString *sign = [self getParameterSign:parmters];
    NSString *baseUrl = baseForInterFace(@"updateCity", sign);
    parmters[@"cityName"] = [self encodeString:cityName num:2];
    return [self getUrlWith:baseUrl parameters:parmters];
}

#pragma mark - 修改购物车中图书模板商品的配送方式
+ (NSString *)getUpdateCartDTypeURLString:(NSString *)userId cartId:(NSString *)cartId dType:(NSString *)dType shopId:(NSString *)shopId {
    NSDictionary *parmters = [NSMutableDictionary dictionaryWithObjectsAndKeys: [self filter:userId], @"userId", [self filter:cartId], @"cartId", [self filter:shopId], @"shopId", [self filter:dType], @"dType",  nil];
    NSString *sign = [self getParameterSign:parmters];
    NSString *baseUrl = baseForInterFace(@"updateCartDType", sign);
    return [self getUrlWith:baseUrl parameters:parmters];
}

#pragma mark - 账号信息
+ (NSString *)getUserInfoURLString:(NSString *)userId {
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"getUserInfo", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"获取用户信息接口：%@", urlString);
    return urlString;
}

#pragma mark - 供应商列表
+ (NSString *)getSupplierListURLString:(NSString *)paperId province:(NSString *)province city:(NSString *)cityName longtitude:(NSString *)longtitude latitude:(NSString *)latitude page:(NSString *)page count:(NSString *)count filter:(NSDictionary *)filter psType:(NSString*)psType  {
    NSString *filterStr = [self getFilterString:filter];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:paperId], @"paperId", [self filter:province], @"province", [self filter:cityName], @"city", [self filter:longtitude], @"longtitude", [self filter:latitude], @"latitude", [self filter:page], @"page", [self filter:count], @"count", [self filter:filterStr], @"filter",[self filter:psType],@"psType", nil];
    NSString *sign = [self getParameterSign:paraDict];
    
    NSString *baseString = baseForInterFace(@"getSupplierList", sign);
    [paraDict setObject:[self encodeString:filterStr num:1] forKey:@"filter"];
    [paraDict setObject:[self filter:[self encodeString:cityName num:2]] forKey:@"city"];
    [paraDict setObject:[self filter:[self encodeString:province num:2]] forKey:@"province"];
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"供应商列表接口：%@", urlString);
    return urlString;
}



#pragma mark - 杂志零售列表
+ (NSString *)getRetailListWithcategoryId:(NSString *)categoryId
                                     page:(NSString *)page
                               longtitude:(NSString *)longtitude
                                 latitude:(NSString *)latitude{
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:categoryId], @"categoryId", [self filter:page], @"page", @"10", @"count", [self filter:longtitude], @"longtitude", [self filter:latitude], @"latitude", nil];
    NSString *sign = [self getParameterSign:para];
    NSString *baseUrl = baseForInterFace(@"getRetailList", sign);
    NSString *url = [self getUrlWith:baseUrl parameters:para];
    NSLog(@"杂志零售 %@", url);
    return url;
}

#pragma mark - 图书榜单列表
+ (NSString *)getBookRankListWithRankId:(NSString *)rankId
                                   page:(int)page
                             longtitude:(NSString *)longtitude
                               latitude:(NSString *)latitude {
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:rankId], @"rankId", [self filter:[NSString stringWithFormat:@"%d", page]], @"page", @"20", @"count", [self filter:longtitude], @"longtitude", [self filter:latitude], @"latitude", nil];
    NSString *sign = [self getParameterSign:para];
    NSString *baseUrl = baseForInterFace(@"getBookRankList", sign);
    NSString *url = [self getUrlWith:baseUrl parameters:para];
    NSLog(@"图书榜单列表 %@", url);
    return url;
}

#pragma mark - 专题首页列表
+ (NSString *)getSpecialTopicList {
    
    NSString *sign = [self getParameterSign:nil];
    NSString *urlStr = baseForInterFace(@"getHotSpecilActList", sign);
    NSLog(@"专题首页列表接口：%@", urlStr);
    return urlStr;
}

#pragma mark - 专题详情列表
+ (NSString *)getSpecialTopicPaperListWithSpecialTopicId:(NSString *)topicId page:(int)page longtitude:(NSString *)longtitude latitude:(NSString *)latitude {
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:topicId], @"spicalactid", [self filter:[NSString stringWithFormat:@"%d", page]], @"page", @"20", @"count", [self filter:longtitude], @"longtitude", [self filter:latitude], @"latitude", nil];
    NSString *sign = [self getParameterSign:para];
    NSString *baseUrl = baseForInterFace(@"getSpecialTopicPaperList", sign);
    NSString *url = [self getUrlWith:baseUrl parameters:para];
    
    NSLog(@"专题详情列表 %@", url);
    return url;
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

#pragma mark - 首页抢购活动接口
+ (NSString *)getSnapupList {

    NSString *sign = [self getParameterSign:nil];
    NSString *baseUrl = baseForInterFace(@"getSnapupList", sign);
    
    NSLog(@"抢购列表接口：%@", baseUrl);
    return baseUrl;
}

#pragma mark - 收货地址列表
+ (NSString *)getAddressList:(NSString *)userId
                    defaultA:(NSString *)def {
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:def], @"default", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"getAddresses", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"收货地址列表接口:%@", urlString);
    return urlString;
}

#pragma mark - 修改地址
+ (NSString *)getEditAddressWithUserId:(NSString *)userId
                               address:(NSString *)address
                              province:(NSString *)province
                                  city:(NSString *)city
                             addressId:(NSString *)addressId
                                region:(NSString *)region
                                   zip:(NSString *)zip
                                  name:(NSString *)name
                                 phone:(NSString *)phone
                            longtitude:(NSString *)longitude
                              latitude:(NSString *)latitude
                             isDefault:(NSString *)isDefault {
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [self filter:userId], @"userId", [self filter:address], @"address", [self filter:province], @"province", [self filter:city], @"city", [self filter:addressId], @"addressId", [self filter:region], @"region", [self filter:zip], @"zip", [self filter:name], @"name", [self filter:phone], @"phone", longitude, @"longitude", latitude, @"latitude", [self filter:isDefault], @"isDefault", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"changeAddress", sign);
    
    [paraDict setObject:[self filter:[self encodeString:address num:1]] forKey:@"address"];
    [paraDict setObject:[self filter:[self encodeString:province num:1]] forKey:@"province"];
    [paraDict setObject:[self filter:[self encodeString:city num:1]] forKey:@"city"];
    [paraDict setObject:[self filter:[self encodeString:region num:1]] forKey:@"region"];
    [paraDict setObject:[self filter:[self encodeString:name num:1]] forKey:@"name"];
    
    NSString *urlString = [self encodeString:[self getUrlWith:baseString parameters:paraDict] num:1];
    
    NSLog(@"修改地址接口：%@", urlString);
    return urlString;
}

#pragma mark - 新增收货地址
+ (NSString *)getAddAddressWithUserId:(NSString *)userId
                              address:(NSString *)address
                             province:(NSString *)province
                                 city:(NSString *)city
                               region:(NSString *)region
                                  zip:(NSString *)zip
                                 name:(NSString *)name
                                phone:(NSString *)phone
                           longtitude:(NSString *)longtitude
                             latitude:(NSString *)latitude {

    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:address], @"address", [self filter:province], @"province", [self filter:city], @"city", [self filter:region], @"region", [self filter:zip], @"zip", [self filter:name], @"name", [self filter:phone], @"phone", [self filter:longtitude], @"longitude", [self filter:latitude], @"latitude", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"addAddress", sign);
    [paraDict setObject:[self filter:[self encodeString:address num:1]] forKey:@"address"];
    [paraDict setObject:[self filter:[self encodeString:province num:1]] forKey:@"province"];
    [paraDict setObject:[self filter:[self encodeString:city num:1]] forKey:@"city"];
    [paraDict setObject:[self filter:[self encodeString:region num:1]] forKey:@"region"];
    [paraDict setObject:[self filter:[self encodeString:name num:1]] forKey:@"name"];
    NSString *urlString = [self encodeString:[self getUrlWith:baseString parameters:paraDict] num:1];
    
    NSLog(@"新增收货地址的接口：%@", urlString);
    return urlString;
}

#pragma mark - 删除收货地址
+ (NSString *)getDeleteAddressList:(NSString *)userId
                         addressId:(NSString *)addressId {
    
    NSDictionary *paraDict = [[NSDictionary alloc] initWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:addressId], @"addressId", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"deleteAddress", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"删除收货地址接口：%@", urlString);
    return urlString;
}

#pragma mark - 清空搜索地址
+ (NSString *)getclearHistoryAdress:(NSString *)userId {
    NSDictionary *paraDict = [[NSDictionary alloc] initWithObjectsAndKeys:[self filter:userId], @"userId", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"clearHistoryAddress", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"清空搜索地址：%@", urlString);
    return urlString;
}

#pragma mark - 获取订单支付信息
+ (NSString *)getOrderPayInfoWith:(NSString *)userId orderId:(NSString *)orderIds {
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:orderIds], @"orders", nil];
    NSString *sign = [self getParameterSign:paraDict];
    paraDict[@"orders"] = [self filter:[self encodeString:orderIds num:1]];
    NSString *baseString = baseForInterFace(@"getOrderPayInfo", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"获取订单支付信息：%@", urlString);
    return urlString;
}

#pragma mark - 可用支付方式列表
+ (NSString *)getValidPayTypeListWithUser:(NSString *)userId orderId:(NSString *)orderId {
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", orderId, @"orderId", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"getValidPaytypeList", sign);
    paraDict[@"orderId"] = [self filter:[self encodeString:orderId num:1]];
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"可用支付方式列表：%@", urlString);
    return urlString;
}

#pragma mark - 头像上传接口
//#define SERVER_ADDRESS @"http://m.spider.com.cn/"
+ (NSString *)getSetHeaderURLString {
//    NSString *urlString = [NSString stringWithFormat:@"%@appsetHeader.action", @"http://m.spider.com.cn/"];

    NSString *urlString = [NSString stringWithFormat:@"%@/appsetHeader.action", SERVER_ADDRESS];
    
    NSLog(@"修改头像接口：%@", urlString);
    return urlString;
}

#pragma mark - 
+ (NSDictionary *)getSetHeaderDcitWith:(NSString *)userId
                                header:(NSData *)header {
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@", userId, SSAPI_KEY, SSAPI_SECRET_KEY]];
    
    NSDictionary *dict = @{@"key":SSAPI_KEY, @"userId":userId, @"platformId":@"1", @"sign":sign, @"header":header};
    return dict;
}

#pragma mark - 取消订单
+ (NSString *)getCancelOrderWithUserId:(NSString *)userId
                              orderId:(NSString *)orderId
                               reason:(NSString *)reason {
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:orderId], @"orderId", [self filter:reason], @"reason", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"cancelOrder", sign);
    
    [paraDict setObject:[self encodeString:reason num:1] forKey:@"reason"];
    NSString *urlString = [self encodeString:[self getUrlWith:baseString parameters:paraDict] num:1];
    
    NSLog(@"取消订单接口：%@", urlString);
    return urlString;
}

#pragma mark - 获取确认码
+ (NSString *)getConfirm:(NSString *)userId orderId:(NSString *)orderId orderDetailId:(NSString *)orderDetailId delDyqs:(NSString *)delDyqs type:(NSString *)type {
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:orderId], @"orderId", [self filter:orderDetailId], @"orderdetailid", [self filter:delDyqs], @"deldyqs", [self filter:type], @"type", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"deliver", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"获取确认码接口：%@", urlString);
    return urlString;
}

#pragma mark - 确认收货
+ (NSString *)confirmOrder:(NSString *)userId orderId:(NSString *)orderId orderDetailId:(NSString *)orderDetailId qrqs:(NSString *)qrqs {
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:orderId], @"orderId", [self filter:orderDetailId], @"orderDetailId", [self filter:qrqs], @"qrqs", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"confirmOrder", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"确认收货接口：%@", urlString);
    return urlString;
}

#pragma mark - 我的消息列表
+ (NSString *)getMyMessages:(NSString *)userId count:(NSString *)count page:(NSString *)page {
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:count], @"count", [self filter:page], @"page", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"getMyMessages", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"我的消息列表接口：%@", urlString);
    return urlString;
}

#pragma mark - 收藏刊物列表
+ (NSString *)getBoookmarkPaperList:(NSString *)userId page:(NSString *)page count:(NSString *)count lQueryTime:(NSString *)lQueryTime  {
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", page, @"page", count, @"count", lQueryTime, @"lquerytime", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"getBoookmarkPaperList", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"收藏刊物列表接口：%@", urlString);
    return urlString;
}

#pragma mark - 收藏店铺列表
+ (NSString *)getBoookmarkStoreList:(NSString *)userId longtitude:(NSString *)longtitude latitude:(NSString *)latitude page:(NSString *)page count:(NSString *)count lQueryTime:(NSString *)lQueryTime {
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:longtitude], @"longtitude", [self filter:latitude], @"latitude", page, @"page", count, @"count", lQueryTime, @"lquerytime", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"getBoookmarkStoreList", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"收藏店铺列表接口：%@", urlString);
    return urlString;
}


#pragma mark - 使用抵用券
+ (NSString *)getPaymentDYQWithOrderId:(NSString *)orderId
                                userId:(NSString *)userId
                            cardNumber:(NSString *)cardNumber {
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@%@%@", userId, orderId, cardNumber, SSAPI_KEY, SSAPI_SECRET_KEY]];
    NSString *url = [NSString stringWithFormat:@"%@/apppaymentDYQ.action?fileType=json&platformId=1&orderId=%@&userId=%@&cardNumber=%@&key=%@&sign=%@", SERVER_ADDRESS, orderId, userId, cardNumber, SSAPI_KEY, sign];
    return url;
    
}

#pragma mark - 使用蜘蛛卡
+ (NSString *)getPaymentSpiderCardWithOrderId:(NSString *)orderId
                                       userId:(NSString *)userId
                                   cardNumber:(NSString *)cardNumber
                                  payPassword:(NSString *)payPassword {
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@%@%@%@", userId, orderId, cardNumber, payPassword, SSAPI_KEY, SSAPI_SECRET_KEY]];
    NSString *url = [NSString stringWithFormat:@"%@/apppaymentSpiderCard.action?fileType=json&platformId=1&orderId=%@&userId=%@&cardNumber=%@&payPassword=%@&key=%@&sign=%@", SERVER_ADDRESS, orderId, userId, cardNumber, payPassword, SSAPI_KEY, sign];
    
    return url;
}

#pragma mark - 珠元支付
+ (NSString *)getPaymentSpiderYuanWithOrderId:(NSString *)orderId
                                       userId:(NSString *)userId
                                  payPassword:(NSString *)payPassword {
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@%@%@", userId, orderId, payPassword, SSAPI_KEY, SSAPI_SECRET_KEY]];
    NSString *url = [NSString stringWithFormat:@"%@/apppaymentSpiderYuan.action?fileType=json&platformId=1&orderId=%@&userId=%@&payPassword=%@&key=%@&sign=%@", SERVER_ADDRESS, orderId, userId, payPassword, SSAPI_KEY, sign];
    NSLog(@"蛛元支付 %@", url);
    return [self encodeString:url num:1];
}

#pragma mark - 微信支付
+ (NSString *)getPaymentWeixinPayUtilWithOrderId:(NSString *)orderId
                                          userId:(NSString *)userId
                                    netpayamount:(NSString *)netpayamount
                                       isDeposit:(NSString *)isDeposit{
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@%@", userId, orderId, SSAPI_KEY, SSAPI_SECRET_KEY]];
    NSString *url = [NSString stringWithFormat:@"%@/appweixinPayUtil.action?fileType=json&platformId=1&orderId=%@&userId=%@&key=%@&sign=%@&netpayamount=%@&isDeposit=%@", SERVER_ADDRESS, orderId, userId, SSAPI_KEY, sign, netpayamount, isDeposit];
    return [self encodeString:url num:1];
}

#pragma mark - 支付宝支付
+ (NSString *)getPaymentAlipayJPayUtilWithOrderId:(NSString *)orderId
                                           userId:(NSString *)userId
                                     netpayamount:(NSString *)netpayamount
                                        isDeposit:(NSString *)isDeposit{
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@", orderId, SSAPI_KEY, SSAPI_SECRET_KEY]];
    NSString *url = [NSString stringWithFormat:@"%@/appalipayJPayUtil.action?fileType=json&platformId=1&orderId=%@&key=%@&sign=%@&userId=%@&netpayamount=%@&isDeposit=%@", SERVER_ADDRESS, orderId, SSAPI_KEY, sign, userId, netpayamount, isDeposit];
    
    return [self encodeString:url num:1];
}

#pragma mark - 银联支付
+ (NSString *)getPaymentNetPayUtilWithOrderId:(NSString *)orderId
                                      paytype:(NSString *)paytype
                                      psource:(NSString *)psource
                                 netpayamount:(NSString *)netpayamount isDeposit:(NSString *)isDeposit userId:(NSString *)userId{
    //（orderId+paytype+psource+netpayamount +key+私钥）
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@%@%@%@", orderId, paytype, psource, netpayamount, SSAPI_KEY, SSAPI_SECRET_KEY]];
    
    NSString *url = [NSString stringWithFormat:@"%@/appylPayUtil.action?fileType=json&platformId=1&orderId=%@&paytype=%@&psource=%@&netpayamount=%@&key=%@&sign=%@&isDeposit=%@&userId=%@", SERVER_ADDRESS, orderId, paytype, psource, netpayamount, SSAPI_KEY, sign, isDeposit, userId];
    
    return [self encodeString:url num:1];
    
}

#pragma mark - 修改登录密码
+ (NSString *)getChangePasswordURLString:(NSString *)userId
                                  mobile:(NSString *)mobile
                              verifyCode:(NSString *)verifyCode
                              newPassword:(NSString *)newPasswrd   module:(NSString *)module
                            {

    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:mobile], @"mobile", [self filter:[self md5l:verifyCode]], @"verifyCode",[self filter:newPasswrd],@"newPassword",[self filter:module],@"module" ,nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"changePassword", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"修改登录密码接口：%@", urlString);
    return urlString;
                            
}
#pragma mark - 验证验证码
+ (NSString *)getjudgeVerifyCodeURLMobile:(NSString *)mobile
                              verifyCode:(NSString *)verifyCode
{
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys: [self filter:mobile], @"mobile", [self filter:[self md5l:verifyCode]], @"verifyCode",nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"judgeVerifyCode", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"检查验证码接口：%@", urlString);
    return urlString;
}




#pragma mark - 绑定手机
+ (NSString *)getBindModileURLString:(NSString *)userId
                              mobile:(NSString *)mobile
                          verifyCode:(NSString *)verifyCode module:(NSString *)module{
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:mobile], @"mobile", [self filter:verifyCode], @"verifyCode", [self filter:module], @"module",nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"bindMobile", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"绑定手机号：%@", urlString);
    return urlString;
}

#pragma mark - 设置支付密码
+ (NSString *)getSetPayPasswordWithUserId:(NSString *)userId
                                   mobile:(NSString *)mobile
                               verifyCode:(NSString *)verifyCode
                              payPassword:(NSString *)payPassword module:(NSString *)module {

    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:mobile], @"mobile", [self filter:[self md5l:verifyCode]], @"verifyCode", [self filter:payPassword], @"payPassword", [self filter:module], @"module", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"payPassword", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];

    NSLog(@"设置支付密码接口：%@", urlString);
    return urlString;
}

#pragma mark - 账户明细
+ (NSString *)getAccountParticularsWithUserId:(NSString *)userId {
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@", userId, SSAPI_CHANNELID, SSAPI_PRIKEY]];
    NSString *url = [NSString stringWithFormat:@"%@/clientLogin.jsp?goUrl=%@/movie20/zydetail.html?hideSource=appsbt&userid=%@&&key=%@&sign=%@", SERVER_ADDRESS,SERVER_ADDRESS, userId, SSAPI_CHANNELID, sign];
    NSLog(@"账户明细接口：%@", url);
    return url;
}
#pragma mark - 红包
+(NSString *)getHongbaoWithUserId:(NSString *)userId NSSting:(NSString*)H5url{
    
    NSArray * h5URLArr = [H5url componentsSeparatedByString:@"/activity/"];
    NSString * h5URLString;
    if (h5URLArr.count > 0) {
       h5URLString = [h5URLArr objectAtIndex:0];
    }

     NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@", userId, SSAPI_CHANNELID, SSAPI_PRIKEY]];
    NSString *url = [NSString stringWithFormat:@"%@/clientLogin.jsp?goUrl=%@&hideSource=appsbt&userid=%@&&key=%@&sign=%@", h5URLString,H5url, userId, SSAPI_CHANNELID, sign];
    NSLog(@"红包接口：%@", url);
    return url;
}
#pragma mark -  广告详情联合登陆
+(NSString *)getADDetailsWithUserId:(NSString *)userId Info:(SSActADInfo *)info{
    
    NSString * WebUrl=[info.ssUrl stringByReplacingOccurrencesOfString:@"?"withString:@"&"];
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@", userId, SSAPI_CHANNELID, SSAPI_PRIKEY]];
    NSString *url = [NSString stringWithFormat:@"%@/clientLogin.jsp?goUrl=%@&hideSource=appsbt&utm_source=app&userid=%@&&key=%@&sign=%@", SERVER_ADDRESS,WebUrl, userId, SSAPI_CHANNELID, sign];
    NSLog(@"广告详情联合登陆接口：%@", url);
    return url;
}

#pragma mark - 获取抵用券列表
+ (NSString *)getVoucherListURLString:(NSString *)userId version:(NSString *)version type:(NSString *)type status:(NSString *)status page:(NSInteger)page count:(NSString *)count lQueryTime:(NSString *)lQueryTime {
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys: [self filter:userId], @"userId", [self filter:type], @"type", [self filter:status], @"status", [self filter:[NSString stringWithFormat:@"%ld", page]], @"page", [self filter:count], @"count", [self filter:lQueryTime], @"lquerytime", [self filter:version],@"version", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFaceIII(@"appvoucherList", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"抵用券列表接口：%@", urlString);
    return urlString;
}

#pragma mark - 绑定抵用券
+ (NSString *)getBindSpiderVoucherWithUserId:(NSString *)userId
                                  voucherNum:(NSString *)voucherNum {
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@%@", userId, voucherNum, SSAPI_KEY, SSAPI_SECRET_KEY]];
    NSString *url = [NSString stringWithFormat:@"%@/appbindVouchers.action?key=%@&userId=%@&voucherNum=%@&sign=%@", SERVER_ADDRESS, SSAPI_KEY, userId, voucherNum, sign];
    
    NSLog(@"绑定抵用券接口：%@", url);
    return url;
}

#pragma mark - 绑定蜘蛛卡
+ (NSString *)getBindSpiderCardWithUserId:(NSString *)userId
                                    zzkId:(NSString *)zzkId
                                  zzkPass:(NSString *)zzkPass {
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@%@%@", userId, zzkId, zzkPass, SSAPI_KEY, SSAPI_SECRET_KEY]];
    NSString *url = [NSString stringWithFormat:@"%@/appbindSpiderCard.action?key=%@&fileType=json&userId=%@&cardNum=%@&cardPassword=%@&sign=%@", SERVER_ADDRESS, SSAPI_KEY, userId, zzkId, zzkPass, sign];
    
    NSLog(@"绑定蜘蛛卡接口：%@", url);
    return url;
}

#pragma mark - 解绑蜘蛛卡
+ (NSString *)getUnbindSpiderCardWithUserId:(NSString *)userId cardNum:(NSString *)cardNum unbindTime:(NSString *)unbindTime {
    
    NSDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:cardNum], @"cardNum", [self filter:unbindTime], @"unbindTime", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFaceIII(@"appunbindSpiderCard", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"解绑蜘蛛卡接口：%@", urlString);
    return urlString;
}

#pragma mark - 我的积分
+ (NSString *)getMyPointsWithUserId:(NSString *)userId {
    
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@", userId, SSAPI_KEY, SSAPI_SECRET_KEY]];
    NSString *urlStr = [NSString stringWithFormat:@"%@/appmyPoints.action?userId=%@&fileType=json&version=v1.0.0&key=%@&sign=%@", SERVER_ADDRESS, userId, SSAPI_KEY, sign];
    
    NSLog(@"我的积分接口：%@", urlStr);
    return urlStr;
}


#pragma mark - 保存用户信息
+ (NSString *)saveUserInfoWithUserId:(NSString *)userId nickName:(NSString *)nickName sex:(NSString *)sex {
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:nickName], @"nickname", [self filter:sex], @"sex", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"saveUserInfo", sign);
    [paraDict setObject:[self encodeString:nickName num:1] forKey:@"nickname"];
    NSString *urlString = [self encodeString:[self getUrlWith:baseString parameters:paraDict] num:1];
    
    NSLog(@"保存用户信息接口：%@", urlString);
    return urlString;
}

#pragma mark - 意见反馈
+ (NSString *)getFeedBackWithUserId:(NSString *)userId
                            content:(NSString *)content
                               type:(NSString *)type
                            contact:(NSString *)contact {
    
    content = [[content componentsSeparatedByString:@"\n"] componentsJoinedByString:@""];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:content], @"content", [self filter:type], @"type", [self filter:contact], @"contact", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"feedBack", sign);
    [paraDict setObject:[self encodeString:content num:1] forKey:@"content"];
    [paraDict setObject:[self encodeString:type num:1] forKey:@"type"];
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];

    NSLog(@"意见反馈接口：%@", urlString);
    return urlString;
}


#pragma mark - 强制更新
+ (NSString *)getForceUpdate {
    
    
    NSString *key = @"apple";
    NSString *privateKey = @"0824549901";
    NSString *upgradeType = @"";
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@%@%@", APP_VERSION, upgradeType, @"spidersubscriber",key, privateKey]];
    //    http://192.168.1.140:8080/spiderticket/huayins/dataSource.html
//        NSString *strUrl = [NSString stringWithFormat:@"http://192.168.1.140:8080/spiderticket/apple/dataSource.html?curVersion=%@&upgradeType=%@&sign=%@&version=v4.3.0&key=apple&platform=spidersubscriber", APP_VERSION, upgradeType, [sign lowercaseString]];
    NSString *strUrl = [NSString stringWithFormat:@"http://film.spider.com.cn/apple/dataSource.html?curVersion=%@&upgradeType=%@&sign=%@&version=v4.3.0&key=apple&platform=spidersubscriber", APP_VERSION, upgradeType, [sign lowercaseString]];
    NSLog(@"版本强制更新接口: %@", strUrl);
    return strUrl;
}

#pragma mark - 广告列表
+ (NSString *)getAdvertisementList:(NSString *)modelId
                             count:(int)count
                              page:(int)page {

    NSString *sign = [self md5l:[NSString stringWithFormat:@"1%d%@%@%@",count, modelId,SSAPI_KEY,SSAPI_SECRET_KEY]];
    NSString *urlString = [NSString stringWithFormat:@"%@/appadvertisementList.action?fileType=json&modelId=%@&platformId=1&count=%d&page=%d&key=%@&sign=%@",SERVER_ADDRESS,modelId,count,page,SSAPI_KEY,sign];
    
    return urlString;
}

#pragma mark - 登录送积分
+ (NSString *)getLoginPoints:(NSString *)userId {
    NSString *sign = [self md5l:[NSString stringWithFormat:@"%@%@%@", userId, SSAPI_KEY, SSAPI_SECRET_KEY]];
    NSString *urlStr = [NSString stringWithFormat:@"%@/apploginPoints.action?fileType=json&version=v1.0.0&key=%@&sign=%@&userId=%@", SERVER_ADDRESS, SSAPI_KEY, sign, userId];
    
    NSLog(@"登录送积分：%@", urlStr);
    return urlStr;
}

#pragma mark - 评论
+ (NSString *)getCommentUrl:(NSString *)userId userName:(NSString *)userName type:(NSString *)type sid:(NSString *)sid orderId:(NSString *)orderId content:(NSString *)content level:(NSString *)level {
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:userName], @"userName", [self filter:type], @"type", [self filter:sid], @"id", [self filter:orderId], @"orderId", [self filter:content], @"content", [self filter:level], @"level", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseString = baseForInterFace(@"comment", sign);
    
    [paraDict setObject:[self filter:[self encodeString:content num:1]] forKey:@"content"];
    NSString *urlString = [self encodeString:[self getUrlWith:baseString parameters:paraDict] num:1];
    
    NSLog(@"评论接口：%@", urlString);
    return urlString;
}


#pragma mark - 注册环信账号
+ (NSString *)getRegisterImUserUrl:(NSString *)userId userSource:(NSString *)userSource {
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", [self filter:userSource], @"userSource", @"subscriber", @"source", nil];
    NSString *sign = [self getParameterSignII:paraDict];
    NSString *baseString = baseForInterFaceII(@"getIMUser", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"注册环信账号接口：%@", urlString);
    return urlString;
}

#pragma mark - 注册B端用户环信账号
+ (NSString *)getBIMUser:(NSString *)userId source:(NSString *)source {
    NSDictionary *parameters = @{@"userId":[self filter:userId], @"userSource":source, @"channelId":@"appStore", @"source":@"subscriber"};
    
    NSString *sign = [self getParameterSignII:parameters];
    NSString *baseUrl = baseForInterFaceII(@"getIMUser", sign);
    NSString *urlString = [self getUrlWith:baseUrl parameters:parameters];
    
    NSLog(@"注册B端用户环信账号接口：%@", urlString);
    return urlString;
}

#pragma mark - 添加环信好友
+ (NSString *)getAddFriendUrlWithImUserId:(NSString *)imUserId friendImUserId:(NSString *)friendImUserId {
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:imUserId], @"userId", [self filter:friendImUserId], @"friendUserId", @"subscriber", @"source", nil];
    NSString *sign = [self getParameterSignII:paraDict];
    NSString *baseString = baseForInterFaceII(@"addFriend", sign);
    NSString *urlString = [self getUrlWith:baseString parameters:paraDict];
    
    NSLog(@"添加环信好友接口：%@", urlString);
    return urlString;
}

#pragma mark - 获取好友列表
+ (NSString *)getFriends:(NSString *)IMuserId source:(NSString *)source  {
    NSDictionary *paraDict = @{@"imUserId":[self filter:IMuserId], @"userSource":source, @"channelId":@"appStore", @"source":@"subscriber"};
    
    NSString *sign = [self getParameterSignII:paraDict];
    NSString *baseUrl = baseForInterFaceII(@"getFriends", sign);
    NSString *urlString = [self getUrlWith:baseUrl parameters:paraDict];
    
    NSLog(@"获取好友列表接口：%@", urlString);
    return urlString;
}

#pragma mark - 订阅有礼分类列表
+ (NSString *)getGiftCategory {
    
    NSString *sign = [self getParameterSign:[NSDictionary dictionary]];
    NSString *baseUrl = baseForInterFace(@"getItemList", sign);
    NSString *urlString = [self getUrlWith:baseUrl parameters:nil];
    
    NSLog(@"订阅有礼分类列表接口：%@", urlString);
    return urlString;
}



#pragma mark - 获取反馈类型
+ (NSString *)getFeedBackTypesUrlWithUserId:(NSString *)userId {
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:[self filter:userId], @"userId", nil];
    NSString *sign = [self getParameterSign:paraDict];
    NSString *baseStr = baseForInterFace(@"feedBackTypes", sign);
    NSString *urlString = [self getUrlWith:baseStr parameters:paraDict];
    
    NSLog(@"获取反馈类型接口：%@", urlString);
    return urlString;
}
@end

