//
//  SSConstant.h
//  SpiderSubscriber
//
//  Created by Czh on 15/9/8.
//  Copyright (c) 2015年 spider. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  引导页
 */
UIKIT_EXTERN NSString *const ST_Guide;

/**
 *  取消
 */
UIKIT_EXTERN NSString *const ST_Cancel;
/**
 *  确定
 */
UIKIT_EXTERN NSString *const ST_OK;

/**
 *  切换位置
 */
UIKIT_EXTERN NSString *const ST_LOCATION_Change;

/**
 *  定位的城市（如果定位失败进行城市内检索，则是上次定位成功的城市）
 */
/**
 *  定位的城市 (刷新定位)
 */
UIKIT_EXTERN NSString *const ST_LOCATION_City;

UIKIT_EXTERN NSString *const ST_LOCATION_District ;
UIKIT_EXTERN NSString *const ST_LOCATION_StreetName ;
UIKIT_EXTERN NSString *const ST_LOCATION_SsStreetNum ;

//++++++++++++++++++++++++++++++++++++++++++ 店铺
/**
 *  综合排序
 */
UIKIT_EXTERN NSString *const ST_Sort_All;
/**
 *  全城
 */
UIKIT_EXTERN NSString *const ST_Sort_City;
/**
 *  分类
 */
UIKIT_EXTERN NSString *const ST_Sort_Class;
/**
 *  热销商品
 */
UIKIT_EXTERN NSString *const ST_Store_Hot;
/**
 *  全部商品
 */
UIKIT_EXTERN NSString *const ST_Store_All;
/**
 *  最新上架
 */
UIKIT_EXTERN NSString *const ST_Store_New;
/**
 *  评价
 */
UIKIT_EXTERN NSString *const ST_Store_Appraise;
//++++++++++++++++++++++++++++++++++++++++++ 首页


//++++++++++++++++++++++++++++++++++++++++++ 购物车
/**
 *  请选择需要结算的商品
 */
UIKIT_EXTERN NSString *const ST_CART_SEL;
/**
 *  去结算
 */
UIKIT_EXTERN NSString *const ST_CART_PAY;
/**
 *  删除
 */
UIKIT_EXTERN NSString *const ST_CART_DEL;
/**
 *  编辑全部
 */
UIKIT_EXTERN NSString *const ST_SHOPCART_EDIT;
/**
 *  完成
 */
UIKIT_EXTERN NSString *const ST_SHOPCART_Done;

/**
 *  请您先选择配送省份!
 */
UIKIT_EXTERN NSString *const ST_CART_Sel_City;
/**
 *  移入收藏夹
 */
UIKIT_EXTERN NSString *const ST_CART_Collection;
/**
 *  成功删除!
 */
UIKIT_EXTERN NSString *const ST_CART_Del_Success;
/**
 *  搜索商品!
 */
UIKIT_EXTERN NSString *const ST_SEARCH_Goods;
/**
 *  搜索店铺!
 */
UIKIT_EXTERN NSString *const ST_SEARCH_Store;
/**
 *  个人资料
 */
UIKIT_EXTERN NSString *const ST_USER_Info;


#pragma mark - 订单相关
/**
 *  订单详情
 */
UIKIT_EXTERN NSString *const ST_ORDER_Detail;
/**
 *  订单编号
 */
UIKIT_EXTERN NSString *const ST_ORDER_ID;
/**
 *  订单时间
 */
UIKIT_EXTERN NSString *const ST_ORDER_Date;

/**
 *  配送方式
 */
UIKIT_EXTERN NSString *const ST_ORDER_DeliveryModel;
/**
 *  支付方式
 */
UIKIT_EXTERN NSString *const ST_ORDER_PayType;
/**
 *  发票信息
 */
UIKIT_EXTERN NSString *const ST_ORDER_Invoice;
/**
 *  备注
 */
UIKIT_EXTERN NSString *const ST_ORDER_Remark;
/**
 *  配送失败信息
 */
UIKIT_EXTERN NSString *const ST_ORDER_D_Fail;
/**
 *  配记录
 */
UIKIT_EXTERN NSString *const ST_ORDER_D_Record;
/**
 *  查看物流
 */
