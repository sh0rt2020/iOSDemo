//
//  ViewController.m
//  GifToVideoDemo
//
//  Created by iosdevlope on 2017/10/13.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//


#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "VideoAndAudioMerger.h"


@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.button];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate 

#pragma mark - event
- (void)handleButtonAction:(UIButton *)sender {
    VideoAndAudioMerger *merger = [[VideoAndAudioMerger alloc] initWithVideoContainer:self.imageView];
    [merger convertAndMerge];
}

#pragma mark - private


#pragma mark - setter & getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, SCREENW, 300);
        _imageView.backgroundColor = [UIColor orangeColor];
    }
    return _imageView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.frame = CGRectMake(0, self.imageView.frame.size.height + 50, SCREENW, 100);
        _button.backgroundColor = [UIColor greenColor];
        [_button setTitle:@"开始合成" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
@end
