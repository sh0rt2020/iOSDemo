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

@interface ViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

//@property (nonatomic, nonnull) UIWebView *webView;
@property (nonatomic, nonnull) WKWebView *webView;
@property (nonatomic, nonnull) UIButton *sizeBtn;  //改变大小的按钮
//@property (nonatomic)   WebViewJavascriptBridge *bridge;  //原生代码和js代码交互的桥接
@property (nonatomic)   WKWebViewJavascriptBridge *bridge;  //针对wkwebview
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, SCREENTHEIGHT-100)];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
//    self.webView.delegate =self;
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.github.com"]]];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"test3" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:nil];
    [self.view addSubview:self.webView];
    
    self.sizeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    self.sizeBtn.backgroundColor = [UIColor greenColor];
    [self.sizeBtn addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchUpInside];
    [self.sizeBtn setTitle:@"change font size" forState:UIControlStateNormal];
    [self.view addSubview:self.sizeBtn];
    
//    [WebViewJavascriptBridge enableLogging];  //调试
//    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
//    [self.bridge setWebViewDelegate:self];
    
    
    [WKWebViewJavascriptBridge enableLogging];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    id data = @{};
    [self.bridge callHandler:@"showYwDomainLogin" data:data responseCallback:^(id responseData) {
        NSLog(@"OC invoke Js succeed!");
    }];
    
    [self.bridge registerHandler:@"stopLocalMedia()" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"Js invoke OC succeed!");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    NSLog(@"%s", __func__);
//    return YES;
//}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"%s", __func__);
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"%s", __func__);
////    [self injectJs];  //注入js
////    [self interceptJs];
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSLog(@"%s", __func__);
//}

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
- (void)changeFont:(UIButton *)sender {
    CGFloat scale = 1.5;
    
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%@'", scale*100, @"%"]];
//    CGFloat scrollheight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
//    self.webView.scrollView.contentSize = CGSizeMake(SCREENWIDTH, scrollheight);
//    
//    CGFloat scrollheight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
//    self.webView.scrollView.contentSize = CGSizeMake(SCREENWIDTH, scrollheight);
//    CGRect newFrame = self.webView.frame;
//    newFrame.size.height = scrollheight;
//    self.webView.frame = newFrame;
}


- (void)showSFELoginPage {
    
    NSLog(@"%s", __func__);
}


#pragma mark - private method
//js注入
- (void)injectJs {
    //UIWebView
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"WebViewDemo" ofType:@"js"];
//    [self.webView stringByEvaluatingJavaScriptFromString:
//     [NSString stringWithFormat:@"var script = document.createElement('script');"
//      "script.type = 'text/javascript';"
//      "script.src = '%@';"
//      "document.getElementsByTagName('head')[0].appendChild(script);",path]];
    
    //WKWebView
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WebViewDemo" ofType:@"js"];
    NSString *js = [NSString stringWithFormat:@"var script = document.createElement('script');""script.type = 'text/javascript';""script.src = '%@';""document.getElementsByTagName('head')[0].appendChild(script);", path];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}

//拦截js
- (void)interceptJs {
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"showYwDomainLogin"] = ^() {
        NSLog(@"拦截js");
    };
}
@end
