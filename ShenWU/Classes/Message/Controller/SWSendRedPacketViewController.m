//
//  SWSendRedPacketViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/28.
//

#import "SWSendRedPacketViewController.h"
#import "SWSelectUserViewController.h"
@interface SWSendRedPacketViewController ()<UITextFieldDelegate,SWSelectUserViewControllerDelegate>
@property(nonatomic, strong) UIImageView *topBgImgView;
@property(nonatomic, strong) UIView *bgContentView;
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UIButton *nameBtn;
@property(nonatomic, strong) UIView *priceView;
@property(nonatomic, strong) UIView *numView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UITextField *numTextField;
@property(nonatomic, strong) UITextField *priceTextField;
@property(nonatomic, strong) UITextField *contentTextField;
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, strong) UIButton *sendBtn;
@property(nonatomic, strong) FGroupUserInfoModel *userInfoModel;
@end

@implementation SWSendRedPacketViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.whiteColor};
    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topBgImgView = [[UIImageView alloc] init];
    self.topBgImgView.frame = CGRectMake(0, 0, kScreenWidth, 182);
    self.topBgImgView.image = [UIImage imageNamed:@"bg_send_red"];
    self.topBgImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.topBgImgView];
    
    self.bgContentView = [[UIView alloc] init];
    self.bgContentView.frame = CGRectMake(0, 164, kScreenWidth, kScreenHeight - 164);
    self.bgContentView.backgroundColor = UIColor.whiteColor;
    [self.bgContentView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(20, 20)];
    [self.view addSubview:self.bgContentView];
    
    self.priceView = [[UIView alloc] init];
    self.priceView.frame = CGRectMake(0, 0, kScreenWidth, 102);
    [self.bgContentView addSubview:self.priceView];
    
    UILabel *priceTitleLabel = [FControlTool createLabel:@"总金额" textColor:UIColor.blackColor font:[UIFont fontWithSize:15]];
    priceTitleLabel.frame = CGRectMake(18, 20, 60, 15);
    [self.priceView addSubview:priceTitleLabel];
    
    UILabel *unitLabel = [FControlTool createLabel:@"¥" textColor:UIColor.blackColor font:[UIFont fontWithSize:29]];
    unitLabel.frame = CGRectMake(18, 62, 20, 29);
    [self.priceView addSubview:unitLabel];
    
    self.priceTextField = [[UITextField alloc] init];
    self.priceTextField.frame = CGRectMake(48, 62, self.priceView.width - 66, 29);
    self.priceTextField.placeholder = @"输入金额";
    self.priceTextField.font = [UIFont boldFontWithSize:24];
    self.priceTextField.textColor = UIColor.blackColor;
    self.priceTextField.delegate = self;
    self.priceTextField.returnKeyType = UIReturnKeyDone;
    self.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.priceTextField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventValueChanged];
    [self.priceView addSubview:self.priceTextField];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 101, kScreenWidth, 1);
    lineView.backgroundColor = RGBColor(0xE8E8E8);
    [self.priceView addSubview:lineView];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.frame = CGRectMake(18, self.priceView.bottom+32, kScreenWidth-36, 40);
    self.contentView.backgroundColor = RGBColor(0xf6f6f6);
    [self.contentView rounded:11];
    [self.bgContentView addSubview:self.contentView];
    
    self.contentTextField = [[UITextField alloc] init];
    self.contentTextField.frame = CGRectMake(15, 0, self.contentView.width - 30, 40);
    self.contentTextField.placeholder = @"恭喜发财 大吉大利";
    self.contentTextField.font = [UIFont fontWithSize:16];
    self.contentTextField.textColor = UIColor.blackColor;
    self.contentTextField.delegate = self;
    self.contentTextField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.contentTextField];
    
    self.moneyLabel = [FControlTool createLabel:@"¥00.00" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:40]];
    self.moneyLabel.frame = CGRectMake(16, self.contentView.bottom+80, kScreenWidth - 32, 50);
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgContentView addSubview:self.moneyLabel];
    
    self.sendBtn = [FControlTool createCommonButton:@"发红包" font:[UIFont boldFontWithSize:16] cornerRadius:25 size:CGSizeMake(kScreenWidth - 32, 50) target:self sel:@selector(sendBtnAction)];
    self.sendBtn.frame = CGRectMake(16, self.moneyLabel.bottom+31, kScreenWidth - 32, 50);
    self.sendBtn.backgroundColor = RGBColor(0xDC513F);
    [self.bgContentView addSubview:self.sendBtn];
    
    if(self.redType == RedPacketTypeSingle){
        [self initSingle];
    }else if(self.redType == RedPacketTypeZhuazhang){
        [self.sendBtn setTitle:@"转账" forState:UIControlStateNormal];
        self.contentTextField.placeholder = @"输入转账说明";
    }else if(self.redType == RedPacketTypeLucky){
        [self initLucky];
    }
}

