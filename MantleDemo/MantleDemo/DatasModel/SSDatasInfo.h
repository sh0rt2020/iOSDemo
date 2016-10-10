//
//  SSDatasInfo.h
//  SpiderSubscribe
//
//  Created by spider on 14/11/5.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Mantle/Mantle.h>


@interface SSDatasInfo : NSObject

@property (nonatomic) int   status;//状态
@property (nonatomic, copy) NSString *msg;//状态信息

+ (id)initEntity;

@end

@interface SSErrorInfo : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *errorCode;

@end

#pragma mark - MantleDemo  礼品列表分类数据
@interface SSCategoryInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *ssId;  //分类id
@property (nonatomic, copy) NSString *ssName;  //分类名字
@property (nonatomic, copy) NSString *ssType;  //分类标识

@end


#pragma mark - MantleDemo 礼品列表数据
@interface SSGiftPaperInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *ssPaperId;  //刊物id
@property (nonatomic, copy) NSString *ssPicture;  //刊物图片
@property (nonatomic, copy) NSString *ssTitle;    //刊物名字
@property (nonatomic, copy) NSString *ssPrice;  //市场价
@property (nonatomic, copy) NSString *ssSpiderPrice;  //蜘蛛价
@property (nonatomic, copy) NSString *ssPeriod;  //期数
@property (nonatomic, copy) NSString *ssPricePeriod;  //定期对应的价格
@property (nonatomic) BOOL ssGiftFlag;  //是否有礼品
@property (nonatomic) NSArray *ssGifts;  //礼品数组
@end

#pragma mark - MantleDemo 礼品信息
@interface SSGiftInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *ssGiftTitle;       //礼品名称
@property (nonatomic, copy) NSString *ssGiftPicture;    //礼品图片
@property (nonatomic, copy) NSString *ssGiftType;  //礼品对应的定期
@end

