//
//  ViewController.m
//  VideoDemo
//
//  Created by Yige on 2016/11/28.
//  Copyright © 2016年 Yige. All rights reserved.
//

#import "ViewController.h"
#import <TXRTMPSDK/TXLivePush.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <TXLivePushListener>

@property (nonatomic) TXLivePushConfig *config;
@property (nonatomic) TXLivePush *push;
@property (nonatomic) UIView *startView;  //用于渲染摄像头画面
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"SDK Version = %@", [[TXLivePush getSDKVersion] componentsJoinedByString:@"."]);
    
    [self initConfig];
    [self initUI];
    [self start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - delegate method
-(void) onPushEvent:(int)EvtID withParam:(NSDictionary*)param {
    NSLog(@"%s", __func__);
}

-(void) onNetStatus:(NSDictionary*) param {
    NSLog(@"%s", __func__);
}


#pragma mark - event response

#pragma mark - private method
- (void)initConfig {
    self.config = [[TXLivePushConfig alloc] init];
    self.config.pauseTime = 300;
    self.config.pauseFps = 10;
    self.config.frontCamera = NO;
    self.config.pauseImg = [UIImage imageNamed:@"pause_publish.jpg"];
    self.config.watermark = [UIImage imageNamed:@"watermark.png"];
    self.config.enableHWAcceleration = YES;  //iOS平台推荐开启硬件加速
    self.push = [[TXLivePush alloc] initWithConfig:self.config];
    [self.push setLogLevel:LOGLEVEL_DEBUG];
    self.push.delegate = self;
}

- (void)initUI {
    self.startView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.startView];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (BOOL)start {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied) {
        [self toastTip:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限"];
        return NO;
    }
    
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusDenied) {
        [self toastTip:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限"];
        return NO;
    }
    
    NSString *rtmpUrl = @"rtmp://2000.livepush.myqcloud.com/live/2000_1f4652b179af11e69776e435c87f075e?bizid=2000";
    if ([self.push startPush:rtmpUrl] != 0) {
        [self toastTip:@"推流器启动失败"];
        return NO;
    }
    
    [self.push startPreview:self.startView];
    return YES;
}

- (void)stop {
    if (self.push) {
        self.push.delegate = nil;
        [self.push stopPush];
        [self.push stopPreview];
    }
}

- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void) toastTip:(NSString*)toastInfo {
    
    CGRect frameRC = [[UIScreen mainScreen] bounds];
    frameRC.origin.y = frameRC.size.height - 110;
    frameRC.size.height -= 110;
    __block UITextView * toastView = [[UITextView alloc] init];
    
    toastView.editable = NO;
    toastView.selectable = NO;
    
    frameRC.size.height = [self heightForString:toastView andWidth:frameRC.size.width];
    
    toastView.frame = frameRC;
    
    toastView.text = toastInfo;
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha = 0.5;
    
    [self.view addSubview:toastView];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(){
        [toastView removeFromSuperview];
        toastView = nil;
    });
}
@end
