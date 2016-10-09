//
//  SSUrlAPI.h
//  SpiderSubscriber
//
//  Created by royal on 14/12/9.
//  Copyright (c) 2014年 spider. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SSInterFace.h"
#import "SSToolsClass.h"


@interface SSUrlAPI : NSObject

#pragma mark - 首页接口（搜索热词、榜单说明、分类推荐、好店推荐）
/**
 *  首页 （搜索热词、榜单说明、分类推荐、好店推荐）
 *
 *  @param provinceCode 省份
 *  @param longtitude   经度
 *  @param latitude     维度
 *
 *  @return 接口
 */
+ (NSString *)getHomeDataWith:(NSString *)provinceCode longtitude:(NSString *)longtitude latitude:(NSString *)latitude;

#pragma mark - 首页（活动信息，头尾广告）
/**
 *  首页（活动信息，头尾广告）
 *
 */
+ (NSString *)getHomeActivityAndADInfo;

#pragma mark - 店铺基本信息
/**
 *  店铺基本信息
 *
 *  @return 接口
 */
+ (NSString *)getStoreInfoWith:(NSString *)storeId;

#pragma mark - 店铺刊物(搜索)列表
/**
 *  店铺刊物(搜索)列表
 *  ptype =0 报纸；ptype =1； ptype 2图书 不传为所有 sortType 排序方式c:综合 pa:价格由低到高 pd:价格由高到低 sd:销量由高到低（客户端写死） z:最新上架 r:热销商品 不传此参数为全部商品
 
 *  @return 接口
 */
+ (NSString *)getStorePaperListWith:(NSString *)storeId page:(int)page filter:(NSDictionary *)filter ptype:(NSString *)ptype sortType:(NSString *)sortType;

#pragma mark -  店铺评论列表
/**
 *  店铺评论列表
 *
 *  @param sotreId 店铺id
 *
 *  @return 接口
 */
+ (NSString *)getStoreCommentListWith:(NSString *)storeId;

#pragma mark - 获取分类列表
/**
 *  获取分类列表
 * bz 报纸；ptype =zz 杂志 ;图书 ts
 *  @return 接口
 */
+ (NSString *)getCategoryList:(NSString *)type;

#pragma mark - 获取刊物（搜索）列表
/**
 *  获取刊物列表
 *  @return 接口
 */
+ (NSString *)getPaperList:(NSString *)catalogId page:(int)page ptype:(NSString *)ptype sortType:(NSString *)sortType filter:(NSDictionary *)filter;

#pragma mark - 杂志榜单
/**
 *  杂志榜单
 *  @return 接口
 */
+ (NSString *)getMagazineList:(NSString *)catalogId page:(int)page distamce:(NSString *)distamce sortType:(NSString *)sortType;

#pragma mark - 搜索配置（商品和店铺的筛选条件）
/**
 *  搜索配置（商品和店铺的筛选条件）
 *
 */
+ (NSString *)getSearchConfiguration;

#pragma mark - 店铺配置条件
/**
 *  店铺配置条件
 *
 */
+ (NSString *)getStoreConfiguration:(NSString *)storeId;

#pragma mark - 所有市列表
/*
 需提供参数：
 
 返回参数：urlString
 */
+ (NSString *)getAllCityURLString;

#pragma mark - 省列表
/*
 需提供参数：无
 返回参数：urlString
 */
+ (NSString *)getProvincesURLString;

#pragma mark - 城市列表
/*
 需提供参数：
 provinceId: 省份 id
 
 返回参数：urlString
 */
+ (NSString *)getCityURLString:(NSString *)provinceId;

#pragma mark - 区列表
/*
 需提供参数：
 provinceId: 省份 id
 cityId: 市份 id
 
 返回参数：urlString
 */
+ (NSString *)getAreaURLString:(NSString *)provinceId city:(NSString *)cityId;

#pragma mark - 报刊/杂志/图书
/**
 *  需要提供的参数
 *
 *  @param paperId    商品id
 *  @param cityName   城市名（汉字）
 *  @param longtitude 经度
 *  @param latitude   纬度
 *  @param shopId     店铺id
 *  @param userId     用户id
  *  @param type     0=店铺 1=零售
 *  @return urlString
 */
