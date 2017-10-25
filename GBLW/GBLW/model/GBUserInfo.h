//
//  GBUserInfo.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/12.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GBUserInfo : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, strong) NSNumber *loginId;
@end
