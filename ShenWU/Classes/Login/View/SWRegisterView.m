//
//  SWRegisterView.m
//  ShenWU
//
//  Created by Amy on 2024/6/19.
//

#import "SWRegisterView.h"
#import "YXKeychain.h"
#import "SWRealNameViewController.h"
#import "SWRemoteLoginViewController.h"
#import "PForgotPasswordViewController.h"
@interface SWRegisterView ()
@property(nonatomic, strong) UITextField *phoneTextField;
@property(nonatomic, strong) UITextField *codeTextField;
@property(nonatomic, strong) UITextField *passwordTextField;
@property(nonatomic, strong) UITextField *againTextField;
@property(nonatomic, strong) UIButton *codeBtn;
@property(nonatomic, assign) NSInteger timeCount;
@property(nonatomic, strong) NSTimer *codeTimer;
@property(nonatomic, strong) UIButton *registerBtn;
@end

@implementation SWRegisterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *phoneBgView = [[UIView alloc] init];
        phoneBgView.frame = CGRectMake(24, 31, self.width - 48, 40);
        phoneBgView.backgroundColor = RGBColor(0xF8F8F8);
        phoneBgView.layer.cornerRadius = 20;
        [self addSubview:phoneBgView];
        
        UIImageView *phoneImgView = [FControlTool createImageView];
        phoneImgView.frame = CGRectMake(16, 8, 24, 24);
        phoneImgView.image = [UIImage imageNamed:@"icn_login_phone"];
        [phoneBgView addSubview:phoneImgView];
        
        self.phoneTextField = [[UITextField alloc] init];
        self.phoneTextField.frame = CGRectMake(phoneImgView.right+12, 0, phoneBgView.width - (phoneImgView.right+28), 40);
        NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName:RGBColor(0xC8C9CC),NSFontAttributeName:[UIFont fontWithSize:15]}];
        self.phoneTextField.attributedPlaceholder = placeholderString;
        self.phoneTextField.font = [UIFont fontWithSize:15];
        self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        self.phoneTextField.textColor = RGBColor(0x333333);
        [phoneBgView addSubview:self.phoneTextField];
        
        
        UIView *codeBgView = [[UIView alloc] init];
        codeBgView.frame = CGRectMake(24, phoneBgView.bottom+24, self.width - 48, 40);
        codeBgView.backgroundColor = RGBColor(0xF8F8F8);
        codeBgView.layer.cornerRadius = 20;
        [self addSubview:codeBgView];
        
        UIImageView *codeImgView = [FControlTool createImageView];
        codeImgView.frame = CGRectMake(16, 8, 24, 24);
        codeImgView.image = [UIImage imageNamed:@"icn_login_code"];
        [codeBgView addSubview:codeImgView];
        
        self.codeTextField = [[UITextField alloc] init];
        self.codeTextField.frame = CGRectMake(codeImgView.right+12, 0, codeBgView.width - (codeImgView.right+28), 40);
        NSAttributedString *codePlaceholderString = [[NSAttributedString alloc] initWithString:@"输入验证码" attributes:@{NSForegroundColorAttributeName:RGBColor(0xC8C9CC),NSFontAttributeName:[UIFont fontWithSize:15]}];
        self.codeTextField.attributedPlaceholder = codePlaceholderString;
        self.codeTextField.font = [UIFont fontWithSize:14];
        self.codeTextField.keyboardType = UIKeyboardTypePhonePad;
        self.codeTextField.textColor = RGBColor(0x333333);
        [codeBgView addSubview:self.codeTextField];
        
        self.codeBtn = [FControlTool createButton:@"发送验证码" font:[UIFont fontWithSize:14] textColor:kMainColor target:self sel:@selector(codeBtnAction)];
        self.codeBtn.frame = CGRectMake(codeBgView.width - 88, 10, 75, 24);
        self.codeBtn.backgroundColor = UIColor.clearColor;
        self.codeBtn.layer.cornerRadius = 12;
        self.codeBtn.layer.masksToBounds = YES;
        [codeBgView addSubview:self.codeBtn];
        
        UIView *passwordBgView = [[UIView alloc] init];
        passwordBgView.frame = CGRectMake(24, codeBgView.bottom+24, self.width - 48, 40);
        passwordBgView.backgroundColor = RGBColor(0xF8F8F8);
        passwordBgView.layer.cornerRadius = 20;
        [self addSubview:passwordBgView];
        
        UIImageView *passwordImgView = [FControlTool createImageView];
        passwordImgView.frame = CGRectMake(16, 8, 24, 24);
        passwordImgView.image = [UIImage imageNamed:@"icn_login_password"];
        [passwordBgView addSubview:passwordImgView];
        
        self.passwordTextField = [[UITextField alloc] init];
        self.passwordTextField.frame = CGRectMake(passwordImgView.right+12, 0, passwordBgView.width - (passwordImgView.right+28), 40);
        NSAttributedString *passwordPlaceholderString = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:RGBColor(0xC8C9CC),NSFontAttributeName:[UIFont fontWithSize:15]}];
        self.passwordTextField.attributedPlaceholder = passwordPlaceholderString;
        self.passwordTextField.font = [UIFont fontWithSize:14];
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.textColor = RGBColor(0x333333);
        [passwordBgView addSubview:self.passwordTextField];
        
        UIView *againBgView = [[UIView alloc] init];
        againBgView.frame = CGRectMake(24, passwordBgView.bottom+24, self.width - 48, 40);
        againBgView.backgroundColor = RGBColor(0xF8F8F8);
        againBgView.layer.cornerRadius = 20;
        [self addSubview:againBgView];
        
        UIImageView *againImgView = [FControlTool createImageView];
        againImgView.frame = CGRectMake(16, 8, 24, 24);
        againImgView.image = [UIImage imageNamed:@"icn_login_password"];
        [againBgView addSubview:againImgView];
        
        self.againTextField = [[UITextField alloc] init];
        self.againTextField.frame = CGRectMake(againImgView.right+12, 0, againBgView.width - (againImgView.right+28), 40);
        NSAttributedString *againPlaceholderString = [[NSAttributedString alloc] initWithString:@"请再次输入密码" attributes:@{NSForegroundColorAttributeName:RGBColor(0xC8C9CC),NSFontAttributeName:[UIFont fontWithSize:15]}];
        self.againTextField.attributedPlaceholder = againPlaceholderString;
        self.againTextField.font = [UIFont fontWithSize:14];
        self.againTextField.secureTextEntry = YES;
        self.againTextField.textColor = RGBColor(0x333333);
        [againBgView addSubview:self.againTextField];
        
        UIButton *passwordBtn = [FControlTool createButton:@"忘记密码？" font:[UIFont fontWithSize:14] textColor:kMainColor target:self sel:@selector(passwordBtnAction)];
        passwordBtn.frame = CGRectMake(24, againBgView.bottom+24, self.width - 48, 17);
        passwordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:passwordBtn];
        
        self.registerBtn = [FControlTool createCommonButton:@"注册" font:[UIFont boldFontWithSize:16] cornerRadius:8 size:CGSizeMake(self.width - 24, 44) target:self sel:@selector(registerBtnAction)];
        self.registerBtn.frame = CGRectMake(12, againBgView.bottom+88, self.width - 24, 44);
        self.registerBtn.backgroundColor = kMainColor;
        self.registerBtn.layer.cornerRadius = 8;
        self.registerBtn.layer.masksToBounds = YES;
        [self addSubview:self.registerBtn];
        
        UILabel *versionLabel = [FControlTool createLabel:[NSString stringWithFormat:@"版本号：%@",AppBuildVersion] textColor:RGBColor(0x323233) font:[UIFont fontWithSize:13]];
        versionLabel.frame = CGRectMake(0, self.registerBtn.bottom+16, self.width, 15);
        versionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:versionLabel];
    }
    return self;
}

