//
//  ViewController.m
//  WebViewDemo
//
//  Created by Yige on 2016/11/18.
//  Copyright © 2016年 Yige. All rights reserved.
//

#define SCREENWIDTH     [[UIScreen mainScreen] bounds].size.width
#define SCREENTHEIGHT   [[UIScreen mainScreen] bounds].size.height

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, nonnull) UIWebView *webView;
@property (nonatomic, nonnull) UIButton *sizeBtn;  //改变大小的按钮
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, SCREENTHEIGHT-100)];
    self.webView.delegate =self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.github.com"]]];
    [self.view addSubview:self.webView];
    
    self.sizeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    self.sizeBtn.backgroundColor = [UIColor greenColor];
    [self.sizeBtn addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchUpInside];
    [self.sizeBtn setTitle:@"change font size" forState:UIControlStateNormal];
    [self.view addSubview:self.sizeBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"%s", __func__);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"%s", __func__);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%s", __func__);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%s", __func__);
}

#pragma mark - event response
- (void)changeFont:(UIButton *)sender {
    CGFloat scale = 1.5;
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%@'", scale*100, @"%"]];
    
    CGFloat scrollheight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    self.webView.scrollView.contentSize = CGSizeMake(SCREENWIDTH, scrollheight);
//    CGRect newFrame = self.webView.frame;
//    newFrame.size.height = scrollheight;
//    self.webView.frame = newFrame;
}
@end
