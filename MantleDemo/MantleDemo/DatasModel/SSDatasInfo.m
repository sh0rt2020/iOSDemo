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

#pragma mark - MantleDemo
@implementation SSCategoryInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"ssId":@"itemId",
             @"ssName":@"name",
             @"ssType":@"Type"};
}

@end

//杂志
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

//+ (NSValueTransformer *)ssGiftsJSONTransformer {
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *gifts, BOOL *success, NSError *__autoreleasing *error) {
//        return <#expression#>
//    }];
//}
@end


//订阅送礼品
@implementation SSGiftInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"ssGiftTitle":@"gifttitle",
             @"ssGiftPicture":@"giftpicture",
             @"ssGiftType":@"gifttype"};
}


+ (NSValueTransformer *)ssGiftTitleJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *gifts, BOOL *success, NSError *__autoreleasing *error) {
        return [gifts.firstObject valueForKey:@"gifttitle"];
    }];
}

+ (NSValueTransformer *)ssGiftPictureJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *gifts, BOOL *success, NSError *__autoreleasing *error) {
        return [gifts.firstObject valueForKey:@"giftpicture"];
    }];
}

+ (NSValueTransformer *)ssGiftTypeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *gifts, BOOL *success, NSError *__autoreleasing *error) {
        return [gifts.firstObject valueForKey:@"gifttype"];
    }];
}
@end
