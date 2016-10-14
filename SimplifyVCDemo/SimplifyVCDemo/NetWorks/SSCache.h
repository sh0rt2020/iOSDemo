//
//  SRCache.h
//  SpiderReader
//
//  Created by spider on 14-07-11.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SSCache : NSObject{

    NSOperationQueue* diskOperationQueue;
}
/*
 单例模式
 */
+(SSCache *)sharedCache;

/*
 清空缓存
 */
- (void)clearCache;

/*
 删除缓存
 */
- (void)removeCacheForKey:(NSString*)key;

/*
 判断是否有缓存
 */
- (BOOL)hasCacheForKey:(NSString*)key;

/*
 获取缓存
 */
- (NSArray *)arrayForKey:(NSString *)key;
- (NSData*)dataForKey:(NSString*)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;

/*
 保存缓存
 */
- (void)setArr:(NSArray *)arr forKey:(NSString *)key;
- (void)setData:(NSData*)data forKey:(NSString*)key;
- (void)setNSDictionary:(NSDictionary *)_data forKey:(NSString*)key;

- (UIImage*)imageForKey:(NSString*)key;
- (void)setImage:(UIImage*)anImage forKey:(NSString*)key;

/*
 获取缓存列表
 */
-(NSArray *)getAllCacheList;

/*
 获取缓存大小
 */
//- (float)checkTmpSize:(NSString*)key;
/*
 获取缓存URLString
 常常在网络连接中使用
 */
-(NSString *)getCacheUrlStr:(NSString *)key;
@end
