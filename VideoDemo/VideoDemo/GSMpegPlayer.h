//
//  GSMpegPlayer.h
//  VideoDemo
//
//  Created by iosdevlope on 2017/5/27.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMpegPlayer : UIView

- (void)displayYUV420PData:(void *)data width:(NSInteger)width height:(NSInteger)height;
- (void)setVideoSize:(GLuint)width height:(GLuint)height;
@end
