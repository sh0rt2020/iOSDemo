//
//  OpenGLCopy.m
//  OpenGLDemo
//
//  Created by iosdevlope on 2017/6/20.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "OpenGLCopy.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface OpenGLCopy () {
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    GLuint _colorRenderBuffer;
}
@end

@implementation OpenGLCopy

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        
        [self render];
    }
    return self;
}


#pragma mark - override
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

#pragma mark - private helper
- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContext {
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context) {
        NSLog(@"failed to initialize OpenGLES 2.0 context");
        return ;
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"failed to set current OpenGL context");
        return ;
    }
}


- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindBuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}


- (void)setupFrameBuffer {
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}


- (void)render {
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
