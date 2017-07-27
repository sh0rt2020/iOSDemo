//
//  GSMpegPlayer.m
//  VideoDemo
//
//  Created by iosdevlope on 2017/5/27.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "GSMpegPlayer.h"

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#import <sys/time.h>


typedef enum : NSUInteger {
    ATTRIB_VERTEX,
    ATTRIB_TEXTURE,
    ATTRIB_COLOR,
} AttribEnum;

typedef enum : NSUInteger {
    TEXY = 0,
    TEXU,
    TEXV,
    TEXC
} TextureType;


static const GLfloat squareVertices[] = {
    -1.0f, -1.0f,
    1.0f, -1.0f,
    -1.0f, 1.0f,
    1.0f,  1.0f,
};

static const GLfloat coordVertices[] = {
    0.0f, 1.0f,
    1.0f, 1.0f,
    0.0f, 0.0f,
    1.0f, 0.0f,
};

@interface GSMpegPlayer () {
    EAGLContext *glContext;
    GLuint frameBuffer;
    GLuint renderBuffer;
    GLuint program;
    GLuint textureYUV[3];
    GLuint videoW; //视频宽度
    GLuint videoH; //视频高度
    GLsizei viewScale;
    
    GLuint positionSlot;
    GLuint texCoordSlot;
    
    GLuint textureUniformY;
    GLuint textureUniformU;
    GLuint textureUniformV;
    
#ifdef DEBUG
    struct timeval time;
    NSInteger frameRate;
#endif
}

@end


@implementation GSMpegPlayer
#pragma mark - life cycle
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (![self doInit]) {
            self = nil;
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (![self doInit]) {
            self = nil;
        }
    }
    return self;
}

#pragma mark - overide
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)layoutSubviews {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @synchronized(self) {
            [EAGLContext setCurrentContext:glContext];
            [self destoryFrameAndRenderBuffer];
            [self createFrameAndRenderBuffer];
        }
        
        glViewport(1, 1, self.bounds.size.width*viewScale-2, self.bounds.size.height*viewScale-2);
    });
}

#pragma mark - public
- (void)displayYUV420PData:(void *)data width:(NSInteger)width height:(NSInteger)height {
    @synchronized (self) {
        if (width != videoW || height != videoH) {
            [self setVideoSize:(GLuint)width height:(GLuint)height];
        }
        
        [EAGLContext setCurrentContext:glContext];
        
        glBindTexture(GL_TEXTURE_2D, textureYUV[TEXY]);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, (GLsizei)width, (GLsizei)height, GL_RED_EXT, GL_UNSIGNED_BYTE, data);
        
        glBindTexture(GL_TEXTURE_2D, textureYUV[TEXU]);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, (GLsizei)width/2, (GLsizei)height/2, GL_RED_EXT, GL_UNSIGNED_BYTE, data+width*height);
        
        glBindTexture(GL_TEXTURE_2D, textureYUV[TEXV]);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, (GLsizei)width/2, (GLsizei)height/2, GL_RED_EXT, GL_UNSIGNED_BYTE, data+width*height*5/4);
        
        [self render];
    }
}

- (void)setVideoSize:(GLuint)width height:(GLuint)height {
    videoW = width;
    videoH = height;
    
    void *blackData = malloc(width * height * 1.5);
    if (blackData) {
        memset(blackData, 0x0, width*height*1.5);
    }
    
    [EAGLContext setCurrentContext:glContext];
    glBindTexture(GL_TEXTURE_2D, textureYUV[TEXY]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width, height, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData);
    glBindTexture(GL_TEXTURE_2D, textureYUV[TEXU]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width/2, height/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData+width*height);
    glBindTexture(GL_TEXTURE_2D, textureYUV[TEXV]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width/2, height/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData+width*height*5/4);
    
    free(blackData);
}


#pragma mark - private
- (BOOL)doInit {
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.opaque = YES;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil];
    
    self.contentScaleFactor = [UIScreen mainScreen].scale;
    viewScale = [UIScreen mainScreen].scale;
    
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!glContext || ![EAGLContext setCurrentContext:glContext]) {
        NSLog(@"EAGLContext init failed.\n");
        return NO;
    }
    
    [self setupYUVTexture];
    [self compileShaders];
    
    return YES;
}