+ (NSString *)getItemDetailUrlString:(NSString *)paperId mainId:(NSString *)mainId cityName:(NSString *)cityName longtitude:(NSString *)longtitude latitude:(NSString *)latitude shopId:(NSString *)shopId userId:(NSString *)userId type:(NSString*)type;

#pragma mark - 登录接口
/*
 需提供参数：
 username: 用户名/手机号
 password: 密码
 verifyCode: 验证码
 channel:渠号
 返回参数：urlString
 */
+ (NSString *)getLoginURLString:(NSString *)username
                       password:(NSString *)password
                     verifyCode:(NSString *)verifyCode
                        channel:(NSString*)channel;




#pragma mark - 第三方登录
/*
 需提供参数：
 thirdSource: 第三方来源，tencent/weibo/alipay/weixin
 username: 登录返回的唯一用户编码
 alias: 昵称
 token: 仅支付宝
 
 返回参数：urlString
 */
+ (NSString *)getLoginURLString:(NSString *)thirdSource
                       username:(NSString *)username
                          alias:(NSString *)alias
                          token:(NSString *)token;

#pragma mark - 获取支付宝加密登录
+ (NSString *)getAliPayLoginUrlString;

#pragma mark - 注册
/*
 需提供参数：
 mobile: 手机号
 password: 密码
 verifyCode: 验证码
 channel:渠道号
 返回参数：urlString
 */
+ (NSString *)getRegisterURLString:(NSString *)mobile
                          password:(NSString *)password
                        verifyCode:(NSString *)verifyCode
                         channel:(NSString*)channel;




#pragma mark - 发送手机验证码
/*
 需提供参数：
 mobile: 手机号
 module:0=登录、注册、绑定手机号  1=申请开店  2=重置密码
 返回参数：urlString
 */
+ (NSString *)getPhoneVerifyCodeURLString:(NSString *)mobile module:(NSString *)module;

#pragma mark - 找回登录密码
/*
 需提供参数：
 userId: 用户编号
 mobile: 手机号
 verifyCode: 验证码
 oldPassword: 旧密码
 newPassword: 新密码
 
 返回参数： urlString
 */
+ (NSString *)getResetPasswordURLString:(NSString *)mobile
                             verifyCode:(NSString *)verifyCode
                               password:(NSString *)password;

#pragma mark - 加入购物车
/*
 需提供参数：
 userId: 用户 id
   item: 商品实体
 order:是否为立即购买（0是，非0否）
 */
+ (NSString *)getAddCartURLString:(NSString *)userId
                             item:(SSPublicationInfo *)item
                         orderNow:(NSString *)orderNow;

#pragma mark - 收藏
/**
 *  @param userId   用户id
 *  @param targetId 收藏目标id（刊物id、店铺id）
 *  @param type     0=刊物 1=店铺
 */
+ (NSString *)getBookmarkPaperWithUserId:(NSString *)userId
                                targetId:(NSString *)targetId
                                    type:(NSString *)type;

#pragma mark - 取消收藏
/**
 *  @param userId     用户id
 *  @param bookmarkId 收藏id  type     0=刊物 1=店铺
 */
+ (NSString *)getCancelBoookmarkPaperWithUserId:(NSString *)userId
                                    bookmarkId:(NSString *)bookmarkId
                                           type:(NSString *)type;

#pragma mark - 购物车列表
/**
 *  购物车列表
 *
 *  @return 接口
 */
+ (NSString *)getShoppingCartURLString:(NSString *)userId city:(NSString *)city longtitude:(NSString *)longtitude latitude:(NSString *)latitude;

#pragma mark - 获取订单列表
/**
 *  @param status     =0 全部 =1待支付 =2 部分支付 =3 已支付 =4 待评价，5-已完成， 6-已取消
 *  @param userId     用户id
 *  @param page       页码
 *  @param count      页面数据容量
 *  @param lQueryTime 上次查询时间
 *
 *  @return urlString
 */
+ (NSString *)getOrderListWithStatus:(NSString *)status
                              userId:(NSString *)userId
                                page:(NSString *)page
                               count:(NSString *)count
                          lQueryTime:(NSString *)lQueryTime;
#pragma mark - 获取订单详情
/**
 *  获取订单详情
 *
 *  @param userId  用户id
 *  @param orderId 订单id
 *
 *  @return 接口
 */
