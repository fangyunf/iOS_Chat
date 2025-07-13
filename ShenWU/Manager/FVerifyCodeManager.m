//
//  FVerifyCodeManager.m
//  Fiesta
//
//  Created by Amy on 2024/6/6.
//

#import "FVerifyCodeManager.h"
#import <VerifyCode/NTESVerifyCodeManager.h>
#import "FVerifyAlertView.h"
#import <Masonry/Masonry.h>
@interface FVerifyCodeManager ()<NTESVerifyCodeManagerDelegate>

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) UIViewController *vc;

@property (nonatomic, strong) void(^managerSuccessBlock)(void);

@property (nonatomic, strong) void(^managerCanccelBlock)(void);

@property (nonatomic, strong) NTESVerifyCodeManager *manager;

@property (nonatomic, strong) FVerifyAlertView *alertView;
@end

@implementation FVerifyCodeManager
+ (instancetype)sharedManager{
    static FVerifyCodeManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (void)getVerifyCodeOnVC:(UIViewController *)vc requestUrl:(NSString *)url andPhone:(NSString *)phone success:(void (^)(void))successBlock cancel:(void (^)(void))cancelBlock {
    self.vc = (vc && [vc isKindOfClass:[UIViewController class]]) ? vc : [FControlTool getCurrentVC];
    self.phone = phone;
    self.url = url;
    self.managerSuccessBlock = successBlock;
    self.managerCanccelBlock = cancelBlock;
    
    [SVProgressHUD show];
    @weakify(self);
    [[FNetworkManager sharedManager] postRequestFromServer:self.url parameters:@{@"phoneNo":phone} success:^(NSDictionary * _Nonnull response) {
        @strongify(self);
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = response[@"data"];
            if ([dataDict[@"type"] integerValue] == 0) {
                /// 直接发送
                if (successBlock) {
                    successBlock();
                }
            }else if ([dataDict[@"type"] integerValue] == 1) {
                /// 图片验证码
                [self startPhotoVerifyCode:[dataDict[@"image"] length] != 0 ? dataDict[@"image"] : @""];
                
            }else if ([dataDict[@"type"] integerValue] == 2) {
                /// 第三方行为验证
                [self startThirdVerifyCode];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            if (cancelBlock) {
                cancelBlock();
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (cancelBlock) {
            cancelBlock();
        }
    }];
}

- (void)nextRequestOnCode:(NSString *)code {
    [SVProgressHUD show];
    @weakify(self);
    [[FNetworkManager sharedManager] postRequestFromServer:self.url parameters:@{@"phoneNo":self.phone, @"validate":code} success:^(NSDictionary * _Nonnull response) {
        @strongify(self);
        if ([response[@"code"] integerValue] == 200) {
            /// 怕出现问题，为两百时在走一次逻辑判断
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = response[@"data"];
            if ([dataDict[@"type"] integerValue] == 0) {
                /// 直接发送
                if (self.alertView) {
                    [self.alertView removeFromSuperview];
                }
                if (self.managerSuccessBlock) {
                    self.managerSuccessBlock();
                }
            }else if ([dataDict[@"type"] integerValue] == 1) {
                /// 图片验证码
                [self startPhotoVerifyCode:[dataDict[@"image"] length] != 0 ? dataDict[@"image"] : @""];
                
            }else if ([dataDict[@"type"] integerValue] == 2) {
                /// 第三方行为验证
                [self startThirdVerifyCode];
            }
        }else if ([response[@"code"] integerValue] == 704) {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            /// 图片验证码
            NSString *imgStr = response[@"data"];
            [self startPhotoVerifyCode:[imgStr length] != 0 ? imgStr : @""];
        }else if ([response[@"code"] integerValue] == 705) {
            /// 第三方行为验证
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            [self startThirdVerifyCode];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            if (self.managerCanccelBlock) {
                self.managerCanccelBlock();
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (self.managerCanccelBlock) {
            self.managerCanccelBlock();
        }
    }];
}

- (void)startPhotoVerifyCode:(NSString *)imgStr {
    BOOL isHave = NO;
    for (UIView *view in self.vc.view.subviews) {
        if ([view isKindOfClass:[FVerifyAlertView class]]) {
            isHave = YES;
            break;
        }
    }
    if (!isHave) {
        self.alertView = [[FVerifyAlertView alloc] init];
        [self.vc.view addSubview:self.alertView];
        
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.vc.view).mas_offset(0);
        }];
    }
    self.alertView.smsImgUrl = imgStr;
    
    @weakify(self);
    self.alertView.clickOnSureBtn = ^(NSString * _Nonnull code) {
        @strongify(self);
        [self nextRequestOnCode:code];
    };
    self.alertView.clickOnRefreshBtn = ^{
        @strongify(self);
        [self getVerifyCodeOnVC:self.vc requestUrl:self.url andPhone:self.phone success:self.managerSuccessBlock cancel:self.managerCanccelBlock];
    };
    
}

- (void)startThirdVerifyCode {
    self.manager = [NTESVerifyCodeManager getInstance];
    [self.manager configureVerifyCode:VerifyKey timeout:1000];
    self.manager.delegate = self;
    self.manager.lang = NTESVerifyCodeLangCN;
    self.manager.alpha = 0.3;
    self.manager.userInterfaceStyle = NTESUserInterfaceStyleDark;
    self.manager.color = UIColor.blackColor;
    self.manager.protocol = NTESVerifyCodeProtocolHttps;
    self.manager.openFallBack = YES;
    self.manager.fallBackCount = 3;
    [self.manager openVerifyCodeView:nil];
}

#pragma mark - NTESVerifyCodeManagerDelegate
- (void)verifyCodeInitFinish {
    NSLog(@"chenggong");
}

- (void)verifyCodeInitFailed:(NSArray *)error {
    NSLog(@"%@", error);
}

- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message {
    [self nextRequestOnCode:validate];
}

- (void)verifyCodeCloseWindow:(NTESVerifyCodeClose)close {
    
}

@end