- (void)setupYUVTexture {
    if (textureYUV[TEXY]) {
        glDeleteTextures(3, textureYUV);
    }
    
    glGenTextures(3, textureYUV);
    if (!textureYUV[TEXY] || !textureYUV[TEXU] || !textureYUV[TEXV]) {
        NSLog(@"<<<<<<<<<<<<<<Texture init failed.>>>>>>>>>>>>>>>\n");
        return ;
    }
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureYUV[TEXY]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, textureYUV[TEXU]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, textureYUV[TEXV]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

- (void)compileShaders {
    GLuint vertexShader = [self compileShader:@"VertexShader" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"FragmentShader" withType:GL_FRAGMENT_SHADER];
    
    program = glCreateProgram();  //创建program并添加着色器
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    glLinkProgram(program); //链接program
    
    //检查链接状态
    GLint linkSuccess;
    glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        
        GLint infoLength = 0;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLength);
        
        if (infoLength > 1) {
            char *infoLog = malloc(sizeof(char)*infoLength);
            glGetProgramInfoLog(program, infoLength, NULL, infoLog);
            
            NSLog(@"Error linking program:\n%s\n", infoLog);
            free(infoLog);
        }
        
        glDeleteProgram(program);
        return ;
    }
    
    glUseProgram(program); //激活program对象从而在render中使用它
    
    positionSlot = glGetAttribLocation(program, "Position");
    texCoordSlot = glGetAttribLocation(program, "TexCoordIn");
    glEnableVertexAttribArray(positionSlot);
    glEnableVertexAttribArray(texCoordSlot);
    
    
    textureUniformY = glGetUniformLocation(program, "SamplerY");
    textureUniformU = glGetUniformLocation(program, "SamplerU");
    textureUniformV = glGetUniformLocation(program, "SamplerV");
//    glUniform1i(textureUniformY, 0);
//    glUniform1i(textureUniformU, 1);
//    glUniform1i(textureUniformV, 2);
}

- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType {
    
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@\n%@", error.localizedDescription, shaderName);
        exit(1);
    }
    
    //创建shader，shaderType：GL_VERTEX_SHADER 或 GL_FRAGMENT_SHADER
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char *shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);  //加载shaderSource
    
    //编译shader
    glCompileShader(shaderHandle);
    
    //检查编译状态
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);//此外还可以查询 GL_DELETE_STATUS，GL_INFO_LOG_STATUS， GL_INFO_LOG_LENGTH，GL_SHADER_SOURCE_LENGTH 和 GL_SHADER_TYPE
    if (compileSuccess == GL_FALSE) {
        GLint infoLength = 0;
        glGetShaderiv(shaderHandle, GL_INFO_LOG_LENGTH, &infoLength);
        if (infoLength > 1) {
            char *infoLog = malloc(sizeof(char)*infoLength);
            glGetShaderInfoLog(shaderHandle, infoLength, NULL, infoLog);
            
            NSLog(@"Error compiling shader:\n%@\n%s\n", shaderName, infoLog);
            free(infoLog);
        }
        
        glDeleteShader(shaderHandle);
        return 0;
    }
    
    return shaderHandle;
}


- (BOOL)createFrameAndRenderBuffer {
    glGenFramebuffers(1, &frameBuffer);
    glGenRenderbuffers(1, &renderBuffer);
    
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    
    
    if (![glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer]) {
        NSLog(@"attach渲染缓冲区失败");
    }
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"创建缓冲区错误 0x%x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
    return YES;
}


- (void)destoryFrameAndRenderBuffer {
    if (frameBuffer) {
        glDeleteFramebuffers(1, &frameBuffer);
    }
    
    if (renderBuffer) {
        glDeleteRenderbuffers(1, &renderBuffer);
    }
    
    frameBuffer = 0;
    renderBuffer = 0;
}

- (void)render {
    
    [EAGLContext setCurrentContext:glContext];
    glClearColor(0, 0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    CGSize size = self.bounds.size;
    glViewport(1, 1, size.width*viewScale-2, size.height*viewScale-2);
    
    glVertexAttribPointer(positionSlot, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(positionSlot);
    
    glVertexAttribPointer(texCoordSlot, 2, GL_FLOAT, 0, 0, coordVertices);
    glEnableVertexAttribArray(texCoordSlot);
    
    //draw
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    [glContext presentRenderbuffer:GL_RENDERBUFFER];
}
@end
