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
#import <JavaScriptCore/JavaScriptCore.h>

#import <SDWebImageManager.h>

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, nonnull) UIWebView *webView;
@property (nonatomic, nonnull) UIButton *sizeBtn;  //改变大小的按钮
@property (nonatomic)   WebViewJavascriptBridge *bridge;  //原生代码和js代码交互的桥接

@property (nonatomic) NSArray *scaleArr;
@property (nonatomic) NSInteger index;

@property (nonatomic, nonnull) UIButton *refreshBtn;
@property (nonatomic, nonnull, copy) NSArray *imgArr;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    
    [self.view addSubview:self.refreshBtn];
    [self.view addSubview:self.webView];
//    [self.view addSubview:self.sizeBtn];
    
    [WebViewJavascriptBridge enableLogging];  //调试
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    [self.bridge callHandler:@"bindImages" data:nil responseCallback:^(id responseData) {
        self.imgArr = [responseData[@"data"] copy];
        [self downAllImgs];
    }];
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
    
    
    [self injectJs:@"debuggap" type:@"js" webView:webView];
    [self injectJs:@"imageClick" type:@"js" webView:webView];
    [self injectJs:@"lazyLoad" type:@"js" webView:webView];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%s", __func__);
}


#pragma mark - event response
//刷新
- (void)handleRefresh:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WebViewDemo" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    html = [self dealWithLocalHtml:html];
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:path]];
}

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

#pragma mark - private method
- (void)initNav {
    self.navigationItem.title = @"WebViewDemo";
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

//处理本地html 替换img标签中的src属性
- (NSString *)dealWithLocalHtml:(NSString *)html {
    
    NSString *updatedHtml = [html stringByReplacingOccurrencesOfString:@"src" withString:@"sbsrc"];
    return updatedHtml;
}

//在本地下载网页中的图片
- (void)downAllImgs {
    for (NSDictionary *each in self.imgArr) {
        NSString *imgSrc = each[@"src"];
        SDWebImageManager *imgManager = [SDWebImageManager sharedManager];
        
        [imgManager downloadImageWithURL:[NSURL URLWithString:imgSrc] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                
                //后台线程异步从缓存里面获取图片
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *img64 = [UIImageJPEGRepresentation(image, 1.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    NSString *key = [imgManager cacheKeyForURL:[NSURL URLWithString:imgSrc]];
                    NSString *source = [NSString stringWithFormat:@"data:image/png;base64,%@", img64];
                    
                    [_bridge callHandler:@"finishDownloadImgs" data:@[key, source] responseCallback:^(id responseData) {
                        NSLog(@"加载本地图片完成");
                    }];
                });
            }
        }];
    }
}

//尝试获取缓存在本地的页面
- (void)fetchPageFromLocal {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [paths firstObject];
    
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
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64+44, SCREENWIDTH, SCREENTHEIGHT-64-44)];
        _webView.delegate =self;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WebViewDemo" ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        html = [self dealWithLocalHtml:html];
        [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:path]];
        
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://zhuanlan.zhihu.com/p/23922445"]]];
    }
    return _webView;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 44)];
        [_refreshBtn setTitle:@"refresh" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [_refreshBtn addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}

@end