- (void)initLucky{
    self.numView = [[UIView alloc] init];
    self.numView.frame = CGRectMake(0, 0, kScreenWidth, 70);
    self.numView.backgroundColor = UIColor.whiteColor;
    [self.bgContentView addSubview:self.numView];
    
    UILabel *numTitleLabel = [FControlTool createLabel:@"拼手气个数" textColor:UIColor.blackColor font:[UIFont fontWithSize:15]];
    numTitleLabel.frame = CGRectMake(20, 0, 80, 70);
    [self.numView addSubview:numTitleLabel];
    
    UILabel *unitLabel = [FControlTool createLabel:@"个" textColor:UIColor.blackColor font:[UIFont fontWithSize:16]];
    unitLabel.frame = CGRectMake(self.priceView.width - 32, 0, 16, 70);
    [self.numView addSubview:unitLabel];
    
    self.numTextField = [[UITextField alloc] init];
    self.numTextField.frame = CGRectMake(106, 0, self.numView.width - 154, 70);
    self.numTextField.placeholder = @"0";
    self.numTextField.font = [UIFont fontWithSize:16];
    self.numTextField.textColor = UIColor.blackColor;
    self.numTextField.delegate = self;
    self.numTextField.returnKeyType = UIReturnKeyDone;
    self.numTextField.textAlignment = NSTextAlignmentRight;
    self.numTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.numTextField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventValueChanged];
    [self.numView addSubview:self.numTextField];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 69, kScreenWidth, 1);
    lineView.backgroundColor = RGBColor(0xE8E8E8);
    [self.numView addSubview:lineView];
    
    self.priceView.frame = CGRectMake(0, self.numView.bottom, kScreenWidth, 102);
    self.contentView.frame = CGRectMake(18, self.priceView.bottom+32, kScreenWidth-36, 40);
    self.moneyLabel.frame = CGRectMake(16, self.contentView.bottom+80, kScreenWidth - 32, 50);
    self.sendBtn.frame = CGRectMake(60, self.moneyLabel.bottom+35, kScreenWidth - 120, 52);
}

- (void)initSingle{
    self.topBgImgView.image = nil;
    self.topBgImgView.backgroundColor = RGBColor(0x48A4ED);
    
    UIView *infoView = [[UIView alloc] init];
    infoView.frame = CGRectMake(0, 0, kScreenWidth, 70);
    [self.bgContentView addSubview:infoView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"专属人" textColor:UIColor.blackColor font:[UIFont fontWithSize:15]];
    titleLabel.frame = CGRectMake(20, 0, 80, 70);
    [infoView addSubview:titleLabel];
    
    self.nameBtn = [FControlTool createButton:@"选择专属人" font:[UIFont fontWithSize:15] textColor:RGBColor(0x999999) target:self sel:@selector(selectTapAction)];
    [self.nameBtn setImage:[UIImage imageNamed:@"icn_setting_arrow"] forState:UIControlStateNormal];
    self.nameBtn.frame = CGRectMake(18, 0, kScreenWidth - 36, 70);
    self.nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.nameBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:4];
    [infoView addSubview:self.nameBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 69, kScreenWidth, 1);
    lineView.backgroundColor = RGBColor(0xE8E8E8);
    [infoView addSubview:lineView];
    
    self.priceView.frame = CGRectMake(0, infoView.bottom, kScreenWidth, 102);
    self.contentView.frame = CGRectMake(18, self.priceView.bottom+32, kScreenWidth-36, 40);
    self.moneyLabel.frame = CGRectMake(16, self.contentView.bottom+80, kScreenWidth - 32, 50);
    self.sendBtn.frame = CGRectMake(60, self.moneyLabel.bottom+35, kScreenWidth - 120, 52);
    self.sendBtn.backgroundColor = RGBColor(0x1685E5);
}