UIKIT_EXTERN NSString *const ST_ORDER_Logistics;
/**
 *  确认收货
 */
UIKIT_EXTERN NSString *const ST_ORDER_Delivery;
/**
 *  确认码
 */
UIKIT_EXTERN NSString *const ST_ORDER_Code;
/**
 *  待付款
 */
UIKIT_EXTERN NSString *const ST_ORDER_Pay_N;
/**
 *  已付款
 */
UIKIT_EXTERN NSString *const ST_ORDER_Pay_Y;
/**
 *  部分支付
 */
UIKIT_EXTERN NSString *const ST_ORDER_Pay_P;
/**
 *  待评价
 */
UIKIT_EXTERN NSString *const ST_ORDER_N_Evaluation;
/**
 *  评价
 */
UIKIT_EXTERN NSString *const ST_ORDER_Evaluation;
/**
 *  订单状态  未完成
 */
UIKIT_EXTERN NSString *const ST_ORDER_Status_N;
/**
 *  订单状态  已完成
 */
UIKIT_EXTERN NSString *const ST_ORDER_Status_Y;
/**
 *  订单状态  已取消
 */
UIKIT_EXTERN NSString *const ST_ORDER_Status_C;
/**
 *  商品清单
 */
UIKIT_EXTERN NSString *const ST_ORDER_CommList;
/**
 *  发票寄送费
 */
UIKIT_EXTERN NSString *const ST_ORDER_InvoiceM;
/**
 *  使用优惠券
 */
UIKIT_EXTERN NSString *const ST_ORDER_U_Voucher;
/**
 *  配送费
 */
UIKIT_EXTERN NSString *const ST_ORDER_D_Free;
/**
// *  订单优惠
// */
//UIKIT_EXTERN NSString *const ST_ORDER_Preferential;
/**
 *  商品总价
 */
UIKIT_EXTERN NSString *const ST_ORDER_GOODS_M;
/**
 *  已支付金额
 */
UIKIT_EXTERN NSString *const ST_ORDER_Payed;
/**
 *  支付成功
 */
UIKIT_EXTERN NSString *const ST_ORDER_Pay_S;

#pragma mark - 定位相关
/******************************定位相关*********************************/

/**
 *  定位失败
 */
UIKIT_EXTERN NSString *const ST_LOCATION_Faild;




//用户信息
UIKIT_EXTERN NSString *const SSUSER_ID;

UIKIT_EXTERN NSString *const City;         //配送城市
UIKIT_EXTERN NSString *const AVATAR;       //头像
UIKIT_EXTERN NSString *const AVATARURL;       //头像
UIKIT_EXTERN NSString *const WeiXin;       //用来区分使用微信付款的是支付还是充值
UIKIT_EXTERN NSString *const CartNum;      //购物车数量
UIKIT_EXTERN NSString *const USER_NAME;     //用户昵称

//登录注册----账号有关
UIKIT_EXTERN NSString *const STR_LOGIN;
UIKIT_EXTERN NSString *const STR_REGIST;
UIKIT_EXTERN NSString *const STR_REGISTNEW;
UIKIT_EXTERN NSString *const STR_LOGIN_GETVERIFY;
UIKIT_EXTERN NSString *const STR_LOGIN_AGAINVERIFY;
UIKIT_EXTERN NSString *const STR_ID_PHONE_NUM;
UIKIT_EXTERN NSString *const STR_ID_VERIFYCODE;
UIKIT_EXTERN NSString *const STR_ID_OLD_PASSWORD;
UIKIT_EXTERN NSString *const STR_ID_NEW_PASSWORD;
UIKIT_EXTERN NSString *const STR_ID_CONFIRM_PASSWORD;
UIKIT_EXTERN NSString *const STR_SETTING;
UIKIT_EXTERN NSString *const STR_FEEDBACK;
UIKIT_EXTERN NSString *const STR_ABOUT;
UIKIT_EXTERN NSString *const STR_FEEDBACK_PUTIN;

//安全中心
UIKIT_EXTERN NSString *const STR_SAFE_CENTER_CHANGE1;
UIKIT_EXTERN NSString *const STR_SAFE_CENTER_CHANGE2;
UIKIT_EXTERN NSString *const STR_SAFE_CENTER_BINDING1;
UIKIT_EXTERN NSString *const STR_SAFE_CENTER_BINDING2;
UIKIT_EXTERN NSString *const STR_SAFE_CENTER_SETPASS1;
UIKIT_EXTERN NSString *const STR_SAFE_CENTER_SETPASS2;


