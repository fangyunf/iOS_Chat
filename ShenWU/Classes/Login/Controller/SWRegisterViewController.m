//
//  SWRegisterViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/6.
//

#import "SWRegisterViewController.h"
#import "YXKeychain.h"
#import "SWRealNameViewController.h"
#import "SWRemoteLoginViewController.h"

@interface SWRegisterViewController ()
@property(nonatomic, strong) UIScrollView *bgScrollView;
@property(nonatomic, strong) UITextField *phoneTextField;
@property(nonatomic, strong) UITextField *codeTextField;
@property(nonatomic, strong) UITextField *passwordTextField;
@property(nonatomic, strong) UITextField *againTextField;
@property(nonatomic, strong) UIButton *hiddenBtn;
@property(nonatomic, strong) UIButton *againHiddenBtn;
@property(nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) UIButton *codeBtn;
@property(nonatomic, assign) NSInteger timeCount;
@property(nonatomic, strong) NSTimer *codeTimer;
@end

@implementation SWRegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTopView.hidden = YES;
    [self setWhiteNavBack];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    bgImgView.image = [UIImage imageNamed:@"bg_login"];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgImgView];
    
    self.bgScrollView = [[UIScrollView alloc] init];
    self.bgScrollView.frame = self.view.bounds;
    self.bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.bgScrollView];
    
    UIImageView *logoImgView = [[UIImageView alloc] init];
    logoImgView.frame = CGRectMake((kScreenWidth - 96)/2, kStatusBarHeight+40, 96, 96);
    logoImgView.image = [UIImage imageNamed:@"logo"];
    logoImgView.contentMode = UIViewContentModeScaleAspectFill;
    logoImgView.userInteractionEnabled = YES;
    [self.bgScrollView addSubview:logoImgView];
    
    
    UILabel *titleLabel = [FControlTool createLabel:@"注册" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:32]];
    titleLabel.frame = CGRectMake(27, logoImgView.bottom+49, kScreenWidth - 54, 45);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgScrollView addSubview:titleLabel];
    
    UILabel *tipLabel = [FControlTool createLabel:@"注册的账号密码" textColor:RGBColor(0x969799) font:[UIFont fontWithSize:13]];
    tipLabel.frame = CGRectMake(27, titleLabel.bottom+8, kScreenWidth - 54, 18);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgScrollView addSubview:tipLabel];
    
    UIView *phoneBgView = [[UIView alloc] init];
    phoneBgView.frame = CGRectMake(16, tipLabel.bottom+37, kScreenWidth - 32, 50);
    [phoneBgView rounded:25];
    phoneBgView.backgroundColor = RGBColor(0xF0F1F4);
    phoneBgView.layer.masksToBounds = YES;
    [self.bgScrollView addSubview:phoneBgView];
    
    UIImageView *phoneImgView = [FControlTool createImageView];
    phoneImgView.frame = CGRectMake(16, 12, 24, 24);
    phoneImgView.image = [UIImage imageNamed:@"icn_login_phone"];
    [phoneBgView addSubview:phoneImgView];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.frame = CGRectMake(56, 0, phoneBgView.width - 72, 50);
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:RGBColor(0xC8C9CC),NSFontAttributeName:[UIFont fontWithSize:14]}];
    self.phoneTextField.attributedPlaceholder = placeholderString;
    self.phoneTextField.font = [UIFont boldFontWithSize:14];
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTextField.textColor = RGBColor(0x333333);
    [phoneBgView addSubview:self.phoneTextField];
    
    UIView *passwordBgView = [[UIView alloc] init];
    passwordBgView.frame = CGRectMake(16, phoneBgView.bottom+24, kScreenWidth - 32, 50);
    passwordBgView.layer.masksToBounds = YES;
    passwordBgView.backgroundColor = RGBColor(0xF0F1F4);
    [passwordBgView rounded:25];
    [self.bgScrollView addSubview:passwordBgView];
    
    UIImageView *passwordImgView = [FControlTool createImageView];
    passwordImgView.frame = CGRectMake(16, 12, 24, 24);
    passwordImgView.image = [UIImage imageNamed:@"icn_login_password"];
    [passwordBgView addSubview:passwordImgView];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.frame = CGRectMake(56, 0, phoneBgView.width - 112, 50);
    NSAttributedString *passwordPlaceholderString = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:@{NSForegroundColorAttributeName:RGBColor(0xC8C9CC),NSFontAttributeName:[UIFont fontWithSize:14]}];
    self.passwordTextField.attributedPlaceholder = passwordPlaceholderString;
    self.passwordTextField.font = [UIFont boldFontWithSize:14];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.textColor = RGBColor(0x333333);
    [passwordBgView addSubview:self.passwordTextField];
    
    self.hiddenBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_eye_hidden"] target:self sel:@selector(hiddenBtnAction)];
    self.hiddenBtn.frame = CGRectMake(passwordBgView.width - 40, 13, 24, 24);
    [self.hiddenBtn setImage:[UIImage imageNamed:@"icn_eye_show"] forState:UIControlStateSelected];
    [passwordBgView addSubview:self.hiddenBtn];
    
    UIView *againBgView = [[UIView alloc] init];
    againBgView.frame = CGRectMake(16, passwordBgView.bottom+24, kScreenWidth - 32, 50);
    againBgView.layer.masksToBounds = YES;
    againBgView.backgroundColor = RGBColor(0xF0F1F4);
    [againBgView rounded:25];
    [self.bgScrollView addSubview:againBgView];
    
    UIImageView *againImgView = [FControlTool createImageView];
    againImgView.frame = CGRectMake(16, 12, 24, 24);
    againImgView.image = [UIImage imageNamed:@"icn_login_password"];
    [againBgView addSubview:againImgView];
    
    self.againTextField = [[UITextField alloc] init];
    self.againTextField.frame = CGRectMake(56, 0, againBgView.width - 112, 50);
    NSAttributedString *againPlaceholderString = [[NSAttributedString alloc] initWithString:@"再次输入密码" attributes:@{NSForegroundColorAttributeName:RGBColor(0xC8C9CC),NSFontAttributeName:[UIFont fontWithSize:14]}];
    self.againTextField.attributedPlaceholder = againPlaceholderString;
    self.againTextField.font = [UIFont boldFontWithSize:14];
    self.againTextField.secureTextEntry = YES;
    self.againTextField.textColor = RGBColor(0x333333);
    [againBgView addSubview:self.againTextField];
    
    self.againHiddenBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_eye_hidden"] target:self sel:@selector(againHiddenBtnAction)];
    self.againHiddenBtn.frame = CGRectMake(passwordBgView.width - 40, 13, 24, 24);
    [self.againHiddenBtn setImage:[UIImage imageNamed:@"icn_eye_show"] forState:UIControlStateSelected];
    [againBgView addSubview:self.againHiddenBtn];
    
    
    UIView *codeBgView = [[UIView alloc] init];
    codeBgView.frame = CGRectMake(16, againBgView.bottom+24, kScreenWidth - 32, 50);
    codeBgView.layer.masksToBounds = YES;
    codeBgView.backgroundColor = RGBColor(0xF0F1F4);
    [codeBgView rounded:25];
    [self.bgScrollView addSubview:codeBgView];
    
    UIImageView *codeImgView = [FControlTool createImageView];
    codeImgView.frame = CGRectMake(16, 12, 24, 24);
    codeImgView.image = [UIImage imageNamed:@"icn_login_code"];
    [codeBgView addSubview:codeImgView];
    
    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.frame = CGRectMake(56, 0, againBgView.width - 112, 50);
    NSAttributedString *codePlaceholderString = [[NSAttributedString alloc] initWithString:@"输入验证码" attributes:@{NSForegroundColorAttributeName:RGBColor(0xC8C9CC),NSFontAttributeName:[UIFont fontWithSize:14]}];
    self.codeTextField.attributedPlaceholder = codePlaceholderString;
    self.codeTextField.font = [UIFont boldFontWithSize:14];
    self.codeTextField.textColor = RGBColor(0x333333);
    [codeBgView addSubview:self.codeTextField];
    
    self.codeBtn = [FControlTool createButton:@"发送验证码" font:[UIFont boldFontWithSize:12] textColor:UIColor.whiteColor target:self sel:@selector(codeBtnAction)];
    self.codeBtn.frame = CGRectMake(codeBgView.width - 109, 9, 100, 32);
    self.codeBtn.backgroundColor = kMainColor;
    [self.codeBtn rounded:16];
    [codeBgView addSubview:self.codeBtn];
    
    UIButton *registerBtn = [FControlTool createButton:@"注册" font:[UIFont boldFontWithSize:16] textColor:[UIColor whiteColor] target:self sel:@selector(registerBtnAction)];
    registerBtn.backgroundColor = kMainColor;
    [registerBtn rounded:22];
    registerBtn.frame = CGRectMake(16, codeBgView.bottom+66, kScreenWidth - 32, 44);
    [self.bgScrollView addSubview:registerBtn];
    
    UIButton *loginBtn = [FControlTool createButton:@"已有账号 去登录" font:[UIFont fontWithSize:14] textColor:kMainColor target:self sel:@selector(loginBtnAction)];
    loginBtn.frame = CGRectMake((kScreenWidth - 200)/2, registerBtn.bottom+12, 200, 20);
    [self.bgScrollView addSubview:loginBtn];
    
    
    [self.bgScrollView setContentSize:CGSizeMake(kScreenWidth, loginBtn.bottom + 100)];
    
}

- (void)hiddenBtnAction{
    self.hiddenBtn.selected = !self.hiddenBtn.selected;
    self.passwordTextField.secureTextEntry = !self.hiddenBtn.selected;
}

- (void)againHiddenBtnAction{
    self.againHiddenBtn.selected = !self.againHiddenBtn.selected;
    self.againTextField.secureTextEntry = !self.againHiddenBtn.selected;
}

- (void)loginBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *surePw = self.againTextField.text;
    if (phone.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入完整的手机号"];
        return;
    }
    if (code.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (![password isEqualToString:surePw]) {
        [SVProgressHUD showErrorWithStatus:@"请确认两次密码是否相同"];
        return;
    }
    if (![FDataTool isStringContainABCandNumberWith:password] || !(password.length > 7 && password.length < 13)) {
        [SVProgressHUD showErrorWithStatus:@"密码太简单，请重新设置"];
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

- (void)showRealName{
//    SWRealNameViewController *vc = [[SWRealNameViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    [kAppDelegate loginIM:^(BOOL success) {
        if (success) {
            [kAppDelegate initTabBarController];
            [[NSNotificationCenter defaultCenter] postNotificationName:FLoginSuccess object:nil userInfo:nil];
        }
    }];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