+ (NSString *)getOrderDetailWithUserId:(NSString *)userId
                               orderId:(NSString *)orderId
                         orderdetailId:(NSString *)orderdetailId;

#pragma mark - 获取支付成功订单的所有支付方式
/**
 *  获取订单详情
 *
 *  @param orderId 订单id
 *
 *  @return 接口
 */
+ (NSString *)getOrderPayTypesWithorderId:(NSString *)orderId userId:(NSString *)userId;
#pragma mark - 获取物流信息
/**
 *  获取物流信息
 *
 *  @param userId        用户id
 *  @param orderId       订单id
 *  @param orderdetailId 订单项id
 *
 *  @return 接口
 */
+ (NSString *)getShiplistWithUserId:(NSString *)userId
                               orderId:(NSString *)orderId
                         orderdetailId:(NSString *)orderdetailId;

#pragma mark - 删除购物车
/**
 *  删除购物车
 *
 *  @param cartId 购物车id 多个用|分割
 *
 *  @return 接口
 */
+ (NSString *)getDeletShopCart:(NSString *)cartId userId:(NSString *)userId;

#pragma mark - 清空购物车
/**
 *  清空购物车
 *
 *  @param userId 用户id
 *
 *  @return 接口
 */
+ (NSString *)getClearCart:(NSString *)userId;

#pragma mark - 修改购物车
/**
 *  修改购物车
 *
 *  @param userId 用户id
 *  @param item   购物车对象
 *
 *  @return 接口
 */
+ (NSString *)getChangeCartURLString:(NSString *)userId item:(SSPublicationInfo *)item;

#pragma mark - 修改购物车中的商品数量
/**
 *  修改购物车中的商品数量
 *
 *  @param userId 用户id
 *
 *  @return 接口
 */
+ (NSString *)getChangeCartURLString:(NSString *)userId cartId:(NSString *)cartIt cartNum:(NSString*)cartNum;

#pragma mark - 修改购物车中配送省份
/**
 *  修改购物车中的配送省份
 *
 *  @param userId 用户id
 *
 *  @return 接口
 */
+ (NSString *)getUpdateCityNameURLString:(NSString *)userId cityName:(NSString *)cityName;

#pragma mark - 修改购物车中图书模板商品的配送方式
/**
 *  修改购物车中图书模板商品的配送方式
 *
 *  @param userId 用户id
 *
 *  @return 接口
 */
+ (NSString *)getUpdateCartDTypeURLString:(NSString *)userId cartId:(NSString *)cartId dType:(NSString *)dType shopId:(NSString *)shopId;

#pragma mark - 账号信息
/**
 *  @param userId 用户id
 */
+ (NSString *)getUserInfoURLString:(NSString *)userId;

#pragma mark - 供应商列表
/**
 *  @param paperId    商品id
 *  @param province   省份名
 *  @param cityName  城市名
 *  @param longtitude 经度
 *  @param latitude   纬度
 *  @param page       页码
 *  @param count      每页容量
 *  @param filter     筛选条件
 */
+ (NSString *)getSupplierListURLString:(NSString *)paperId province:(NSString *)province city:(NSString *)cityName longtitude:(NSString *)longtitude latitude:(NSString *)latitude page:(NSString *)page count:(NSString *)count filter:(NSDictionary *)filter  psType:(NSString*)psType;


#pragma mark - 生成订单信息
/**
 *  @param userId        用户id
 *  @param carts         购物车实例数组
 *  @param addressId     地址编号
 *  @param channel       渠道号
*/
#pragma mark - 生成订单信息
+ (NSString *)getGenerateOrderInfoWith:(NSString *)userId
                             cartItems:(NSArray *)cartItems
                                  city:(NSString *)city
                                region:(NSString *)region
                                street:(NSString *)street
                              adressId:(NSString *)addressId ;

#pragma mark - 提交订单
/**
 *  @param userId        用户id
 *  @param carts         购物车
 *  @param addressId     地址编号
 *  @param cityName      城市名
 *  @param invoice       发票
 *  @param remark        备注
 */
+ (NSString *)getCreateOrderWith:(NSString *)userId
                      cartsItems:(NSArray *)carts
                       addressId:(NSString *)addressId
                        cityName:(NSString *)cityName
                    payAddressId:(NSString *)payAddressId
                         channel:(NSString*)channel;

#pragma mark - 杂志零售列表
/**
 *  @param categoryId 分类id
 *  @param page       页码
 */