//我的珠元账户
UIKIT_EXTERN NSString *const STR_MYACCOUNT;
UIKIT_EXTERN NSString *const STR_MYACCOUNT_DETAIL;
UIKIT_EXTERN NSString *const STR_MYACCOUNT_PAY;
UIKIT_EXTERN NSString *const STR_MYACCOUNT_RECHARGE_TYPE;
UIKIT_EXTERN NSString *const STR_MYACCOUNT_ALIPAY;
UIKIT_EXTERN NSString *const STR_MYACCOUNT_ONLINE;

//我的收货地址
UIKIT_EXTERN NSString *const STR_MYADDRESS;
UIKIT_EXTERN NSString *const STR_MYADDRESS_ADD;
UIKIT_EXTERN NSString *const STR_MYADDRESS_SAVE;
UIKIT_EXTERN NSString *const STR_MYADDRESS_EDIT;


//取消订单
UIKIT_EXTERN NSString *const STR_CANCELORDER_1FREIGHT;
UIKIT_EXTERN NSString *const STR_CANCELORDER_2PAYFAIL;
UIKIT_EXTERN NSString *const STR_CANCELORDER_3GIFTFAIL;
UIKIT_EXTERN NSString *const STR_CANCELORDER_4SHOPWRONG;
UIKIT_EXTERN NSString *const STR_CANCELORDER_5NOWANT;
UIKIT_EXTERN NSString *const STR_CANCELORDER_6WAITPAY;
UIKIT_EXTERN NSString *const STR_CANCELORDER_7EXPENSIVE;
UIKIT_EXTERN NSString *const STR_CANCELORDER_8LONGTIME;
UIKIT_EXTERN NSString *const STR_CANCELORDER_9ELSE;
UIKIT_EXTERN NSString *const STR_CANCELORDER_CANCEL;
UIKIT_EXTERN NSString *const STR_CANCELORDER_PUTIN;


//活动cell
UIKIT_EXTERN NSString *const ST_DETAIL_DetailActivityCellIdentifier;
//订阅有礼的cell
UIKIT_EXTERN NSString *const ST_DETAIL_GiftCellIdentifier;
//配送店铺cell
UIKIT_EXTERN NSString *const ST_DETAIL_DeliveryStoreCellIdentifier;
//订阅信息cell
UIKIT_EXTERN NSString *const ST_DETAIL_SubscribeInfoCellIdentifier;
//未设置订阅信息cell
UIKIT_EXTERN NSString *const ST_DETAIL_SingleTitleCellIdentifier;
//卖家店铺cell
UIKIT_EXTERN NSString *const ST_DETAIL_SellerStoreCellIdentifier;
//热销商品cell
UIKIT_EXTERN NSString *const ST_DEATIL_DetailHotCellIdentifier;
//分页cell
UIKIT_EXTERN NSString *const ST_DETAIL_PageCellIdentifier;
//标题栏cell
UIKIT_EXTERN NSString *const ST_DETAIL_MenuCellIdentifier;
//简介cell
UIKIT_EXTERN NSString *const ST_DETAIL_InstroCellIdentifier;


//热门专题首页列表cell
UIKIT_EXTERN NSString *const ST_SPECIAL_SpecialTableCellIdentifier;
//热门专题商品列表页cell
UIKIT_EXTERN NSString *const ST_SPECIAL_SpecialCollectionCellIdentifier;
//零售列表cell
UIKIT_EXTERN NSString *const ST_RETAIL_RetailCollectionCellIdentifier;
//订阅有礼cell
UIKIT_EXTERN NSString *const ST_GIFT_GiftSubscribeTableCellIdentifier;


//个人信息cell
UIKIT_EXTERN NSString *const ST_USERINFO_UserInfoCellIdentifier;
//个人信息头像cell
UIKIT_EXTERN NSString *const ST_USERINFO_UserHeadCellIdentifier;

//配送说明
UIKIT_EXTERN NSString *const ST_PDes;
