//
//  SWWebViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/7.
//

#import "SWWebViewController.h"
#import <WebKit/WebKit.h>
@interface SWWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>
@property(nonatomic , strong) WKWebView *serviceView;
@property(nonatomic , strong) WKWebViewConfiguration *webConfiguration;
@property(nonatomic , strong) CALayer *progresslayer;
@end

@implementation SWWebViewController

- (void)dealloc{
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(bool)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.webConfiguration = [WKWebViewConfiguration new];
//        self.webConfiguration.selectionGranularity = WKSelectionGranularityDynamic;
//        self.webConfiguration.allowsInlineMediaPlayback = YES;
                
        WKPreferences *preferences = [WKPreferences new];
//        preferences.javaScriptEnabled = YES;
//        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        self.webConfiguration.preferences = preferences;
        self.serviceView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight) configuration:self.webConfiguration];
        
        self.serviceView.backgroundColor = [UIColor clearColor];
        self.serviceView.UIDelegate = self;
        self.serviceView.navigationDelegate = self;
        self.serviceView.scrollView.delegate = self;
        self.serviceView.allowsBackForwardNavigationGestures = YES;
        self.serviceView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self.view addSubview:self.serviceView];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [self.serviceView loadRequest:request];
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
        self.navigationController.navigationBar.titleTextAttributes = attribute;
        
        
        UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, CGRectGetWidth(self.view.frame), 3)];
        progress.backgroundColor = [UIColor clearColor];
        [self.view addSubview:progress];
            
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 3);
        layer.backgroundColor = [UIColor colorWithHexString:@"#BDBDBD"].CGColor;
        [progress.layer addSublayer:layer];
        self.progresslayer = layer;
        
        [self.serviceView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    });
    
    
}

- (void)backButtonAction{
    if(self.serviceView.canGoBack){
        [self.serviceView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addBackBtn{
//    if(self.serviceView.canGoBack){
//        UIButton *button = [[UIButton alloc] init];
//        [button setImage:[UIImage imageNamed:@"icn_nav_back"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        button.frame = CGRectMake(0, 0, 30, 44);
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        UIBarButtonItem *barBut = [[UIBarButtonItem alloc] initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = barBut;
//    }else{
//        self.navigationItem.leftBarButtonItem = nil;
//    }
    
}

- (void)setUrlStr:(NSString *)urlStr{
    NSDictionary *dict = @{@"url":BaseUrl,@"token":kUserDefaultObjectForKey(UserToken),@"phone":[FUserModel sharedUser].phone};
    NSString *token = [FDataTool convertToJsonData:dict];
    NSString *aesToken = [AESUtil aesEncrypt:token AndKey:NetAesKey];
    _urlStr = [NSString stringWithFormat:@"%@?token=%@",urlStr,aesToken];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"method:%@", message.name);
    NSLog(@"params:%@", message.body);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    [self addBackBtn];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    [self addBackBtn];
    NSString* url = navigationAction.request.URL.absoluteString;
    NSLog(@"url === :%@",url);
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"title"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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
