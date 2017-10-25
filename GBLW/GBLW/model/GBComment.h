//
//  GBComment.h
//  GBLW
//
//  Created by iosdevlope on 2017/10/17.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GBComment : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSNumber *publisherId;
@property (nonatomic, copy) NSString *publisherName;
@property (nonatomic, strong) NSNumber *favor;
@property (nonatomic, strong) NSNumber *publishTime;
@property (nonatomic, copy) NSString *publisherPortrait;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSNumber *feedId;
@property (nonatomic, strong) NSNumber *commentId;
@property (nonatomic, strong) NSNumber *actionType;  //

@property (nonatomic, assign) CGFloat contentHeight; //缓存高度

- (CGFloat)cacheCellHeight:(GBComment *)comment;
@end
