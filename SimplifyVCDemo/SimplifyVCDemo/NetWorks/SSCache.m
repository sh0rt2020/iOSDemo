//
//  SSCache.m
//  SpiderReader
//
//  Created by spider on 14-07-11.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import "SSCache.h"

static NSString* _SSCacheDirectory;

inline static NSString* keyForURL(NSString* url, NSString* style) {
    
    NSString *keyString = @"";
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        if(style) {
            return [NSString stringWithFormat:@"SSCache-%lu-%lu", (unsigned long)[[url description] hash], (unsigned long)[style hash]];
        } else {
            NSLog(@"%lu", [[url description] hash]);
            return [NSString stringWithFormat:@"SSCache-%lu", (unsigned long)[[url description] hash]];
        }
    }else{
        keyString = url;
        
        return keyString;
    }
}

static inline NSString* SSCacheDirectory() {
	if(!_SSCacheDirectory) {
		NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		_SSCacheDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"SSCache"] copy];
	}
	return _SSCacheDirectory;
}

static inline NSString* cachePathForKey(NSString* key) {
	return [SSCacheDirectory() stringByAppendingPathComponent:keyForURL(key, nil)];
}

static SSCache* _instance;

@interface SSCache ()
- (void)removeItemFromCache:(NSString*)key;
- (void)performDiskWriteOperation:(NSInvocation *)invoction;
@end

@implementation SSCache

/*
 单例模式
 */
+(SSCache *)sharedCache{

    @synchronized(self) {
		if(!_instance) {
			_instance = [[SSCache alloc] init];
		}
	}
	return _instance;
}

- (id)init {
    
	if((self = [super init])) {
        
        diskOperationQueue = [[NSOperationQueue alloc] init];
        [diskOperationQueue setMaxConcurrentOperationCount:2];
		[[NSFileManager defaultManager] createDirectoryAtPath:SSCacheDirectory()
								  withIntermediateDirectories:YES 
												   attributes:nil 
														error:NULL];
	}
	
	return self;
}

/*
 清空缓存
 */
- (void)clearCache
{
    NSError *error=nil;
    // 创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr removeItemAtPath:SSCacheDirectory() error:&error] != YES){
    
         NSLog(@"清空失败!");
    }
}

/*
  删除缓存
  */
- (void)removeCacheForKey:(NSString*)key
{
    if ([self hasCacheForKey:key]) {
        [self removeItemFromCache:key];
    }
}

/*
 判断是否有缓存
 */
- (BOOL)hasCacheForKey:(NSString*)key
{
	return [[NSFileManager defaultManager] fileExistsAtPath:cachePathForKey(key)];
}

/*
 获取数组缓存
 */
- (NSArray *)arrayForKey:(NSString *)key{

    if ([self hasCacheForKey:key]) {
    
        NSArray *cachArr=[[NSArray alloc]initWithContentsOfFile:cachePathForKey(key)];
        if (!cachArr) {
            return nil;
        }
        return cachArr;
    }
    return nil;
}

/*
 获取字节缓存
 */
- (NSData*)dataForKey:(NSString*)key{
    
    if ([self hasCacheForKey:key]) {
     NSError *error=nil;
        NSData *cachData=[[NSData alloc]initWithContentsOfFile:cachePathForKey(key) options:NSDataReadingMappedIfSafe error:&error];
        if (error) {
            NSLog(@"获取失败%@",[error debugDescription]);  
        }
        return cachData ;
    }
    return nil;
}

/*
 获取字典缓存
 */
- (NSDictionary *)dictionaryForKey:(NSString *)key
{
    if ([self hasCacheForKey:key]) {
        NSDictionary *dict=[[NSDictionary alloc]initWithContentsOfFile:cachePathForKey(key)];
        if (dict) {
            return dict;
        }
    }
    return nil;
}

/*
 保存数组缓存
 */
