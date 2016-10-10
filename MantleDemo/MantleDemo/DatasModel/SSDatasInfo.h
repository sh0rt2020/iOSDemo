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


#pragma mark - MantleDemo 活动数据
@interface SSActADInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *ssDes;  //活动描述
@property (nonatomic, copy) NSString *ssType;      //活动类型
@property (nonatomic, copy) NSString *ssName;      //活动名字
@property (nonatomic, copy) NSString *ssUrl; //活动链接
@property (nonatomic, copy) NSString *ssEndTime;   //活动结束时间
@property (nonatomic, copy) NSString *ssBeginTime; //活动开始时间
@property (nonatomic, copy) NSString *ssDetail;
@property (nonatomic, copy) NSString *ssPicture;        //图片
@property (nonatomic, copy) NSString *ssID;         //id

@end

#pragma mark - MantleDemo 商家配送信息
@interface SSStoreDeliveryInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *ssStoreId;   //书报亭编号
@property (nonatomic, copy) NSString *ssStoreName;  //书报亭名称
@property (nonatomic, copy) NSString *ssDistance;   //距离
@property (nonatomic, copy) NSString *ssSupplierCount;   //刊物供应商数量

@end

#pragma mark - MantleDemo 配送商家信息
@interface SSDeliveryStoreInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *ssStoreId;   //书报亭编号
@property (nonatomic, copy) NSString *ssStoreName;  //书报亭名称
@property (nonatomic, copy) NSString *ssFansCount;   //粉丝数
@property (nonatomic, copy) NSString *ssLevel;   //评价等级
@property (nonatomic, copy) NSString *ssNewCount;   //新刊物数量
@property (nonatomic, copy) NSString *ssSalesCount;   //促销刊物数量

@end


#pragma mark - MantleDemo 礼品列表数据
@interface SSGiftPaperInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *ssPaperId;  //刊物id
@property (nonatomic, copy) NSString *ssPicture;  //刊物图片
@property (nonatomic, copy) NSString *ssTitle;    //刊物名字
@property (nonatomic, copy) NSString *ssPrice;  //市场价
@property (nonatomic, copy) NSString *ssSpiderPrice;  //

@end


#pragma mark - MantleDemo  礼品列表分类数据
@interface SSCategoryInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *ssId;  //分类id
@property (nonatomic, copy) NSString *ssName;  //分类名字
@property (nonatomic, copy) NSString *ssType;  //分类标识

@end

#pragma mark - MantleDemo 礼品信息
@interface SSGiftInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *ssGiftId;     //礼品id
@property (nonatomic, copy) NSString *ssName;       //礼品名称
@property (nonatomic, copy) NSString *ssPicture;    //礼品图片
@property (nonatomic, copy) NSString *ssPeroid;     //礼品订期
@property (nonatomic, copy) NSString *ssStockNum;   //礼品库存数量
@property (nonatomic, copy) NSString *ssDeliverarea;   //礼品支持的城市

@end

