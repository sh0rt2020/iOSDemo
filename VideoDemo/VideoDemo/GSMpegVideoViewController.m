//
//  GSMpegVideoViewController.m
//  VideoDemo
//
//  Created by iosdevlope on 2017/5/26.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "GSMpegVideoViewController.h"
#import "GSPlayerHelper.h"
#import "GSMpegPlayer.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface GSMpegVideoViewController ()
//@property (nonatomic, strong) GSMpegPlayer *player;
@property (nonatomic, strong) GSPlayerHelper *helper;
@end

@implementation GSMpegVideoViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.helper = [GSPlayerHelper sharedPlayerHelper];
    [self.view addSubview:self.helper];
    [self.helper playWithFilePath:@"http://gifs.51gif.com/20170325/video/17a2edb3369e4f2889f1dc097a86105a.mp4"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate


#pragma mark - event


#pragma mark - private


@end
