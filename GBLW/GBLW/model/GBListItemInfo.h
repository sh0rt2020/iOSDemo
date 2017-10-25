//
//  GBListItemInfo.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/12.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef enum : NSUInteger {
    GBFeedTypeJoke = 1,
    GBFeedTypePic,
    GBFeedTypeVedio,
    GBFeedTypeGif
} GBFeedType;

@interface GBListItemInfo : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSNumber *feedId;
@property (nonatomic, strong) NSNumber *topicId;
@property (nonatomic, strong) NSNumber *publisherId;
@property (nonatomic, copy) NSString *publisherName;
@property (nonatomic, copy) NSString *publisherPortrait;
@property (nonatomic, assign) GBFeedType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *pictures;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, strong) NSNumber *videoDuration;
@property (nonatomic, strong) NSNumber *favor;  //点赞
@property (nonatomic, strong) NSNumber *unfavor; //点踩
@property (nonatomic, strong) NSNumber *comment; //评论数
@property (nonatomic, strong) NSNumber *forward; //转发数
@property (nonatomic, strong) NSNumber *publishTime;
@property (nonatomic, copy) NSString *shareLink;  //分享出去的链接
@property (nonatomic, strong) NSNumber *actionType;  //1:点赞 2:点踩 3:既赞又踩

@property (nonatomic, assign) CGFloat contentHeight; //缓存高度

- (CGFloat)cacheCellHeight:(GBListItemInfo *)item;
@end
