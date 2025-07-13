//
//  SWLoginView.m
//  ShenWU
//
//  Created by Amy on 2024/6/19.
//

#import "SWLoginView.h"
#import "YXKeychain.h"
#import "SWRealNameViewController.h"
#import "SWRemoteLoginViewController.h"
#import "SWForgotPasswordViewController.h"
#import "PForgotPasswordViewController.h"
@interface SWLoginView ()
@property(nonatomic, strong) UITextField *phoneTextField;
@property(nonatomic, strong) UITextField *passwordTextField;
@end

@implementation SWLoginView

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
        
        
        UIView *passwordBgView = [[UIView alloc] init];
        passwordBgView.frame = CGRectMake(24, phoneBgView.bottom+24, self.width - 48, 40);
        passwordBgView.backgroundColor = RGBColor(0xF8F8F8);
        passwordBgView.layer.cornerRadius = 20;
        [self addSubview:passwordBgView];
        
        UIImageView *passwordImgView = [FControlTool createImageView];
        passwordImgView.frame = CGRectMake(16, 8, 24, 24);
        passwordImgView.image = [UIImage imageNamed:@"icn_login_password"];
        [passwordBgView addSubview:passwordImgView];
        
        self.passwordTextField = [[UITextField alloc] init];
        self.passwordTextField.frame = CGRectMake(phoneImgView.right+12, 0, phoneBgView.width - (phoneImgView.right+28), 40);
        NSAttributedString *passwordPlaceholderString = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:RGBColor(0xC8C9CC),NSFontAttributeName:[UIFont fontWithSize:15]}];
        self.passwordTextField.attributedPlaceholder = passwordPlaceholderString;
        self.passwordTextField.font = [UIFont fontWithSize:14];
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.textColor = RGBColor(0x333333);
        [passwordBgView addSubview:self.passwordTextField];
        
        UIButton *passwordBtn = [FControlTool createButton:@"忘记密码？" font:[UIFont fontWithSize:14] textColor:kMainColor target:self sel:@selector(passwordBtnAction)];
        passwordBtn.frame = CGRectMake(24, passwordBgView.bottom+24, self.width - 48, 17);
        passwordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:passwordBtn];
        
        UIButton *loginBtn = [FControlTool createCommonButton:@"登录" font:[UIFont boldFontWithSize:16] cornerRadius:8 size:CGSizeMake(self.width - 24, 44) target:self sel:@selector(loginBtnAction)];
        loginBtn.frame = CGRectMake(12, passwordBgView.bottom+88, self.width - 24, 44);
        loginBtn.backgroundColor = kMainColor;
        loginBtn.layer.cornerRadius = 8;
        loginBtn.layer.masksToBounds = YES;
        [self addSubview:loginBtn];
        
//        UILabel *versionLabel = [FControlTool createLabel:[NSString stringWithFormat:@"版本号：%@",AppBuildVersion] textColor:RGBColor(0x323233) font:[UIFont fontWithSize:13]];
//        versionLabel.frame = CGRectMake(0, loginBtn.bottom+16, self.width, 15);
//        versionLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:versionLabel];
    }
    return self;
}

- (void)loginBtnAction{
    /// 账号密码登录
    if (self.phoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }else if (![FDataTool isStringContainABCandNumberWith:self.passwordTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    NSDictionary *params = @{@"phoneNo":self.phoneTextField.text, @"password":self.passwordTextField.text, @"deviceId":[YXKeychain getDeviceIDInKeychain], @"clientType":@"IOS"};
    [SVProgressHUD show];
    @weakify(self);
    [[FNetworkManager sharedManager] postRequestFromServer:@"/customer/login" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
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
