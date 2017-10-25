//
//  GBGroupInfo.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/12.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

//圈子/话题

#import <Mantle/Mantle.h>

@interface GBGroupInfo : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSNumber *topicId;
@property (nonatomic, strong) NSNumber *ownerId; //创建者id
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *headPortrait; //圈子头像
@property (nonatomic, copy) NSString *background;  //背景图
@property (nonatomic, strong) NSNumber *createdTime;  //创建时间
@property (nonatomic, assign) BOOL beFollowed;  //是否已关注
@property (nonatomic, strong) NSNumber *feedCount;  //帖子数
@property (nonatomic, strong) NSNumber *followCount;  //订阅人数
@end
