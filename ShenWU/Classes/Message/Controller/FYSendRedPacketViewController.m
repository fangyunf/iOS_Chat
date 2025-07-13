//
//  FYSendRedPacketViewController.m
//  ShenWU
//
//  Created by Amy on 2025/2/19.
//

#import "FYSendRedPacketViewController.h"
#import "SWSelectUserViewController.h"
@interface FYSendRedPacketViewController ()<UITextFieldDelegate,SWSelectUserViewControllerDelegate>
@property(nonatomic, strong) UIButton *luckyBtn;
@property(nonatomic, strong) UIButton *zhuanshuBtn;
@property(nonatomic, strong) UIView *selectLineView;
@property(nonatomic, assign) NSInteger selectIndex;
@property(nonatomic, strong) UILabel *moneyTitleLabel;
@property(nonatomic, strong) UITextField *moneyTextField;

@property(nonatomic, strong) UILabel *middleTitleLabel;
@property(nonatomic, strong) UITextField *numberTextField;
@property(nonatomic, strong) UILabel *middleUnitLabel;
@property(nonatomic, strong) UITapGestureRecognizer *selectUserTap;
@property(nonatomic, strong) UILabel *userLabel;
@property(nonatomic, strong) UIImageView *arrowImgView;

@property(nonatomic, strong) UITextField *remarkTextField;
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, strong) FGroupUserInfoModel *userInfoModel;
@end

