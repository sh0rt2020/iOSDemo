//
//  GSPlayerHelper.m
//  VideoDemo
//
//  Created by iosdevlope on 2017/7/27.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "GSPlayerHelper.h"
#import "GSMpegPlayer.h"

@interface GSPlayerHelper () {
    AVFormatContext *pFormatCtx;
    int videoIndex;
    AVCodecContext *pCodecCtx;
    AVCodec *pCodec;
    
    GSMpegPlayer *player;
}

@end

@implementation GSPlayerHelper
#pragma mark - public
- (void)playWithFilePath:(NSString *)filePath {
    const char *videoPath = [filePath UTF8String];
    
    av_register_all();
    avformat_network_init();
    pFormatCtx = avformat_alloc_context();
    if (avformat_open_input(&pFormatCtx, videoPath, NULL, NULL) != 0) {
        NSLog(@"Couldn't open input stream.\n");
        exit(1);
    }
    
    if (avformat_find_stream_info(pFormatCtx, NULL) < 0) {
        NSLog(@"Couldn't find stream info.\n");
        exit(1);
    }
    
    videoIndex = -1;
    for (int i = 0; i < pFormatCtx->nb_streams; i++) {
        if (pFormatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
            videoIndex = i;
            break;
        }
    }
    
    if (videoIndex == -1) {
        NSLog(@"Didn't find a video stream.\n");
        exit(1);
    }
    
    pCodecCtx = pFormatCtx->streams[videoIndex]->codec;
    pCodec = avcodec_find_decoder(pCodecCtx->codec_id);
    if (pCodec==NULL) {
        NSLog(@"Codec not found.\n");
        exit(1);
    }
    
    if (avcodec_open2(pCodecCtx, pCodec, NULL) < 0) {
        NSLog(@"Could not open codec.\n");
        exit(1);
    }
    
    AVFrame *pFrame,*pFrameYUV;
    pFrame = av_frame_alloc();
    pFrameYUV = av_frame_alloc();
    uint8_t *out_buffer;
    out_buffer=new uint8_t[avpicture_get_size(AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height)];
    avpicture_fill((AVPicture *)pFrameYUV, out_buffer, AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height);
    
    int ret, got_picture;
    int y_size = pCodecCtx->width * pCodecCtx->height;
    
    AVPacket *packet=(AVPacket *)malloc(sizeof(AVPacket));
    av_new_packet(packet, y_size);
    
    printf("video infomation：\n");
    av_dump_format(pFormatCtx,0,videoPath,0);
    
    while(av_read_frame(pFormatCtx, packet)>=0) {
        if(packet->stream_index==videoIndex) {
            ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);
            if(ret < 0) {
                printf("Decode Error.\n");
                exit(1);
            }
            
            if(got_picture) {
                char *buf = (char *)malloc(pFrame->width * pFrame->height * 3 / 2);
                
                AVPicture *pict;
                int w, h;
                char *y, *u, *v;
                pict = (AVPicture *)pFrame;//这里的frame就是解码出来的AVFrame
                w = pFrame->width;
                h = pFrame->height;
                y = buf;
                u = y + w * h;
                v = u + w * h / 4;
                
                for (int i=0; i<h; i++)
                    memcpy(y + w * i, pict->data[0] + pict->linesize[0] * i, w);
                for (int i=0; i<h/2; i++)
                    memcpy(u + w / 2 * i, pict->data[1] + pict->linesize[1] * i, w / 2);
                for (int i=0; i<h/2; i++)
                    memcpy(v + w / 2 * i, pict->data[2] + pict->linesize[2] * i, w / 2);
                
                [player setVideoSize:pFrame->width height:pFrame->height];
                [player displayYUV420PData:buf width:pFrame->width height:pFrame->height];
                free(buf);
            }
        }
        av_free_packet(packet);
    }
    delete[] out_buffer;
    av_free(pFrameYUV);
    avcodec_close(pCodecCtx);
    avformat_close_input(&pFormatCtx);
}
@end