- (void)setArr:(NSArray *)arr forKey:(NSString *)key
{
    NSString* cachePath = cachePathForKey(key);
	NSInvocation* writeInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(writeData:toPath:)]];
	[writeInvocation setTarget:self];
	[writeInvocation setSelector:@selector(writeData:toPath:)];
	[writeInvocation setArgument:&arr atIndex:2];
	[writeInvocation setArgument:&cachePath atIndex:3];
	
	[self performDiskWriteOperation:writeInvocation];
}

/*
 保存字节缓存
 */
- (void)setData:(NSData*)data forKey:(NSString*)key{
    
    NSString* cachePath = cachePathForKey(key);
	NSInvocation* writeInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(writeData:toPath:)]];
	[writeInvocation setTarget:self];
	[writeInvocation setSelector:@selector(writeData:toPath:)];
	[writeInvocation setArgument:&data atIndex:2];
	[writeInvocation setArgument:&cachePath atIndex:3];
	
	[self performDiskWriteOperation:writeInvocation];
}

/*
 保存字典缓存
 */
- (void)setNSDictionary:(NSDictionary *)_data forKey:(NSString*)key{

     NSString* cachePath = cachePathForKey(key);
     NSInvocation* writeInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(writeData:toPath:)]];
    [writeInvocation setTarget:self];
	[writeInvocation setSelector:@selector(writeData:toPath:)];
	[writeInvocation setArgument:&_data atIndex:2];
	[writeInvocation setArgument:&cachePath atIndex:3];
	
	[self performDiskWriteOperation:writeInvocation];

}

- (UIImage*)imageForKey:(NSString*)key {
	return [UIImage imageWithContentsOfFile:cachePathForKey(key)];
}

- (void)setImage:(UIImage*)anImage forKey:(NSString*)key{
	[self setData:UIImagePNGRepresentation(anImage) forKey:key];
}

/*
 获取缓存列表
 */
-(NSArray *)getAllCacheList{
    NSFileManager *fileManager = [NSFileManager defaultManager];   
    NSArray *files = [fileManager subpathsAtPath: SSCacheDirectory()];
    return  files;
}

/*
 获取缓存URL
 */
-(NSString *)getCacheUrlStr:(NSString *)key{

    if ([self hasCacheForKey:key]) {
        
        return cachePathForKey(key);
    }
    return @"";
}
/*
 获取缓存大小
 */
//- (float)checkTmpSize:(NSString*)key {
////    float totalSize = 0;
////    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:cachePathForKey(key)];
////    for (NSString *fileName in fileEnumerator) {
////        NSString *filePath = [(NSString*)key stringByAppendingPathComponent:fileName];
////        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
////        unsigned long long length = [attrs fileSize];
////        totalSize += length / 1024.0 / 1024.0;
//    } // NSLog(@"tmp size is %.2f",totalSize); return totalSize;
//    return totalSize;
//}


#pragma mark -
- (void)writeData:(NSData*)data toPath:(NSString *)path; {
    
    if (![data writeToFile:path atomically:YES]) {
    
        NSLog(@"保存失败%@",path);
    }
} 

- (void)deleteDataAtPath:(NSString *)path {
    NSError *error=nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
        NSLog(@"%@删除失败:%@",path,[error description]);
    }
}

- (void)removeItemFromCache:(NSString*)key {
	NSString* cachePath = cachePathForKey(key);
	
	NSInvocation* deleteInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(deleteDataAtPath:)]];
	[deleteInvocation setTarget:self];
	[deleteInvocation setSelector:@selector(deleteDataAtPath:)];
	[deleteInvocation setArgument:&cachePath atIndex:2];
	[self performDiskWriteOperation:deleteInvocation];
}

#pragma mark -
#pragma mark Disk writing operations
- (void)performDiskWriteOperation:(NSInvocation *)invoction {
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invoction];
	[diskOperationQueue addOperation:operation];
}

@end
