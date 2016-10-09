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
@interface SSPublicationInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *ssPaperId;           //刊物 id
@property (nonatomic, copy) NSString *ssSPaperId;           //子商品id
@property (nonatomic, copy) NSString *ssPType;          //商品类型（ts\zz\bz）
@property (nonatomic, copy) NSString* ssTitle;         //刊物名字
@property (nonatomic, copy) NSString *ssSlogan;      //广告语
@property (nonatomic, copy) NSString *ssAuthor;      //作者
@property (nonatomic, strong) NSArray *ssPictures;          //刊物图片数组
@property (nonatomic, copy) NSString *ssCollected;      //是否被收藏
@property (nonatomic, copy) NSString *ssPeriod;        //刊期
@property (nonatomic, copy) NSString *ssSpiderPrice;   //蜘蛛价
@property (nonatomic, copy) NSString *ssPrice;    //市场价
@property (nonatomic, copy) NSString *ssMaxP;   //最高价格
@property (nonatomic, copy) NSString *ssMinP;   //最低价格
@property (nonatomic, copy) NSString *ssStartDate;      //起订日期
@property (nonatomic, copy) NSString *ssEndDate;  //结束日期
@property (nonatomic, copy) NSString *ssHasGift;       //是否订阅送标识
@property (nonatomic, copy) NSString *ssStockStatus;      //剩余库存
@property (nonatomic, copy) NSString *ssOneFlag;        //
@property (nonatomic, copy) NSString *ssCartCount;      //购物车的数量
@property (nonatomic, copy) NSString *ssCategoryId;     //刊物所属的一级分类id
@property (nonatomic, copy) NSString *ssDDescription;  //配送费说明
@property (nonatomic, copy) NSString *ssRecommendation;  //推荐信息
@property (nonatomic, copy) NSString *ssRemark;  //备注信息
@property (nonatomic, copy) NSString *ssStoreName;  //店铺name
@property (nonatomic, copy) NSString *ssStoreId;  //店铺id
@property (nonatomic, copy) NSString *ssQuantity; //订阅数量
@property (nonatomic, copy) NSString *ssSuppliers;      //提供此刊物的供应商数量

@property (nonatomic, copy) NSString *ssDescription;    //刊物简介
@property (nonatomic, copy) NSString *ssContents;  //目录
@property (nonatomic, copy) NSString *ssNotice;  //订阅须知
//出版信息（报刊/杂志）bkmsg
@property (nonatomic, copy) NSString *ssZBDW;   //主办单位
@property (nonatomic, copy) NSString *ssChKRQ;   //创刊日期
@property (nonatomic, copy) NSString *ssBKType;  //刊物类别
@property (nonatomic, copy) NSString *ssCBZQ;  //出版周期
@property (nonatomic, copy) NSString *ssYFDH;  //邮发代号
@property (nonatomic, copy) NSString *ssCKRQ;  //出刊日期
@property (nonatomic, copy) NSString *ssFXL;  //发行量
@property (nonatomic, copy) NSString *ssGNTYKH;   //国内统一刊号
@property (nonatomic, copy) NSString *ssBJCB;    //编辑出版
//出版信息（图书）tsmsg
@property (nonatomic, copy) NSString *ssZZ;  //作者
@property (nonatomic, copy) NSString *ssTSBJCB;  //出版社
@property (nonatomic, copy) NSString *ssTSCBZQ;  //出版时间
@property (nonatomic, copy) NSString *ssISBN;   //isbn
@property (nonatomic, copy) NSString *ssCC;   //尺寸
@property (nonatomic, copy) NSString *ssYZ;    //印张
//订阅信息
@property (nonatomic, strong) NSArray *ssDates; //支持的起订日期
@property (nonatomic, strong) NSArray* ssDType;        //配送方式列表
@property (nonatomic, strong) NSArray *ssDProvinces;   //支持配送省份
@property (nonatomic, strong) NSArray* ssType;         //订阅类型及对应的价格
@property (nonatomic, strong) NSArray *ssActivitys;  //商品参加的活动
@property (nonatomic, strong) NSArray *ssGifts;   //礼品数组
@property (nonatomic, strong) SSStoreDeliveryInfo *ssStoreDeliveryInfo;  //商家配送信息
@property (nonatomic, strong) SSDeliveryStoreInfo *ssDeliveryStoreInfo;   //配送商家信息
@property (nonatomic, copy) NSString *ssPAmount;       //购物车中的单价
@property (nonatomic, copy) NSString* ssCityName;      //城市名称
@property (nonatomic, copy) NSString* ssShipmethod;      //城市名称

@property (nonatomic, copy) NSString *ssShipfee;       //配送费用
//@property (nonatomic, strong) NSArray* ssDate;         //订阅日期
@property (nonatomic, copy) NSString *ssCartId;        //如果是购物车里面的商品会有购物车id
@property (nonatomic, assign) BOOL isSelect;            //商品是否被选中（购物车中使用）
@property (nonatomic, assign) BOOL isEdit;              //商品是否编辑（购物车中使用）

@property (nonatomic, strong) SSActADInfo *ssActivityInfo;
@property (nonatomic, copy) NSString *ssGiftPic;
@property (nonatomic, assign) BOOL ssValid;     //是否失效（购物车中）
@property (nonatomic, copy) NSString *ssGiftId; //礼品id
@property (nonatomic, copy) NSString *ssDTypeId; //配送方式id
@property (nonatomic, copy) NSString *ssBookmarkId;  //收藏id
@property (nonatomic, copy) NSString *ssPicture;        //刊物单张图片
@property (nonatomic, copy) NSString *ssDyqs;  //刊期对应的数量
@property (nonatomic, copy) NSString *ssDTypeName;  //配送方式名称
@property (nonatomic, copy) NSString *ssGiftName;
@property (nonatomic, copy) NSString *ssPricePeriod;
@property (nonatomic, copy) NSString *ssOrderDetailId;        //订单项id

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

