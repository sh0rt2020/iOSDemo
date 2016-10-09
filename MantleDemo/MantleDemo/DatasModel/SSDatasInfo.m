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


//活动
@implementation SSActADInfo

@end

#pragma mark - 榜单

@implementation SSListInfo

@end
#pragma mark - 首页分类

@implementation SSHomeClassInfo

@end

#pragma mark - 首页分类

@implementation SSStoreInfo

@end

//杂志
@implementation SSPublicationInfo

+ (id)initEntity{
    
   return [[SSPublicationInfo alloc] init];
}



#pragma mark -- 为什么数组要初始化而别的不初始化
- (id)init{
    self = [super init];
    
    if( self ){
//        _ssDType = [[NSArray alloc] init];
//        _ssDate = [[NSArray alloc] init];
        _ssDProvinces = [[NSArray alloc] init];
        _ssType = [[NSArray alloc] init];
    }
    
    return self;
}

@end


#pragma mark - 热门专题
@implementation SSSpecialInfo

+ (id)initEntity {
    return [[SSSpecialInfo alloc] init];
}

@end

//// 分类
//
//@implementation SSCategoryInfo
//
//+ (id)initEntity{
//    
//    return [[SSCategoryInfo alloc] init];
//}
//
//@end

#pragma mark - MantleDemo
@implementation SSCategoryInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"ssId":@"itemId",
             @"ssName":@"name",
             @"ssType":@"Type"};
}

@end

// 优惠
@implementation SSPaperPrivileqeInfo

@end


//
///*
// * 省
// */
//
//
//@implementation SSProvinceCityInfo
//
//+ (id)initEntity{
//    
//    return [[SSProvinceCityInfo alloc] init];
//}
//
//- (id)init{
//    self = [super init];
//    
//    if( self ){
//    }
//    
//    return self;
//}
//
//- (id)initWithCoder:(NSCoder *)coder{
//    if (self = [super init]){
//        
//        self.ssId = [coder decodeObjectForKey:@"_ssProvinceCode"];
//        self.ssName = [coder decodeObjectForKey:@"_ssProvinceName"];
//    }
//    
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)coder{
//    
//    [coder encodeObject:_ssId forKey:@"_ssProvinceCode"];
//    [coder encodeObject:_ssName forKey:@"_ssProvinceName"];
//}
//
//@end

/*
 * 订阅信息
 */
@implementation SSSubscribeInfo

+ (id)initEntity{
    
    return [[SSSubscribeInfo alloc] init];
}

- (id)init{
    self = [super init];
    
    if( self ){
    }
    
    return self;
}
@end


/*
 * 收货地址
 */

@implementation SSAddressInfo

//+ (id)initEntity{
//    
//    return [[SSAddressInfo alloc] init];
//}

- (id)init{
    self = [super init];
    if( self ){
    }
    return self;
}

@end
/*================================================= 改变实体类赋值方法=================================*/

@implementation SSBaseModel

+ (id)initEntity{
    
    return [[[self class] alloc] init];
}

- (id)init{
    self = [super init];
    if( self ){
    }
    return self;
}
@end


//发票信息
@implementation SSInvoiceInfo

@end


//收件人信息
@implementation SSReceiverInfo

@end

//订阅信息
@implementation SSOrderSubInfo

@end

//订单详情
@implementation SSOrderDetailInfo

@end


//抵用券
@implementation SSVoucherInfo

@end


//蜘蛛卡
@implementation SSCardInfo

@end

//抵用券列表
@implementation SSVoucherListInfo

@end

//首页
@implementation SSHomeInfo

@end

//首页
@implementation SSHomeADInfo

@end

//配送方式
@implementation SSDistributionInfo

@end

//配送省份对应的配送列表
@implementation SSProvinceTypeInfo

@end

//订阅送礼品
@implementation SSGiftInfo

@end

//生成订单信息
@implementation SSCreatOrderInfo

@end

//珠元
@implementation SSSpiderYuanInfo


@end

//订单支付
@implementation SSOrderPayInfo

@end

//订单状态
@implementation SSOrderStatusInfo

@end


//订单支付状态
@implementation SSOrderPayStatusInfo

@end

//支付方式
@implementation SSPayTypeInfo

@end

//明细
@implementation SSParticularsInfo

@end

//账户
@implementation SSAccountInfo

@end

//版本
@implementation SSVersionInfo

@end

/**
 *  我的积分
 */
@implementation SSMyPointsInfo

@end


/**
 *  积分记录
 */
@implementation SSPointRecordInfo
@end

#pragma mark - 商家配送信息
@implementation SSStoreDeliveryInfo
@end

#pragma mark - 配送商家信息
@implementation  SSDeliveryStoreInfo
@end

//搜索配置
@implementation SSSearchConditionInfo

@end

//评价信息
@implementation SSCommentInfo

@end

#pragma mark - 订单确认页-店铺信息
@implementation SSSubStoreInfo
@end

@implementation SSShipInfo
@end

@implementation SSIogisticsInfo
@end

@implementation SSIogisticsTypeInfo

@end

@implementation SSMyMessage
@end

#pragma mark - 聊天消息
@implementation SSChatListInfo
@end

#pragma mark - 环信好友
@implementation SSFriendInfo
@end

