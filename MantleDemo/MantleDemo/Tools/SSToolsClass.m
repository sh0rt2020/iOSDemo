//
//  SSToolsClass.m
//  SpiderSubscriber
//
//  Created by royal on 14/11/21.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import "SSToolsClass.h"


@interface SSToolsClass ()
@end

static SSToolsClass *_instance;

@implementation SSToolsClass


+ (UIColor*)hexColor:(NSString*)hexColor{
    
    unsigned int red, green, blue, alpha;
    NSRange range;
    range.length = 2;
    @try {
        if ([hexColor hasPrefix:@"#"]) {
            hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        }
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
        
        if ([hexColor length] > 6) {
            range.location = 6;
            [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&alpha];
        }
    }
    @catch (NSException * e) {
        //        [MAUIToolkit showMessage:[NSString stringWithFormat:@"颜色取值错误:%@,%@", [e name], [e reason]]];
        //        return [UIColor blackColor];
    }
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(1.0f)];
}

//=============================单例模式=======================================
+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SSToolsClass alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

// 函数描述: 获取当前时间
+ (NSString *) getTimeForNow
{
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateformatter stringFromDate:senddate];
}

//比较时间差
+ (NSInteger)timeInterval:(NSString *)time {
    NSDateFormatter *dateFormatt = [[NSDateFormatter alloc] init];
    [dateFormatt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [dateFormatt dateFromString:time];
    NSDate *date2 = [NSDate date];
    NSTimeInterval inter = [date1 timeIntervalSince1970] - [date2 timeIntervalSince1970];
    return inter;
}

//比较时间差
+ (NSTimeInterval)timeInterval:(NSString *)currentTime otherTime:(NSString *)otherTime {
    
    NSDateFormatter *dateFormatt = [[NSDateFormatter alloc] init];
    [dateFormatt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date1 = [dateFormatt dateFromString:currentTime];
    NSDate *date2 = [dateFormatt dateFromString:otherTime];
    NSTimeInterval inter = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
    return inter;
}


//获取当前设备UUID
+ (NSString *)getUUID {
    UIDevice *device = [[UIDevice alloc] init];
    NSString *UUID = [[device.identifierForVendor.UUIDString componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
    return UUID;
}

// 根据View的xib名称创建view
+(UIView *)newViewByxibName:(NSString *)xibName {

    NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil];
    UIView *view = [xibArray objectAtIndex:0];
    return view;
}

//为按钮添加边框
+ (void)addBorderToButton:(UIButton *)btn
              BorderColor:(UIColor *)borderColor
              borderWidth:(CGFloat)borderWidth
             cornerRadius:(CGFloat)corneerRadius {
    btn.layer.borderColor = borderColor.CGColor;
    btn.layer.borderWidth = borderWidth;
    btn.layer.cornerRadius = corneerRadius;
    btn.layer.masksToBounds = YES;
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);//填充矩形区域
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从当前范围内得到图片对象
    UIGraphicsEndImageContext();
    return image;
}

+ (CGSize)getSizeWith:(NSString *)str font:(CGFloat)font size:(CGSize)size {
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
}

+ (NSString *)getUnitWith:(NSString *)type {
    if ([type isEqualToString:@"f"]) {
        return @"全年";
    } else if ([type isEqualToString:@"h"]) {
        return @"半年";
    } else if ([type isEqualToString:@"j"]) {
        return @"季度";
    } else if ([type isEqualToString:@"s"]){
        return @"单月";
    } else if ([type isEqualToString:@"全年"]) {
        return @"f";
    } else if ([type isEqualToString:@"半年"]) {
        return @"h";
    } else if ([type isEqualToString:@"季度"]) {
        return @"j";
    } else if ([type isEqualToString:@"单月"]) {
        return @"s";
    }
    return @"";
}

+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


// 验证手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134x（0-8）、135、136、137、138、139、150、151、152、158、159、182、183、184、157、187、188、178
     * 联通：130、131、132、155、156、185、186、176、185
     * 电信：133、153、180、181、189、177
     */
    NSString * MOBILE = @"^1(3|5|7|8)\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum]) {
        return YES;
    }
    return NO;
}

