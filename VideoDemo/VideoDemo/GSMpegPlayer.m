//
//  GSMpegPlayer.m
//  VideoDemo
//
//  Created by iosdevlope on 2017/5/27.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "GSMpegPlayer.h"
#import <GCDAsyncSocket.h>
#import <libavcodec/avcodec.h>
#import <libswscale/swscale.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>

const int Header = 101;
const int Data = 102;

@interface GSMpegPlayer () <GCDAsyncSocketDelegate> {
    GCDAsyncSocket *socket;
    NSData *startcodeData;
    NSData *lastStartCode;
    
    //ffmpeg
    AVFrame *frame;
    AVPicture picture;
    AVCodec *codec;
    AVCodecContext *codecCtx;
    AVPacket packet;
    struct SwsContext *img_convert_ctx;
    
    NSMutableData *keyFrame;
    
    int outputWidth;
    int outputHeight;
    
    //opengles
    EAGLContext *glContext;
    GLuint frameBuf;
    GLuint renderBuf;
    GLuint program;
    GLuint textureYUV[3];
}

@end

@implementation GSMpegPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        avcodec_register_all();
        frame = av_frame_alloc();
        codec = avcodec_find_decoder(AV_CODEC_ID_H264);
        codecCtx = avcodec_alloc_context3(codec);
        int ret = avcodec_open2(codecCtx, codec, nil);
        if (ret) {
            NSLog(@"open codec failed! : %d", ret);
        }
        
        socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        keyFrame = [[NSMutableData alloc] init];
        
        outputWidth = [UIScreen mainScreen].bounds.size.width - 20;
        outputHeight = 100;
        
        unsigned char startcode[] = {0, 0, 1};
        startcodeData = [NSData dataWithBytes:startcode length:3];
    }
    
    return self;
}

- (void)openglesInit {
    CAEAGLLayer *eagLayer = [CAEAGLLayer layer];
    eagLayer.opaque = YES;
    eagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!glContext) {
        glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (!glContext) {
            glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        }
    }
    
    if (!glContext || [EAGLContext setCurrentContext:glContext]) {
        NSLog(@"EAGLContext init failed");
        return ;
    }
    
    [self setupYUVTexture];
    
}

- (void)dealloc {
    // Free scaler
    if(img_convert_ctx)sws_freeContext(img_convert_ctx);
    
    // Free the YUV frame
    if(frame)av_frame_free(&frame);
    
    // Close the codec
    if (codecCtx) avcodec_close(codecCtx);
}

- (void)start {
    NSError *error = nil;
//    [socket connectToAddress:@"http://www.51gif.com" error:&error];
    [socket connectToHost:@"192.168.1.190" onPort:6666 withTimeout:-1 error:&error];
    NSLog(@"error : %@", error);
    
    if (!error) {
        [socket readDataToData:startcodeData withTimeout:-1 tag:0];
    }
}

#pragma mark - delegate method
#pragma mark   GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [socket readDataToData:startcodeData withTimeout:-1 tag:Data];
    
    if (tag == Data) {
        int type = [self typeOfNalu:data];
        
        //5:IDR帧 6: 7:SPS 8:PPS
        if (type == 5||type == 6||type == 7||type == 8) {
            [keyFrame appendData:lastStartCode];
            [keyFrame appendBytes:[data bytes] length:[data length]-[self startCodeLenth:data]];
        }
        
        //收到IDR帧表示NALU结束
        if (type == 5||type == 1) {
            //IDR P frame
            int nalLen = (int)[keyFrame length];
            av_new_packet(&packet, nalLen);
            memcpy(packet.data, [keyFrame bytes], nalLen);
            keyFrame = [[NSMutableData alloc] init];  //reset keyframe
        } else {
            NSMutableData *nalu = [[NSMutableData alloc] initWithData:lastStartCode];
            [nalu appendBytes:[data bytes] length:[data length]-[self startCodeLenth:data]];
            int nalLen = (int)[nalu length];
            av_new_packet(&packet, nalLen);
            memcpy(packet.data, [nalu bytes], nalLen);
        }
        
        int ret, got_picture;
#warning use deprecated method
        ret = avcodec_decode_video2(codecCtx, frame, &got_picture, &packet);
        
        if (ret < 0) {
            NSLog(@"decode error!");
            return ;
        }
        
        if (!got_picture) {
            NSLog(@"Didn't get picture!");
            return ;
        }
        
        static int sws_flags = SWS_FAST_BILINEAR; //解压算法
        if (!img_convert_ctx) {
            img_convert_ctx = sws_getContext(codecCtx->width, codecCtx->height, codecCtx->pix_fmt, outputWidth, outputHeight, AV_PIX_FMT_YUV420P, sws_flags, NULL, NULL, NULL);
            
            avpicture_alloc(&picture, AV_PIX_FMT_YUV420P, outputWidth, outputHeight);
            ret = sws_scale(img_convert_ctx, (const uint8_t *const *)frame->data, frame->linesize, 0, frame->height, picture.data, picture.linesize);
            
            [self display];
            avpicture_free(&picture);
//            av_free_packet(&packet);
            av_packet_unref(&packet);
        }
    }
    
    [self saveStartCode:data];
}

#pragma mark
- (void)display {
    NSLog(@"%s", __func__);
    
    
}

#pragma mark - helper
- (int)typeOfNalu:(NSData *)data {
    char first = *(char *)[data bytes];
    return first & 0x1f;
}

- (int)startCodeLenth:(NSData *)data {
    char temp = *((char *)[data bytes] + [data length] - 4);
    return temp == 0x00 ? 4 : 3;
}

- (void)saveStartCode:(NSData *)data {
    int startCodeLen = [self startCodeLenth:data];
    NSRange startCodeRange = {[data length] - startCodeLen, startCodeLen};
    lastStartCode = [data subdataWithRange:startCodeRange];
}

- (void)shutdown {
    if(socket)[socket disconnect];
}

- (void)setupYUVTexture {
    
    
}
@end