+ (NSString *)getRetailListWithcategoryId:(NSString *)categoryId
                                  page:(NSString *)page
                               longtitude:(NSString *)longtitude
                                 latitude:(NSString *)latitude;

#pragma mark - 图书榜单列表
/**
 *  图书榜单列表
 *
 */
+ (NSString *)getBookRankListWithRankId:(NSString *)rankId
                                     page:(int)page
                             longtitude:(NSString *)longtitude
                               latitude:(NSString *)latitude;

#pragma mark - 专题首页列表
+ (NSString *)getSpecialTopicList;

#pragma mark - 专题详情列表
/**
 *  @param topicId 分类id
 *  @param page    页码
 *  @param count   容量
 */
+ (NSString *)getSpecialTopicPaperListWithSpecialTopicId:(NSString *)topicId page:(int)page longtitude:(NSString *)longtitude
                                                latitude:(NSString *)latitude;

#pragma mark - 订阅有礼列表
/**
 *  @param itemId 分类id
 *  @param page       页码
 *  @param count      容量
 */
+ (NSString *)getGiftListURLWithItemId:(NSString *)itemId page:(int)page count:(NSString *)count;

#pragma mark - 首页抢购活动接口
+ (NSString *)getSnapupList;

#pragma mark - 收货地址列表
+ (NSString *)getAddressList:(NSString *)userId
                    defaultA:(NSString *)def;

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
                             isDefault:(NSString *)isDefault;

#pragma mark - 新增收货地址
/*
 需提供参数：
 userId: 用户编号
 address: 地址
 province: 省份
 city: 城市
 region: 地区
 zip: 邮编
 name: 姓名
 phone: 联系电话
 */
+ (NSString *)getAddAddressWithUserId:(NSString *)userId
                              address:(NSString *)address
                             province:(NSString *)province
                                 city:(NSString *)city
                               region:(NSString *)region
                                  zip:(NSString *)zip
                                 name:(NSString *)name
                                phone:(NSString *)phone
                           longtitude:(NSString *)longtitude
                             latitude:(NSString *)latitude;

#pragma mark - 删除收货地址
+ (NSString *)getDeleteAddressList:(NSString *)userId
                         addressId:(NSString *)addressId;
#pragma mark - 清空搜索地址
+ (NSString *)getclearHistoryAdress:(NSString *)userId;

#pragma mark - 获取订单支付信息
+ (NSString *)getOrderPayInfoWith:(NSString *)userId orderId:(NSString *)orderIds;

#pragma mark - 可用支付方式列表

+ (NSString *)getValidPayTypeListWithUser:(NSString *)userId orderId:(NSString *)orderId;

#pragma mark - 头像上传接口
+ (NSString *)getSetHeaderURLString;

#pragma mark - 
+ (NSDictionary *)getSetHeaderDcitWith:(NSString *)userId
                                header:(NSData *)header;

#pragma mark - 取消订单
+ (NSString *)getCancelOrderWithUserId:(NSString *)userId
                              orderId:(NSString *)orderId
                               reason:(NSString *)reason;

#pragma mark - 获取确认码
+ (NSString *)getConfirm:(NSString *)userId
                 orderId:(NSString *)orderId
           orderDetailId:(NSString *)orderDetailId
                 delDyqs:(NSString *)delDyqs
                    type:(NSString *)type;

#pragma mark - 确认收货
+ (NSString *)confirmOrder:(NSString *)userId
                   orderId:(NSString *)orderId
             orderDetailId:(NSString *)orderDetailId
                      qrqs:(NSString *)qrqs;

#pragma mark - 消息列表
+ (NSString *)getMyMessages:(NSString *)userId
                      count:(NSString *)count
                       page:(NSString *)page;

#pragma mark - 收藏刊物列表
+ (NSString *)getBoookmarkPaperList:(NSString *)userId page:(NSString *)page count:(NSString *)count lQueryTime:(NSString *)lQueryTime;

#pragma mark - 收藏店铺列表
+ (NSString *)getBoookmarkStoreList:(NSString *)userId longtitude:(NSString *)longtitude latitude:(NSString *)latitude page:(NSString *)page count:(NSString *)count lQueryTime:(NSString *)lQueryTime;

