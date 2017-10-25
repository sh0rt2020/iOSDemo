//
//  GBApiManager.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/12.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Base_Address @"http://211.95.56.10:9985"
#define FeedList            Base_Address@"/frontend/feed/list"  //列表
#define FeedDetail          Base_Address@"/frontend/feed/detail"  //详情
#define FavorApi            Base_Address@"/frontend/feed/favor"  //点赞
#define UnfavorApi          Base_Address@"/frontend/feed/unfavor"  //点踩
#define ShareApi            Base_Address@"/frontend/feed/share"  //分享
#define CommentList         Base_Address@"/frontend/comment/list"  //评论列表

#define TopicList           Base_Address@"/frontend/topic/list"  //圈子列表
#define TopicFollowApi      Base_Address@"/frontend/topic/follow"  //关注圈子
#define TopicUnfollowApi    Base_Address@"/frontend/topic/unfollow"  //取消关注圈子


@interface GBApiManager : NSObject

+ (instancetype)sharedApiManager;
+ (NSDictionary *)commonParamsHandle:(NSDictionary *)params;
+ (NSString *)encryptWithMD5:(NSDictionary *)sortedParams;
+ (NSString *)encryptWithHmacSHA256:(NSDictionary *)sortedParams;
+ (NSString *)genApiString:(NSDictionary *)params;

@end
