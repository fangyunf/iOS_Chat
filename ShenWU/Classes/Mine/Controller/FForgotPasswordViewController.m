//
//  FForgotPasswordViewController.m
//  Fiesta
//
//  Created by Amy on 2024/5/23.
//

#import "FForgotPasswordViewController.h"

@interface FForgotPasswordViewController ()
@property(nonatomic, strong) UITextField *phoneTextField;
@property(nonatomic, strong) UITextField *codeTextField;
@property(nonatomic, strong) UITextField *passwordTextField;
@property(nonatomic, strong) UITextField *againTextField;
@property(nonatomic, strong) UIButton *codeBtn;
@property(nonatomic, assign) NSInteger timeCount;
@property(nonatomic, strong) NSTimer *codeTimer;
@end

@implementation FForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isForgot) {
        self.title = @"忘记密码";
    }else{
        self.title = @"修改登录密码";
    }
    
    
    self.navigationController.navigationBarHidden = NO;
    
    UIView *phoneBgView = [self createInputBgWithText:@"手机号" top:kTopHeight + 16];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.frame = CGRectMake(94, 0, phoneBgView.width - 112, 40);
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.text = [FUserModel sharedUser].phone;
    self.phoneTextField.font = [UIFont fontWithSize:14];
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [phoneBgView addSubview:self.phoneTextField];
    
    UIView *codeBgView = [self createInputBgWithText:@"验证码" top:phoneBgView.bottom + 16];
    
    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.frame = CGRectMake(94, 0, codeBgView.width - 112, 40);
    self.codeTextField.placeholder = @"请输入验证码";
    self.codeTextField.font = [UIFont fontWithSize:14];
    self.codeTextField.keyboardType = UIKeyboardTypePhonePad;
    [codeBgView addSubview:self.codeTextField];
    
    self.codeBtn = [FControlTool createButton:@"发送验证码" font:[UIFont fontWithSize:14] textColor:kMainColor target:self sel:@selector(codeBtnAction)];
    self.codeBtn.frame = CGRectMake(codeBgView.width - 96, 0, 78, 40);
    [codeBgView addSubview:self.codeBtn];
    
    UIView *passwordBgView = [self createInputBgWithText:@"密码" top:codeBgView.bottom + 16];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.frame = CGRectMake(94, 0, codeBgView.width - 112, 40);
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.font = [UIFont fontWithSize:14];
    self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
    [passwordBgView addSubview:self.passwordTextField];
    
    UIView *aginBgView = [self createInputBgWithText:@"确认密码" top:passwordBgView.bottom + 16];
    
    self.againTextField = [[UITextField alloc] init];
    self.againTextField.frame = CGRectMake(94, 0, codeBgView.width - 112, 40);
    self.againTextField.placeholder = @"请确认密码";
    self.againTextField.font = [UIFont fontWithSize:14];
    self.againTextField.keyboardType = UIKeyboardTypeDefault;
    [aginBgView addSubview:self.againTextField];
    
    UIButton *sureBtn = [FControlTool createCommonButtonWithText:@"确定" target:self sel:@selector(sureBtnAction)];
    sureBtn.frame = CGRectMake(37, aginBgView.bottom+16, kScreenWidth - 74, 44);
    [self.view addSubview:sureBtn];
}

- (void)sureBtnAction{
    NSString *phone = self.phoneTextField.text;
    NSString *qrCode = self.codeTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *surePw = self.againTextField.text;
    if (phone.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入完整的手机号"];
        return;
    }
    if (qrCode.length == 0) {
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
    NSDictionary *params = @{@"phoneNo":self.phoneTextField.text, @"password":self.passwordTextField.text, @"captcha":self.codeTextField.text};
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/customer/updatePassword" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)codeBtnAction{
    [[FVerifyCodeManager sharedManager] getVerifyCodeOnVC:self requestUrl:@"/customer/smsCode" andPhone:self.phoneTextField.text success:^{
        [self startTimer];
    } cancel:^{
        
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

- (UIView*)createInputBgWithText:(NSString*)text top:(CGFloat)top{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(37, top, kScreenWidth - 74, 40);
    bgView.backgroundColor = RGBColor(0xF6F6F6);
    bgView.layer.cornerRadius = 20;
    [self.view addSubview:bgView];
    
    UILabel *label = [FControlTool createLabel:text textColor:UIColor.blackColor font:[UIFont fontWithSize:16]];
    label.frame = CGRectMake(18, 9, 68, 22);
    [bgView addSubview:label];
    
    return bgView;
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
