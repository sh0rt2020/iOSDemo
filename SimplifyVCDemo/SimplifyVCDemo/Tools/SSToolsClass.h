//
//  SSToolsClass.h
//  SpiderSubscriber
//
//  Created by royal on 14/11/21.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import "SSToolsMacros.h"
//#import "iToast.h"

@interface SSToolsClass : NSObject {
    SSUserInfo *ssUserInfo;
}

@property (nonatomic, copy) NSString *ssCartNum;  //购物车数量
@property BOOL ssThirdLoginFlag;  //第三方登录flag
@property (nonatomic, copy) NSString *ssCity;       //配送的城市
@property (nonatomic, copy) NSString *ssLocAddress; //定位的详细地址
//@property (nonatomic, strong) SSAddressInfo *ssAddressInfo; //longitude latitude addressId
//
//@property (nonatomic, strong) SSSearchConditionInfo *ssSearchInfo;      //搜索配置条件

@property (nonatomic) NSDateFormatter *sharedDateFormatter;  //单例日期格式类型实例

+ (instancetype)sharedTool;
// 颜色值转换
+ (UIColor*)hexColor:(NSString*)hexColor;

// 函数描述: 获取当前时间
+ (NSString *) getTimeForNow;

/**
 *  固定的时间和当前的时间比较
 *
 *  @param time 固定的时间
 *
 *  @return >0 还未到固定时间  <0 已过固定时间
 */
+ (NSInteger)timeInterval:(NSString *)time;

//比较时间差
+ (NSTimeInterval)timeInterval:(NSString *)currentTime otherTime:(NSString *)otherTime;

// 获取当前设备的UUID
+ (NSString *)getUUID;

// 验证手机号是否合法
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//验证密码是否合法
+ (BOOL)isPasswordValidate:(NSString *)pwd;
//验证是否包含特殊字符
+(BOOL)isContainCharacterWithString:(NSString *)string;
//验证简单密码
+ (BOOL)checkPassword:(NSString *) password;
// 根据View的xib名称创建view
+(UIView *)newViewByxibName:(NSString *)xibName;

/**
 *  得到一个画出来的图片
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

/**
 *  根据字符串的字体大小 固定宽或高得到自适应的宽或高
 *
 *  @param str  字符串
 *  @param font 字体大小
 *  @param size 固定的宽或高
 *
 *  @return 得到的宽或高
 */
+ (CGSize)getSizeWith:(NSString *)str font:(CGFloat)font size:(CGSize)size;

/**
 *  根据价格单位的字母得到汉字 或根据汉字得到字符
 *
 *  @param type
 *
 *  @return 
 */
+ (NSString *)getUnitWith:(NSString *)type;

/**
 *  限制输入框只能输入数字
 *
 *  @param number 当前的字符串
 *
 *  @return 是否可以继续输入
 */
+ (BOOL)validateNumber:(NSString*)number;

/**
 *  根据错误码返回错误信息
 *
 *  @param number 当前的字符串
 *
 *  @return 错误信息
 */
+ (NSString *)getItoast:(NSString *)type;

//对字符串进行编码
+ (NSString *)encodeString:(NSString *)string;

/**
 *  为字符串添加属性
 *
 *  @param str   要加的字符串
 *  @param font  字体大小
 *  @param color 字体颜色
 *  @param range 范围
 *
 *  @return 有字体大小默认在范围内改变字体大小  有颜色改变颜色  什么都没有是删除
 */
+ (NSAttributedString *)addAttributeToString:(id)str font:(CGFloat)font color:(UIColor *)color range:(NSRange)range;
/**
 *  得到搜索历史
 *
 *  @return 列表
 */
+ (NSArray *)getSearchHistory;
/**
 *  添加或删除
 *
 *  @param str      要添加或删除的字符串
 *  @param isDelete 是否是删除
 */
+ (void)addSearchHistory:(NSString *)str isDelete:(BOOL)isDelete;

#pragma mark - 存储用户信息
/**
 *  @param userInfo 用户信息实例
 */
- (void)saveUserInfo:(SSUserInfo *)userInfo;

#pragma mark - 从userDefaults里面获取用户信息
- (SSUserInfo *)getUserInfo;

#pragma mark - 过滤空字符串
+ (NSString *)filter:(NSString *)str;

#pragma mark - 关闭图片底层渲染透明通道
+ (UIImage *)optimizedImageFromImage:(UIImage *)image;

#pragma mark - 单例类实例设置日期格式
- (NSDateFormatter *)getDateFormatterWithFormat:(NSString *)format;
@end


