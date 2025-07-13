//
//  TKAccountDeleteViewController.m
//  ShenWU
//
//  Created by Amy on 2024/8/2.
//

#import "TKAccountDeleteViewController.h"

@interface TKAccountDeleteViewController ()
@property(nonatomic, strong) UITextField *codeTextField;
@property(nonatomic, strong) UIButton *codeBtn;
@property(nonatomic, assign) NSInteger timeCount;
@property(nonatomic, strong) NSTimer *codeTimer;
@end

@implementation TKAccountDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号注销";
    self.navTopView.hidden = NO;
    
    self.view.backgroundColor = RGBColor(0xF1F3F7);
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(15, kTopHeight+14, kScreenWidth - 30, 180);
    topView.backgroundColor = RGBColor(0xF1F3F7);
    topView.layer.cornerRadius = 5;
    topView.layer.masksToBounds = YES;
    [self.view addSubview:topView];
    
    UIImageView *icnImgView = [[UIImageView alloc] init];
    icnImgView.frame = CGRectMake((topView.width - 50)/2, 15, 50, 51);
    icnImgView.image = [UIImage imageNamed:@"icn_account_delete_tip"];
    [topView addSubview:icnImgView];
    
    UILabel *tipLabel = [FControlTool createLabel:[NSString stringWithFormat:@"申请注销%@账号",[FUserModel sharedUser].phone] textColor:RGBColor(0x081C2C) font:[UIFont boldFontWithSize:16]];
    tipLabel.frame = CGRectMake(15, icnImgView.bottom+21, topView.width - 30, 24);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:tipLabel];
    
    UILabel *tipDesLabel = [FControlTool createLabel:@"注意，注销账号后以下信息将被清空切无法找回" textColor:RGBAlphaColor(0x081C2C, 0.5) font:[UIFont fontWithSize:14]];
    tipDesLabel.frame = CGRectMake(15, tipLabel.bottom+8, topView.width - 30, 24);
    tipDesLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:tipDesLabel];
    
    UIView *middleView = [[UIView alloc] init];
    middleView.frame = CGRectMake(15, topView.bottom+10, kScreenWidth - 30, 286);
    middleView.backgroundColor = [UIColor whiteColor];
    middleView.layer.cornerRadius = 11;
    middleView.layer.masksToBounds = YES;
    [self.view addSubview:middleView];
    
    UILabel *middleTipLabel = [FControlTool createLabel:@"1.您的好友和群组等\n\n2.您的身份、账户信息等,\n\n3.您的钱包、记录、银行卡等\n\n温馨提示：" textColor:RGBColor(0x081C2C) font:[UIFont fontWithSize:14]];
    middleTipLabel.frame = CGRectMake(20, 24, middleView.width - 40, 165);
    middleTipLabel.numberOfLines = 0;
    [middleView addSubview:middleTipLabel];
    
    UILabel *middleTipDesLabel = [FControlTool createLabel:@"账号注销后，您的所有数据和账号信息将全部丢失，账号一旦注销不可恢复，为避免您的个人损失，请谨慎操作" textColor:RGBAlphaColor(0x081C2C, 0.5) font:[UIFont fontWithSize:14]];
    middleTipDesLabel.frame = CGRectMake(20, 189, middleView.width - 40, 80);
    middleTipDesLabel.numberOfLines = 0;
    [middleView addSubview:middleTipDesLabel];
    
//    UIView *codeBgView = [self createInputBgWithText:@"验证码" top:middleView.bottom + 16];
//    
//    self.codeTextField = [[UITextField alloc] init];
//    self.codeTextField.frame = CGRectMake(94, 0, codeBgView.width - 112, 40);
//    self.codeTextField.placeholder = @"请输入验证码";
//    self.codeTextField.font = [UIFont fontWithSize:14];
//    self.codeTextField.keyboardType = UIKeyboardTypePhonePad;
//    [codeBgView addSubview:self.codeTextField];
//    
//    self.codeBtn = [FControlTool createButton:@"发送验证码" font:[UIFont fontWithSize:14] textColor:kMainColor target:self sel:@selector(codeBtnAction)];
//    self.codeBtn.frame = CGRectMake(codeBgView.width - 96, 0, 78, 40);
//    [codeBgView addSubview:self.codeBtn];
    
    UIButton *deleteBtn = [FControlTool createCommonButton:@"申请注销" font:[UIFont boldFontWithSize:18] cornerRadius:24 size:CGSizeMake(kScreenWidth - 32, 48) target:self sel:@selector(deleteBtnAction)];
    deleteBtn.frame = CGRectMake(16, middleView.bottom+48, kScreenWidth - 32, 48);
    deleteBtn.backgroundColor = kMainColor;
    deleteBtn.layer.cornerRadius = 24;
    deleteBtn.layer.masksToBounds = YES;
    [self.view addSubview:deleteBtn];
}

- (void)codeBtnAction{
    [[FVerifyCodeManager sharedManager] getVerifyCodeOnVC:self requestUrl:@"/customer/smsCode" andPhone:[FUserModel sharedUser].phone success:^{
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

- (void)deleteBtnAction{
//    if (self.codeTextField.text.length == 0) {
//        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
//        return;
//    }
//    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否申请注销账号？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *param = @{};//@{@"sms":self.codeTextField.text};
        [[FNetworkManager sharedManager] postRequestFromServer:@"/home/logout" parameters:param success:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"申请注销成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:nil];
            }else {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:sure];
    [alertVc addAction:cancel];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (UIView*)createInputBgWithText:(NSString*)text top:(CGFloat)top{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(16, top, kScreenWidth - 32, 40);
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 8;
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
