//
//  SSInterFace.h
//  SpiderSubscriber
//
//  Created by royal on 14/11/27.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import "SSDataPackage.h"
#import "SSDatasInfo.h"

@interface SSInterFace : SSDataPackage

+ (instancetype)shareInterFace;


#pragma mark - 订阅有礼列表
- (void)getSubscribeGiftListInfo_interface:(NSString *)urlStr
                                   success:(SSDataPackageSuccess)success
                                   failure:(SSDataPackageFailure)failure;

#pragma mark - 获取订阅有礼分类数据
- (void)getGiftCate_interface:(NSString *)urlString
                      success:(SSDataPackageSuccess)success
                      failure:(SSDataPackageFailure)failure;
@end