- (void)setIsForgot:(BOOL)isForgot{
    _isForgot = isForgot;
    
    [self.registerBtn setTitle:@"登录" forState:UIControlStateNormal];
}

- (void)codeBtnAction{
    [[FVerifyCodeManager sharedManager] getVerifyCodeOnVC:[FControlTool getCurrentVC] requestUrl:@"/customer/smsCode" andPhone:self.phoneTextField.text success:^{
        [self startTimer];
    } cancel:^{
        
    }];
}

- (void)registerBtnAction{
    
    NSString *phone = self.phoneTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *password = self.passwordTextField.text;
    if (phone.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入完整的手机号"];
        return;
    }
    if (code.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (![FDataTool isStringContainABCandNumberWith:password] || !(password.length > 7 && password.length < 13)) {
        [SVProgressHUD showErrorWithStatus:@"密码太简单，请重新设置"];
        return;
    }
    if (self.isForgot) {
        [self updatePassword];
        return;
    }
    NSDictionary *params = @{@"phoneNo":self.phoneTextField.text, @"password":self.passwordTextField.text, @"deviceId":[YXKeychain getDeviceIDInKeychain], @"clientType":@"IOS", @"captcha":self.codeTextField.text};
    @weakify(self);
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/customer/register" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            /// success
            NSDictionary *userDict = response[@"data"];
            [[FUserModel sharedUser] saveUserInfoWithPhone:userDict[@"phoneNo"] NickName:userDict[@"username"] ImToken:userDict[@"imToken"] UserID:userDict[@"userId"] memberCode:userDict[@"memberCode"] AndUserToken:userDict[@"token"] avator:userDict[@"avatar"] AndVipLevel:userDict[@"grade"]AndAuthentication:userDict[@"verified"]];
            [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
            [weak_self showRealName];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)updatePassword{
    NSString *phone = self.phoneTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *password = self.passwordTextField.text;
    NSDictionary *params = @{@"phoneNo":self.phoneTextField.text, @"password":self.passwordTextField.text, @"captcha":self.codeTextField.text};
    [SVProgressHUD show];
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:@"/customer/updatePassword" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [weak_self requestLogin];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)requestLogin{
    NSDictionary *params = @{@"phoneNo":self.phoneTextField.text, @"password":self.passwordTextField.text, @"deviceId":[YXKeychain getDeviceIDInKeychain], @"clientType":@"IOS"};
    @weakify(self);
    [[FNetworkManager sharedManager] postRequestFromServer:@"/customer/login" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            NSDictionary *userDict = response[@"data"];
            [[FUserModel sharedUser] saveUserInfoWithPhone:userDict[@"phoneNo"] NickName:userDict[@"username"] ImToken:userDict[@"imToken"] UserID:userDict[@"userId"] memberCode:userDict[@"memberCode"] AndUserToken:userDict[@"token"] avator:userDict[@"avatar"] AndVipLevel:userDict[@"grade"] AndAuthentication:userDict[@"verified"]];
            [kAppDelegate loginIM:^(BOOL success) {
                if (success) {
                    [kAppDelegate initTabBarController];
                }
            }];
        }else if ([response[@"code"] integerValue] == 601) {
            [SVProgressHUD showInfoWithStatus:response[@"msg"]];
            /// 异地登录
            [SVProgressHUD dismiss];
            SWRemoteLoginViewController *vc = [[SWRemoteLoginViewController alloc] init];
            vc.phone = self.phoneTextField.text;
            [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        }else if ([response[@"code"] integerValue] == 777) {
            [SVProgressHUD dismiss];
            SWRealNameViewController *vc = [[SWRealNameViewController alloc] init];
            [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)showRealName{
    SWRealNameViewController *vc = [[SWRealNameViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)startTimer
{
    self.timeCount = 60;
    [self.codeTimer invalidate];
    self.codeBtn.enabled = NO;
    @weakify(self)
    self.codeTimer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        self.timeCount -= 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self changeCodeBtnStatus];
        });
        if (self.timeCount <= 0) {
            [self.codeTimer invalidate];
        }
    }];
    [self.codeTimer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.codeTimer forMode:NSRunLoopCommonModes];
}

- (void)changeCodeBtnStatus{
    if (self.timeCount != 0) {
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)self.timeCount] forState:UIControlStateNormal];
    }else{
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
}

- (void)passwordBtnAction{
    PForgotPasswordViewController *vc = [[PForgotPasswordViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
