//
//  SWSecurityVerifyViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/19.
//

#import "SWSecurityVerifyViewController.h"
#import "YXKeychain.h"
#import "SWVerifySuccessViewController.h"
@implementation SWCodeTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

@end

@interface SWSecurityVerifyViewController ()<UITextFieldDelegate>
@property(nonatomic, strong) SWCodeTextField *codeTextField;
@property(nonatomic, strong) NSArray<UILabel *> *labelsArr;
@property(nonatomic, strong) UIButton *codeBtn;
@property(nonatomic, assign) NSInteger timeCount;
@property(nonatomic, strong) NSTimer *codeTimer;
@property(nonatomic, assign) BOOL isRequesting;
@end

@implementation SWSecurityVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全验证";
    
    UIImageView *icnImgView = [[UIImageView alloc] init];
    icnImgView.frame = CGRectMake((kScreenWidth - 215)/2, 11+kTopHeight, 215, 195);
    icnImgView.image = [UIImage imageNamed:@"icn_remeto_login"];
    [self.view addSubview:icnImgView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"安全验证" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    titleLabel.frame = CGRectMake(15, icnImgView.bottom+24, kScreenWidth - 30, 18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *phoneLabel = [FControlTool createLabel:[self.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"] textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    phoneLabel.frame = CGRectMake(15, titleLabel.bottom+24, kScreenWidth - 30, 18);
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:phoneLabel];
    
    [self.view addSubview:self.codeTextField];
    
    for (NSInteger index = 0; index < self.labelsArr.count; index ++) {
        UILabel *label = self.labelsArr[index];
        label.frame = CGRectMake(50+(kScreenWidth - 100 - 40*self.labelsArr.count)/5*index + 40*index, phoneLabel.bottom+47, 40, 40);
        [self.view addSubview:label];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(label.left, label.bottom, 40, 1);
        lineView.backgroundColor = RGBColor(0x999999);
        [self.view addSubview:lineView];
    }
    
    self.codeBtn = [FControlTool createCommonButton:@"发送验证码" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 120, 52) target:self sel:@selector(codeBtnAction)];
    self.codeBtn.frame = CGRectMake(60, phoneLabel.bottom+150, kScreenWidth - 120, 52);
    self.codeBtn.layer.cornerRadius = 26;
    self.codeBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.codeBtn];
}

- (void)codeBtnAction{
    [[FVerifyCodeManager sharedManager] getVerifyCodeOnVC:self requestUrl:@"/customer/smsCode" andPhone:self.phone success:^{
        [self startTimer];
        [self.codeTextField becomeFirstResponder];
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

- (void)labelTapAction {
    [self.codeTextField becomeFirstResponder];
}

#pragma  mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSInteger index = 0; index < self.labelsArr.count; index ++) {
            UILabel *label = self.labelsArr[index];
            if (index < textField.text.length) {
                label.text = [textField.text substringWithRange:NSMakeRange(index, 1)];
            }else {
                label.text = @"";
            }
        }
    });
    if (textField.text.length == 6) {
        if (self.isRequesting) {
            return;
        }
        self.isRequesting = YES;
        NSDictionary *params = @{@"phoneNo":self.phone, @"deviceId":[YXKeychain getDeviceIDInKeychain], @"clientType":@"IOS", @"captcha":self.codeTextField.text};
        @weakify(self);
        [SVProgressHUD show];
        [[FNetworkManager sharedManager] postRequestFromServer:@"/customer/ydCodeCheck" parameters:params success:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue] == 200) {
                /// success
                NSDictionary *userDict = response[@"data"];
                SWVerifySuccessViewController *vc = [[SWVerifySuccessViewController alloc] init];
                vc.userDict = userDict;
                [weak_self.navigationController pushViewController:vc animated:YES];
                [SVProgressHUD dismiss];
            }else {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
            weak_self.isRequesting = NO;
        } failure:^(NSError * _Nonnull error) {
            weak_self.isRequesting = NO;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}



- (SWCodeTextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[SWCodeTextField alloc] init];
        _codeTextField.delegate = self;
        _codeTextField.hidden = YES;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeTextField;
}

- (NSArray<UILabel *> *)labelsArr {
    if (!_labelsArr) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:6];
        for (NSInteger index = 0; index < 6; index ++) {
            UILabel *stateLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x000000) font:[UIFont boldFontWithSize:18]];
            stateLabel.textAlignment = NSTextAlignmentCenter;
            stateLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapAction)];
            [stateLabel addGestureRecognizer:gesture];
            [arr addObject:stateLabel];
        }
        _labelsArr = [arr copy];
    }
    return _labelsArr;
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