#pragma mark - 使用抵用券
/**
 *  需提供参数
 userId: 用户id
 orderId: 订单编号
 cardNumber： 抵用券号
 */
+ (NSString *)getPaymentDYQWithOrderId:(NSString *)orderId
                                userId:(NSString *)userId
                            cardNumber:(NSString *)cardNumber;
#pragma mark - 使用蜘蛛卡
/**
 *  需提供参数
 userId: 用户id
 orderId: 订单编号
 cardNumber： 抵用券号
 */
+ (NSString *)getPaymentSpiderCardWithOrderId:(NSString *)orderId
                                       userId:(NSString *)userId
                                   cardNumber:(NSString *)cardNumber
                                  payPassword:(NSString *)payPassword;


#pragma mark - 朱元支付
/**
 *  需提供参数
 userId: 用户id
 orderId: 订单编号
 payPassword： 支付密码
 */
+ (NSString *)getPaymentSpiderYuanWithOrderId:(NSString *)orderId
                                       userId:(NSString *)userId
                                  payPassword:(NSString *)payPassword;

#pragma mark - 微信支付
/**
 *  需提供参数
 userId: 用户id
 orderId: 订单编号
 */
+ (NSString *)getPaymentWeixinPayUtilWithOrderId:(NSString *)orderId
                                          userId:(NSString *)userId
                                    netpayamount:(NSString *)netpayamount
                                       isDeposit:(NSString *)isDeposit;


#pragma mark - 支付宝支付
/**
 *  需提供参数
 
 orderId: 订单编号
 */
+ (NSString *)getPaymentAlipayJPayUtilWithOrderId:(NSString *)orderId
                                           userId:(NSString *)userId
                                     netpayamount:(NSString *)netpayamount
                                        isDeposit:(NSString *)isDeposit;
#pragma mark - 银联支付
/**
 *  需提供参数
 userId: 用户id
 paytype: 银联代号
 psource： 支付来源
 netpayamount： 支付金额
 */
+ (NSString *)getPaymentNetPayUtilWithOrderId:(NSString *)orderId
                                      paytype:(NSString *)paytype
                                      psource:(NSString *)psource
                                 netpayamount:(NSString *)netpayamount
                                    isDeposit:(NSString *)isDeposit
                                       userId:(NSString *)userId;

#pragma mark - 修改登陆密码
/*
 需提供参数：
 userId: 用户编号
 mobile: 手机号
 verifyCode: 验证码
 oldPassword: 旧密码
 newPassword: 新密码
 */
+ (NSString *)getChangePasswordURLString:(NSString *)userId
                                  mobile:(NSString *)mobile
                              verifyCode:(NSString *)verifyCode
                               newPassword:(NSString *)newPasswrd
                    module:(NSString *)module;
#pragma mark - 验证验证码
+ (NSString *)getjudgeVerifyCodeURLMobile:(NSString *)mobile
                              verifyCode:(NSString *)verifyCode;
#pragma mark - 绑定手机
/*
 需提供参数：
 userId: 用户编号
 mobile: 手机号
 verifyCode: 验证码
 */
+ (NSString *)getBindModileURLString:(NSString *)userId
                              mobile:(NSString *)mobile
                          verifyCode:(NSString *)verifyCode
                              module:(NSString *)module;

#pragma mark - 设置支付密码
+ (NSString *)getSetPayPasswordWithUserId:(NSString *)userId
                                   mobile:(NSString *)mobile
                               verifyCode:(NSString *)verifyCode
                              payPassword:(NSString *)payPassword
                                   module:(NSString *)module;

#pragma mark - 账户明细
+ (NSString *)getAccountParticularsWithUserId:(NSString *)userId;

#pragma mark - 红包
+(NSString *)getHongbaoWithUserId:(NSString *)userId NSSting:(NSString*)url;
#pragma mark -  广告详情联合登陆

+(NSString *)getADDetailsWithUserId:(NSString *)userId Info:(SSActADInfo *)info;


#pragma mark - 获取抵用券列表
/**
 *  @param userId     用户id
 *  @param type       类型 0：抵用券 1：蜘蛛卡
 *  @param status     状态 0：可使用 1：已过期 2：已使用
 *  @param page       页码
 *  @param count      页面容量
 *  @param lQueryTime 上次查询的时间
 */
