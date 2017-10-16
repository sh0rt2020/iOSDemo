//
//  VideoAndAudioMerger.h
//  GifToVideoDemo
//
//  Created by iosdevlope on 2017/10/13.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoAndAudioMerger : NSObject

- (id)initWithVideoContainer:(UIImageView *)videoContainer;
- (void)convertAndMerge;

@end