- (void)setRedType:(RedPacketType)redType{
    _redType = redType;
    if (_redType == RedPacketTypeLucky || _redType == RedPacketTypePerson) {
        self.title = @"发红包";
    }else if (_redType == RedPacketTypeZhuazhang) {
        self.title = @"转账";
    }else{
        self.title = @"专属红包";
    }
}

- (void)selectTapAction{
    SWSelectUserViewController *vc = [[SWSelectUserViewController alloc] init];
    vc.type = SelectFriendTypeRedPacket;
    vc.groupModel = self.groupModel;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendBtnAction{
    NSString *price = self.priceTextField.text;
    if (self.priceTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入红包金额"];
        return;
    }
    if(self.redType == RedPacketTypeSingle){
        if (self.userInfoModel == nil) {
            [SVProgressHUD showErrorWithStatus:@"请选择专属人"];
            return;
        }
    }
    if(self.redType == RedPacketTypeLucky){
        if (self.numTextField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入红包个数"];
            return;
        }
    }
    
    @weakify(self)
    [FPayPasswordView showPayPrice:price success:^(NSString * _Nonnull password) {
        if (weak_self.redType == RedPacketTypePerson) {
            [weak_self sendPersonRedPacket:password];
        }else if (weak_self.redType == RedPacketTypeZhuazhang) {
            [weak_self sendZhuanzhang:password];
        } else{
            [weak_self sendRedPacket:password];
        }
    }];
}

- (void)sendPersonRedPacket:(NSString *)password{
    float price = [self.priceTextField.text floatValue]*100;
    [SVProgressHUD show];
    NSDictionary *params = @{@"toUserId": self.model.userId,@"title": self.contentTextField.text.length == 0?@"恭喜发财 大吉大利":FormattingObject(self.contentTextField.text),@"amount": [NSString stringWithFormat:@"%.0lf",price],@"password": password};
    NSString *requestUrl = @"/red/personRedpacket";
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

- (void)sendZhuanzhang:(NSString *)password{
    float price = [self.priceTextField.text floatValue]*100;
    [SVProgressHUD show];
    NSDictionary *params = @{@"toUserId": self.model.userId,@"title": self.contentTextField.text.length == 0?@"你发起了一笔转账":FormattingObject(self.contentTextField.text),@"amount": [NSString stringWithFormat:@"%.0lf",price],@"password": password};
    NSString *requestUrl = @"/red/zz";
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

- (void)sendRedPacket:(NSString *)password{
    float price = [self.priceTextField.text floatValue]*100;
    [SVProgressHUD show];
    NSDictionary *params = nil;
    NSString *requestUrl = @"";
    if (self.redType == RedPacketTypeLucky) {
        params = @{@"groupId": self.groupModel.groupId,@"title": self.contentTextField.text.length == 0?@"恭喜发财 大吉大利":FormattingObject(self.contentTextField.text),@"amount": [NSString stringWithFormat:@"%.0lf",price],@"num": @(self.numTextField.text.integerValue),@"tradePassword": password};
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

- (void)textFieldChanged{
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",self.priceTextField.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",self.priceTextField.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self.priceTextField resignFirstResponder];
        [self.contentTextField resignFirstResponder];
        [self.numTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - FSelectFriendViewControllerDelegate
- (void)selectUser:(FGroupUserInfoModel *)model{
    self.userInfoModel = model;
    [self.nameBtn setTitle:model.name forState:UIControlStateNormal];
    [self.nameBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:4];
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