+ (NSString *)getVoucherListURLString:(NSString *)userId version:(NSString*)version type:(NSString *)type status:(NSString *)status page:(NSInteger)page count:(NSString *)count lQueryTime:(NSString *)lQueryTime ;

#pragma mark - 绑定抵用券
/**
 *  需提供参数
 userId: 用户id
 voucherNum： 抵用券号
 */
+ (NSString *)getBindSpiderVoucherWithUserId:(NSString *)userId
                                  voucherNum:(NSString *)voucherNum;

#pragma mark - 绑定蜘蛛卡
/**
 *  需提供参数
 userId: 用户id
 zzkId: 蜘蛛卡账号
 zzkPass: 蜘蛛卡密码
 */
+ (NSString *)getBindSpiderCardWithUserId:(NSString *)userId
                                    zzkId:(NSString *)zzkId
                                  zzkPass:(NSString *)zzkPass;

#pragma mark - 解绑蜘蛛卡
/**
 *  @param userId     用户id
 *  @param cardNum    卡号
 *  @param unbindTime 解绑时间
 */
+ (NSString *)getUnbindSpiderCardWithUserId:(NSString *)userId cardNum:(NSString *)cardNum unbindTime:(NSString *)unbindTime;


#pragma mark - 我的积分
/**
 *  @param userId 用户id
 */
+ (NSString *)getMyPointsWithUserId:(NSString *)userId;

#pragma mark - 保存用户信息
/**
 *  @param userId   用户id
 *  @param nickName 昵称
 *  @param sex      性别 男=m 女=f
 */
+ (NSString *)saveUserInfoWithUserId:(NSString *)userId nickName:(NSString *)nickName sex:(NSString *)sex;

#pragma mark - 意见反馈
/**
 *  @param userId  用户id
 *  @param content 反馈内容
 *  @param type    反馈类型
 *  @param contact 联系方式
 */
+ (NSString *)getFeedBackWithUserId:(NSString *)userId
                            content:(NSString *)content
                               type:(NSString *)type
                            contact:(NSString *)contact;

#pragma mark - 强制更新
+ (NSString *)getForceUpdate;

#pragma mark - 广告
/*
 需提供参数：
 ModelId  :模块（首页 home，每单有礼gift，免费领刊 free，一元定 one，活动频道页 activity 启动页广告 start）
 count: 每页记录数，默认为10码
 page: 请求起始页码，默认为1
 
 返回参数：urlString
 */
+ (NSString *)getAdvertisementList:(NSString *)ModelId
                             count:(int)count
                              page:(int)page;

#pragma mark - 登录送积分
+ (NSString *)getLoginPoints:(NSString *)userId;

#pragma mark - 评论
/**
 *  @param userId   用户id
 *  @param userName 用户名
 *  @param type     类型 0=商品 1=店铺
 *  @param sid      商品或者店铺id
 *  @param orderId  订单id
 *  @param content  评论内容
 *  @param level    评级（1，2，3，4，5）
 */
+ (NSString *)getCommentUrl:(NSString *)userId userName:(NSString *)userName type:(NSString *)type sid:(NSString *)sid orderId:(NSString *)orderId content:(NSString *)content level:(NSString *)level;

#pragma mark - 注册环信账号
/**
 *  @param userId     用户id
 *  @param userSource 区分书报亭b、c端（b或者c）
 */
+ (NSString *)getRegisterImUserUrl:(NSString *)userId userSource:(NSString *)userSource;

#pragma mark - 注册B端用户环信账号
/**
 *  @param userId B端用户编号
 *  @param source b\c
 */
+ (NSString *)getBIMUser:(NSString *)userId source:(NSString *)source;

#pragma mark - 环信添加好友
/**
 *  @param imUserId       环信用户编号
 *  @param friendImUserId 好友环信用户编号
 */
+ (NSString *)getAddFriendUrlWithImUserId:(NSString *)imUserId friendImUserId:(NSString *)friendImUserId ;

#pragma mark - 获取好友列表
/**
 *  @param IMuserId 自己的环信id
 *  @param source   b/c
 */
+ (NSString *)getFriends:(NSString *)IMuserId source:(NSString *)source;

#pragma mark - 订阅有礼分类列表
+ (NSString *)getGiftCategory;

#pragma mark - 获取反馈类型
+ (NSString *)getFeedBackTypesUrlWithUserId:(NSString *)userId;
@end