//验证密码是否合法
+ (BOOL)isPasswordValidate:(NSString *)pwd {
    //6-20位密码（字母和数字）
    NSString *pwdRegex = @"^[a-zA-Z0-9.*[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]+.*]{6,20}";
    
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    return [pwdTest evaluateWithObject:pwd];
}
+(BOOL)isContainCharacterWithString:(NSString *)string{
    
    NSRange  range = [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"!@#$%`~^&*()／？_-<,.|=+>"]];
    NSLog(@"%@",NSStringFromRange(range));
    if (NSStringFromRange(range)) {
        NSLog(@"存在特殊字符");
        return YES;
    }
    NSLog(@"不存在特殊字符");
    return NO;
}
//验证简单密码
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

+ (NSString *)getItoast:(NSString *)type {
    if ([type isEqualToString:@"F1003"]) {
        return @"账户存在问题";
    } else if ([type isEqualToString:@"F1004"]) {
        return @"登录失败";
    } else if ([type isEqualToString:@"F1005"]) {
        return @"系统异常";
    } else if ([type isEqualToString:@"F1006"]) {
        return @"账号状态存在问题";
    } else if ([type isEqualToString:@"F1007"]) {
        return @"无此用户";
    } else if ([type isEqualToString:@"F1008"]) {
        return @"密码错误";
    } else if ([type isEqualToString:@"F1009"]) {
        return @"用户已存在";
    } else {
        return @"网络出现问题！";
    }
}

+ (NSString *)encodeString:(NSString *)string {
     NSString *encode = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)string, nil, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encode;
}

+ (NSAttributedString *)addAttributeToString:(id)str font:(CGFloat)font color:(UIColor *)color range:(NSRange)range {
    NSMutableAttributedString *attStr = nil;
    if ([str isKindOfClass:[NSString class]]) {
        attStr = [[NSMutableAttributedString alloc] initWithString:str];
    } else if ([str isKindOfClass:[NSAttributedString class]]){
        attStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    }
    if (font && font > 0) {
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
    }
    if (color) {
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    if (!font && !color) {
        [attStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle] range:range];
    }
    return attStr;
}

+ (NSArray *)getSearchHistory {
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:[self getPlistPath]];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        [arr addObject:array[array.count - 1 - i]];
    }
    return arr;
}

+ (void)addSearchHistory:(NSString *)str isDelete:(BOOL)isDelete{
    NSArray *history = [[NSArray alloc] initWithContentsOfFile:[self getPlistPath]];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < history.count; i++) {
        if (i < 19) {
            [arr addObject:history[i]];
        }
    }
    if (!isDelete) {
        //如果已存在这个历史
        if ([arr containsObject:str]) {
            //先删除后添加 保证最新加入的在上面
            [arr removeObject:str];
        }
        [arr addObject:str];
  
    } else {
        [arr removeAllObjects];
    }
    NSString *myFile = [self getPlistPath];
    [arr writeToFile:myFile atomically:YES];
}

+ (NSString *)getPlistPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *myFile = [docPath stringByAppendingPathComponent:@"searchHistory.plist"];
    return myFile;
}

#pragma mark - 存储用户信息
- (void)saveUserInfo:(SSUserInfo *)userInfo {
//    userInfo.ssImUserId = @"19fs6391dff49fc29d41e99d40e93b06";
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userData forKey:@"userInfo"];
    [userDefaults synchronize];
    
    ssUserInfo = userInfo;
}

#pragma mark - 从userDefaults里面获取用户信息
- (SSUserInfo *)getUserInfo {
    if (ssUserInfo) {
        return ssUserInfo;
    } else {
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        SSUserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        ssUserInfo = userInfo;
        return userInfo;
    }
}

#pragma mark - 过滤空字符串
+ (NSString *)filter:(NSString *)str {
    if (str && str.length > 0) {
        return str;
    }
    return @"";
}

#pragma mark - 关闭图片底层渲染透明通道
//By default, UIImage instances are rendered in a Graphic Context that includes alpha channel
//To avoid it, you need to generate another image using a new Graphic Context where opaque = YES
+ (UIImage *)optimizedImageFromImage:(UIImage *)image {
    CGSize imageSize = image.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, true, 0.0);
    [image drawInRect: CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *optimizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return optimizedImage;
}

#pragma mark - 单例类实例设置日期格式
- (NSDateFormatter *)getDateFormatterWithFormat:(NSString *)format {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDateFormatter = [[NSDateFormatter alloc] init];
    });
    [_sharedDateFormatter setDateFormat:format];
    return self.sharedDateFormatter;
}
@end
