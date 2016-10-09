//
//  SSUserInfo.h
//  SpiderSubscribe
//
//  Created by spider on 14/11/7.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSUserInfo : NSObject<NSCoding>

@property (nonatomic, copy) NSString *ssUserId ;    //用户 id
@property (nonatomic, copy) NSString *ssUserName;   //用户账户
@property (nonatomic, copy) NSString *ssUserName1; //昵称
@property (nonatomic, copy) NSString *ssImUserId;  //环信id
@property (nonatomic, copy) NSString *ssHeader;     //用户头像
@property (nonatomic, copy) NSString *ssHasPayPsd;      //是否设置支付密码 0=没设置 1=已设置
@property (nonatomic, copy) NSString *ssMobile;         //手机号
@property (nonatomic, copy) NSString *ssOrderPoints;  //积分
//@property (nonatomic, copy) NSString *isLogIn;  //记录用户是否登录 0=未登录 1=已登录
//@property (nonatomic, copy) NSString *isMobileVerify; //是否手机验证 y=已验证
+ (id)initEntity;

@end

//不需要序列化的部分
@interface SSSubUserInfo : NSObject

@property (nonatomic, copy) NSString *ssAttentNum;  //关注的店铺
@property (nonatomic, copy) NSString *ssCollectNum;  //收藏的商品
@property (nonatomic, copy) NSString *ssUserName; //用户名
@property (nonatomic, copy) NSString *ssMobile;  //手机号
@property (nonatomic, copy) NSString *ssVoucher;  //抵用券数量
@property (nonatomic, copy) NSString *ssBalance;  //蛛元余额
@property (nonatomic, copy) NSString *ssPartPay;  //部分支付
@property (nonatomic, copy) NSString *ssWaitPay;  //待支付
@property (nonatomic, copy) NSString *ssHeadUrl; //头像地址
@property (nonatomic, copy) NSString *ssMsgNum;  //消息数量
@property (nonatomic, copy) NSString *ssSpiderCard; //蜘蛛卡
@property (nonatomic, assign) BOOL hasPayPsd; //是否设置支付密码
@property (nonatomic, copy) NSString *ssPoints; //积分
@property (nonatomic, copy) NSString *ssLevel; //会员等级标题
@property (nonatomic, copy) NSString *ssLevelCode;  //会员等级标识 n=普通会员 g=黄金会员 w=白金会员 d=钻石会员
@property (nonatomic, copy) NSString *ssNickName;  //昵称
@property (nonatomic, copy) NSString *ssSex; //性别 m=男 f=女
@end

@interface SSSpiderCard : NSObject

@property (nonatomic, copy) NSString *ssSpiderCardNumber;  //卡号
@property (nonatomic, copy) NSString *ssAmount;  //余额
@end

@interface SSVoucher : NSObject

@property (nonatomic, copy) NSString *ssOucherNumber;  //券号
@property (nonatomic, copy) NSString *ssAmount; //余额
@end

