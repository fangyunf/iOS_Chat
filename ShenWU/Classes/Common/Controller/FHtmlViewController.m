//
//  FHtmlViewController.m
//  Fiesta
//
//  Created by Amy on 2024/6/17.
//

#import "FHtmlViewController.h"
#import <WebKit/WebKit.h>

@interface FHtmlViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
@property(nonatomic , strong) WKWebView *advWebView;
@property(nonatomic , strong) WKWebViewConfiguration *webConfiguration;
@end

@implementation FHtmlViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _webConfiguration = [WKWebViewConfiguration new];
    _webConfiguration.selectionGranularity = WKSelectionGranularityDynamic;
    _webConfiguration.allowsInlineMediaPlayback = YES;
    WKPreferences *preferences = [WKPreferences new];
    //是否支持JavaScript
    preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    _webConfiguration.preferences = preferences;

    _advWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight) configuration:_webConfiguration];
    
    _advWebView.backgroundColor = [UIColor clearColor];
    _advWebView.UIDelegate = self;
    _advWebView.navigationDelegate = self;
    _advWebView.scrollView.delegate = self;
    _advWebView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:_advWebView];
    
    if (![NSString isEmptyString:self.localHTMLParh]) {
        NSString *htmlString = [NSString stringWithContentsOfFile:self.localHTMLParh encoding:NSUTF8StringEncoding error:nil];
        [_advWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:self.localHTMLParh]];
    }else{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
        [_advWebView loadRequest:request];
    }
    
}

#pragma mark - WKNavigationDelegate

// 网页中的每一个请求都会被触发  https://weibo.com/2660602543/EzLIQwHMg?from=page_1006062660602543_profile&wvr=6&mod=weibotime&type=comment#_rnd1489484233472
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}


- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (error) { return; }
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (error) { return; }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

