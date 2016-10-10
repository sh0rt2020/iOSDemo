//
//  SSDatasInfo.m
//  SpiderSubscribe
//
//  Created by spider on 14/11/5.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import "SSDatasInfo.h"
#import "SSToolsMacros.h"
#import <objc/runtime.h>

@implementation SSDatasInfo

+ (id)initEntity{
    
    return [[SSDatasInfo alloc] init];
}

@end

// 错误信息
@implementation SSErrorInfo
- (id)init{
    self = [super init];
    
    if( self ){}
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    
    if (self = [super init])
    {
        self.message   = [coder decodeObjectForKey:@"_message"];
        self.errorCode = [coder decodeObjectForKey:@"_errorCode"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    
    [coder encodeObject:_message forKey:@"_message"];
    [coder encodeObject:_errorCode forKey:@"_errorCode"];
}

@end

#pragma mark - 礼品分类信息
@implementation SSCategoryInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"ssId":@"itemId",
             @"ssName":@"name",
             @"ssType":@"Type"};
}
@end

#pragma mark - 送礼的杂志信息
@implementation SSGiftPaperInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"ssPaperId":@"paperId",
             @"ssPicture":@"pictue",
             @"ssTitle":@"title",
             @"ssPrice":@"price",
             @"ssSpiderPrice":@"spiderPrice",
             @"ssPeriod":@"period",
             @"ssPricePeriod":@"pricePeriod",
             @"ssGiftFlag":@"giftflag",
             @"ssGifts":@"gifts"};
}

//对ssGiftFlag进行类型转换
+ (NSValueTransformer *)ssGiftFlagJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

//嵌套数组
+ (NSValueTransformer *)ssGiftsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *gifts, BOOL *success, NSError *__autoreleasing *error) {
        NSError *err = nil;
        return [MTLJSONAdapter modelsOfClass:SSGiftInfo.class fromJSONArray:gifts error:&err];
    }];
}
@end


#pragma mark - 礼品信息
@implementation SSGiftInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"ssGiftTitle":@"gifttitle",
             @"ssGiftPicture":@"giftpicture",
             @"ssGiftType":@"gifttype"};
}
@end