@implementation FYSendRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发红包";
    
    self.view.backgroundColor = RGBColor(0xEEEDF2);
    
    self.luckyBtn = [FControlTool createButton:@"拼手气红包" font:[UIFont boldFontWithSize:15] textColor:RGBColor(0x999999) target:self sel:@selector(luckyBtnAction)];
    self.luckyBtn.frame = CGRectMake(22, kTopHeight+20, 76, 15);
    [self.luckyBtn setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
    [self.view addSubview:self.luckyBtn];
    
    self.zhuanshuBtn = [FControlTool createButton:@"专属红包" font:[UIFont boldFontWithSize:15] textColor:RGBColor(0x999999) target:self sel:@selector(zhuanshuBtnAction)];
    self.zhuanshuBtn.frame = CGRectMake(120, kTopHeight+20, 76, 15);
    [self.zhuanshuBtn setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
    [self.view addSubview:self.zhuanshuBtn];
    
    self.selectLineView = [[UIView alloc] init];
    self.selectLineView.frame = CGRectMake((self.luckyBtn.left+(self.luckyBtn.width - 40)/2), self.luckyBtn.bottom+4, 40, 2);
    self.selectLineView.backgroundColor = RGBColor(0xFD4D4D);
    [self.selectLineView rounded:2];
    [self.view addSubview:self.selectLineView];
    
    UIView *moneyView = [[UIView alloc] init];
    moneyView.frame = CGRectMake(15, self.selectLineView.bottom+34, kScreenWidth - 30, 93);
    moneyView.backgroundColor = [UIColor whiteColor];
    [moneyView rounded:5];
    [self.view addSubview:moneyView];
    
    self.moneyTitleLabel = [FControlTool createLabel:@"总金额" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    self.moneyTitleLabel.frame = CGRectMake(15, 0, moneyView.width - 30, moneyView.height);
    [moneyView addSubview:self.moneyTitleLabel];
    
    UILabel *unitLabel = [FControlTool createLabel:@"元" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    unitLabel.frame = CGRectMake(15, 0, moneyView.width - 30, moneyView.height);
    unitLabel.textAlignment = NSTextAlignmentRight;
    [moneyView addSubview:unitLabel];
    
    self.moneyTextField = [[UITextField alloc] init];
    self.moneyTextField.frame = CGRectMake(100, 39, moneyView.width - 136, 15);
    self.moneyTextField.placeholder = @"请输入金额";
    self.moneyTextField.font = [UIFont fontWithSize:13];
    self.moneyTextField.textColor = UIColor.blackColor;
    self.moneyTextField.delegate = self;
    self.moneyTextField.returnKeyType = UIReturnKeyDone;
    self.moneyTextField.textAlignment = NSTextAlignmentRight;
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.moneyTextField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventValueChanged];
    [moneyView addSubview:self.moneyTextField];
    
    UIView *middleView = [[UIView alloc] init];
    middleView.frame = CGRectMake(15, moneyView.bottom+18, kScreenWidth - 30, 93);
    middleView.backgroundColor = [UIColor whiteColor];
    [middleView rounded:5];
    [self.view addSubview:middleView];
    
    self.middleTitleLabel = [FControlTool createLabel:@"红包数量" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    self.middleTitleLabel.frame = CGRectMake(15, 0, middleView.width - 30, middleView.height);
    [middleView addSubview:self.middleTitleLabel];
    
    self.numberTextField = [[UITextField alloc] init];
    self.numberTextField.frame = CGRectMake(100, 39, middleView.width - 136, 15);
    self.numberTextField.placeholder = @"请输入发红包总数量";
    self.numberTextField.font = [UIFont fontWithSize:13];
    self.numberTextField.textColor = UIColor.blackColor;
    self.numberTextField.delegate = self;
    self.numberTextField.textAlignment = NSTextAlignmentRight;
    self.numberTextField.returnKeyType = UIReturnKeyDone;
    self.numberTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.numberTextField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventValueChanged];
    [middleView addSubview:self.numberTextField];
    
    self.middleUnitLabel = [FControlTool createLabel:@"个" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    self.middleUnitLabel.frame = CGRectMake(15, 0, middleView.width - 30, middleView.height);
    self.middleUnitLabel.textAlignment = NSTextAlignmentRight;
    [middleView addSubview:self.middleUnitLabel];
    
    self.userLabel = [FControlTool createLabel:@"请选择发送给谁" textColor:RGBColor(0x999999) font:[UIFont boldFontWithSize:15]];
    self.userLabel.frame = CGRectMake(100, 39, middleView.width - 136, 15);
    self.userLabel.textAlignment = NSTextAlignmentRight;
    [middleView addSubview:self.userLabel];
    
    self.arrowImgView = [FControlTool createImageView];
    self.arrowImgView.frame = CGRectMake(middleView.width - 27, 40.5, 6, 12);
    self.arrowImgView.image = [UIImage imageNamed:@"icn_setting_arrow"];
    [middleView addSubview:self.arrowImgView];
    
    self.selectUserTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectUserTapAction)];
    [middleView addGestureRecognizer:self.selectUserTap];
    
    UIView *remarkView = [[UIView alloc] init];
    remarkView.frame = CGRectMake(15, middleView.bottom+18, kScreenWidth - 30, 93);
    remarkView.backgroundColor = [UIColor whiteColor];
    [remarkView rounded:5];
    [self.view addSubview:remarkView];
    
    UILabel *remarkTitleLabel = [FControlTool createLabel:@"备注" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    remarkTitleLabel.frame = CGRectMake(15, 14, remarkView.width - 30, 15);
    [remarkView addSubview:remarkTitleLabel];
    
    self.remarkTextField = [[UITextField alloc] init];
    self.remarkTextField.frame = CGRectMake(15, 46, middleView.width - 136, 20);
    self.remarkTextField.placeholder = @"恭喜发财，大吉大利！";
    self.remarkTextField.font = [UIFont fontWithSize:15];
    self.remarkTextField.textColor = UIColor.blackColor;
    self.remarkTextField.delegate = self;
    self.remarkTextField.returnKeyType = UIReturnKeyDone;
    [remarkView addSubview:self.remarkTextField];
    
    self.moneyLabel = [FControlTool createLabel:@"¥0.00" textColor:RGBColor(0x333333) font:[UIFont boldFontWithSize:34]];
    self.moneyLabel.frame = CGRectMake(15, remarkView.bottom+30, kScreenWidth - 30, 37);
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.moneyLabel];
    
    UIButton *sendBtn = [FControlTool createButton:@"发红包" font:[UIFont boldFontWithSize:15] textColor:UIColor.whiteColor target:self sel:@selector(sendBtnAction)];
    sendBtn.frame = CGRectMake((kScreenWidth - 190)/2, self.moneyLabel.bottom+32, 190, 46);
    sendBtn.backgroundColor = RGBColor(0xFD4D4D);
    [sendBtn rounded:23];
    [self.view addSubview:sendBtn];
    
    [self luckyBtnAction];
}

- (void)luckyBtnAction{
    self.selectIndex = 0;
    self.luckyBtn.selected = YES;
    self.zhuanshuBtn.selected = NO;
    
    self.middleTitleLabel.text = @"红包数量";
    self.numberTextField.hidden = NO;
    self.moneyTextField.text = @"";
    self.userLabel.hidden = YES;
    self.arrowImgView.hidden = YES;
    self.middleUnitLabel.hidden = NO;
    self.selectUserTap.enabled = NO;
    
    self.selectLineView.frame = CGRectMake((self.luckyBtn.left+(self.luckyBtn.width - 40)/2), self.luckyBtn.bottom+4, 40, 2);
}

- (void)zhuanshuBtnAction{
    self.selectIndex = 1;
    self.luckyBtn.selected = NO;
    self.zhuanshuBtn.selected = YES;
    
    self.middleTitleLabel.text = @"红包数量";
    self.moneyTextField.text = @"";
    self.numberTextField.hidden = YES;
    self.userLabel.hidden = NO;
    self.arrowImgView.hidden = NO;
    self.middleUnitLabel.hidden = YES;
    self.selectUserTap.enabled = YES;
    
    self.selectLineView.frame = CGRectMake((self.zhuanshuBtn.left+(self.zhuanshuBtn.width - 40)/2), self.zhuanshuBtn.bottom+4, 40, 2);
}

- (void)sendBtnAction{
    NSString *price = self.moneyTextField.text;
    if (self.moneyTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入红包金额"];
        return;
    }
    if(self.selectIndex == 0){
        if (self.numberTextField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入红包个数"];
            return;
        }
    }else{
        if (self.userInfoModel == nil) {
            if (self.numberTextField.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择发送给谁"];
                return;
            }
        }
    }
    
    @weakify(self)
    [FPayPasswordView showPayPrice:price success:^(NSString * _Nonnull password) {
        [weak_self sendRedPacket:password];
    }];
}

- (void)sendRedPacket:(NSString *)password{
    float price = [self.moneyTextField.text floatValue]*100;
    [SVProgressHUD show];
    NSDictionary *params = nil;
    NSString *requestUrl = @"";
    if (self.selectIndex == 0) {
        params = @{@"groupId": self.groupModel.groupId,@"title": self.remarkTextField.text.length == 0?@"恭喜发财 大吉大利":FormattingObject(self.remarkTextField.text),@"amount": [NSString stringWithFormat:@"%.0lf",price],@"num": @(self.numberTextField.text.integerValue),@"tradePassword": password};
        requestUrl = @"/red/sendGroupRedpacket";
    }else{
        params = @{@"groupId": self.groupModel.groupId,@"title": self.userInfoModel.name,@"amount": [NSString stringWithFormat:@"%.0lf",price],@"toUserId": self.userInfoModel.userId,@"password": password};
        requestUrl = @"/red/sendExclusiveRedPacket";
    }
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:requestUrl parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            [weak_self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)selectUserTapAction{
    SWSelectUserViewController *vc = [[SWSelectUserViewController alloc] init];
    vc.type = SelectFriendTypeRedPacket;
    vc.groupModel = self.groupModel;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - FSelectFriendViewControllerDelegate
- (void)selectUser:(FGroupUserInfoModel *)model{
    self.userInfoModel = model;
    self.userLabel.text = model.name;
}

- (void)textFieldChanged{
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",self.moneyTextField.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",self.moneyTextField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self.moneyTextField resignFirstResponder];
        [self.remarkTextField resignFirstResponder];
        [self.numberTextField resignFirstResponder];
        return NO;
    }
    return YES;
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
