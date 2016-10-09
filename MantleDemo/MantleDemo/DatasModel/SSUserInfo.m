//
//  SSUserInfo.m
//  SpiderSubscribe
//
//  Created by spider on 14/11/7.
//  Copyright (c) 2014年 spider. All rights reserved.
//

#import "SSUserInfo.h"

@implementation SSUserInfo

+ (id)initEntity{
    
    return [[SSUserInfo alloc] init];
}

- (id)init{
    self = [super init];
    
    if( self ){
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    if (self = [super init]){
        
        self.ssUserId = [coder decodeObjectForKey:@"_ssUserId"];
        self.ssUserName = [coder decodeObjectForKey:@"_ssUserName"];
        self.ssUserName1 = [coder decodeObjectForKey:@"_ssUserName1"];
        self.ssHeader = [coder decodeObjectForKey:@"_ssHeader"];
        self.ssHasPayPsd = [coder decodeObjectForKey:@"_ssHasPayPsd"];
        self.ssMobile = [coder decodeObjectForKey:@"_ssMobile"];
        self.ssImUserId = [coder decodeObjectForKey:@"_ssImUserId"];
//        self.isLogIn = [coder decodeObjectForKey:@"_isLogIn"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:_ssMobile forKey:@"_ssMobile"];
    [coder encodeObject:_ssUserId forKey:@"_ssUserId"];
    [coder encodeObject:_ssUserName forKey:@"_ssUserName"];
    [coder encodeObject:_ssHeader forKey:@"_ssHeader"];
    [coder encodeObject:_ssHasPayPsd forKey:@"_ssHasPayPsd"];
    [coder encodeObject:_ssImUserId forKey:@"_ssImUserId"];
//    [coder encodeObject:_isLogIn forKey:@"_isLogIn"];
}
@end

@implementation SSSubUserInfo
@end

@implementation SSSpiderCard
@end

@implementation SSVoucher
@end
