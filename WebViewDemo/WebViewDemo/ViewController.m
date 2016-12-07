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
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge.h>
#import <WKWebViewJavascriptBridge.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIWebViewDelegate>

@property (nonatomic, nonnull) UIWebView *webView;
//@property (nonatomic, nonnull) WKWebView *webView;
@property (nonatomic, nonnull) UIButton *sizeBtn;  //改变大小的按钮
@property (nonatomic)   WebViewJavascriptBridge *bridge;  //原生代码和js代码交互的桥接
//@property (nonatomic)   WKWebViewJavascriptBridge *bridge;  //针对wkwebview

@property (nonatomic) NSArray *scaleArr;
@property (nonatomic) NSInteger index;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.scaleArr = @[@1.2, @1.6, @0.7, @0.4, @2.0];
    
    [self.view addSubview:self.webView];
//    [self.view addSubview:self.sizeBtn];
    
    [WebViewJavascriptBridge enableLogging];  //调试
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    [self.bridge registerHandler:@"imageClickHandler" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"点击图片");
    }];
    
    
//    [WKWebViewJavascriptBridge enableLogging];
//    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
//    [self.bridge setWebViewDelegate:self];
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
    
    [self injectJs:@"imageClick" type:@"js" webView:webView];
    [self.bridge callHandler:@"bindImages" data:nil responseCallback:^(id responseData) {
        NSLog(@"绑定图片");
    }];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%s", __func__);
}




#pragma mark - WKUIDelegate
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo {
    return YES;
}

- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __func__);
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __func__);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __func__);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    //针对https支持  ios8.0不支持 apple的bug
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //实现js交互
}

#pragma mark - event response
//改变字体大小
- (void)changeFont:(UIButton *)sender {
    self.index ++;
    CGFloat scale = [self.scaleArr[self.index] floatValue];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%@'", scale*100, @"%"]];

    CGFloat scrollheight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    self.webView.scrollView.contentSize = CGSizeMake(SCREENWIDTH, scrollheight);
    CGRect newFrame = self.webView.frame;
    newFrame.size.height = scrollheight;
    self.webView.frame = newFrame;
}

//web调起原生页面
- (void)showSFELoginPage {
    
    NSLog(@"%s", __func__);
}


#pragma mark - private method
//WKWebView注入js
- (void)wkInjectJs {
    //WKWebView
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"WebViewDemo" ofType:@"js"];
//    NSString *js = [NSString stringWithFormat:@"var script = document.createElement('script');""script.type = 'text/javascript';""script.src = '%@';""document.getElementsByTagName('head')[0].appendChild(script);", path];
//    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        
//    }];
}

//注入js
- (void)injectJs:(NSString *)fileName type:(NSString *)fileType webView:(UIWebView *)webView {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    NSString *appendJs = [NSString stringWithFormat:@"var script = document.createElement('script');"
                          "script.type = 'text/javascript';"
                          "script.src = '%@';"
                          "document.getElementsByTagName('head')[0].appendChild(script);", path];
    [webView stringByEvaluatingJavaScriptFromString:appendJs];
}

//拦截js
- (void)interceptJs {
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"showYwDomainLogin"] = ^() {
        NSLog(@"拦截js");
    };
}

#pragma mark - setter&getter
- (UIButton *)sizeBtn {
    if (!_sizeBtn) {
        _sizeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
        _sizeBtn.backgroundColor = [UIColor greenColor];
        [_sizeBtn addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchUpInside];
        [_sizeBtn setTitle:@"change font size" forState:UIControlStateNormal];
    }
    return _sizeBtn;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENTHEIGHT)];
        _webView.delegate =self;
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://zhuanlan.zhihu.com/p/23922445"]]];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WebViewDemo" ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:html baseURL:nil];
    }
    return _webView;
}
@end
