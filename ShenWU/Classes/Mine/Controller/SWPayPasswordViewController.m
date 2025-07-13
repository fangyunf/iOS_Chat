//
//  SWPayPasswordViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/29.
//

#import "SWPayPasswordViewController.h"
#import "SWPasswordInputCell.h"
@interface SWPayPasswordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, strong) UIButton *codeBtn;
@property(nonatomic, assign) NSInteger timeCount;
@property(nonatomic, strong) NSTimer *codeTimer;
@end

@implementation SWPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView reloadData];
    if (self.type == PasswordTypeSetting) {
        self.title = @"设置支付密码";
        self.dataList = @[@{@"title":@"手机号",@"placeholder":@"请输入手机号"},
                          @{@"title":@"验证码",@"placeholder":@"请输入验证码"},
                          @{@"title":@"设置密码",@"placeholder":@"请输入密码"},
                          @{@"title":@"确认密码",@"placeholder":@"请确认密码"}];
    }else if (self.type == PasswordTypeEdit) {
        self.title = @"修改支付密码";
        self.dataList = @[@{@"title":@"手机号",@"placeholder":@"请输入手机号"},
                          @{@"title":@"验证码",@"placeholder":@"请输入验证码"},
                          @{@"title":@"原密码",@"placeholder":@"请输入原密码"},
                          @{@"title":@"新密码",@"placeholder":@"请输入新密码"},
                          @{@"title":@"确认密码",@"placeholder":@"请确认密码"}];
        [self initFooterView];
    }else{
        self.title = @"忘记支付密码";
        self.dataList = @[@{@"title":@"手机号",@"placeholder":@"请输入手机号"},
                          @{@"title":@"验证码",@"placeholder":@"请输入验证码"},
                          @{@"title":@"新密码",@"placeholder":@"请输入新密码"}];
    }
    
    UIButton *sureBtn = [FControlTool createCommonButton:@"确定" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 32, 52) target:self sel:@selector(sureBtnAction)];
    sureBtn.frame = CGRectMake(16, kScreenHeight - 104, kScreenWidth - 32, 52);
    sureBtn.layer.cornerRadius = 26;
    sureBtn.layer.masksToBounds = YES;
    [self.view addSubview:sureBtn];
}

- (void)initFooterView{
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 62);
    
    UIButton *forgotBtn = [FControlTool createButton:@"忘记支付密码？" font:[UIFont boldFontWithSize:16] textColor:kMainColor target:self sel:@selector(forgotBtnAction)];
    forgotBtn.frame = CGRectMake(50, 20, kScreenWidth - 100, 22);
    [footerView addSubview:forgotBtn];
    
    self.tableView.tableFooterView = footerView;
}

- (void)sureBtnAction{
    NSString *phone = @"";
    NSString *code = @"";
    NSString *password = @"";
    NSString *oldPassword = @"";
    NSString *newPassword = @"";
    NSString *againPassword = @"";
    NSDictionary *params = nil;
    if (self.type == PasswordTypeSetting) {
        phone = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).inputView.inputTextField.text;
        code = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).inputView.inputTextField.text;
        password = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).inputView.inputTextField.text;
        againPassword = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]).inputView.inputTextField.text;
        if (phone.length != 11) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            return;
        }
        if (password.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入支付密码"];
            return;
        }
        if (code.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            return;
        }
        if (![password isEqualToString:againPassword]) {
            [SVProgressHUD showErrorWithStatus:@"两次密码并不相同"];
            return;
        }
        params = @{@"password":password,@"captcha":code};
    }else if (self.type == PasswordTypeEdit) {
        phone = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).inputView.inputTextField.text;
        code = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).inputView.inputTextField.text;
        oldPassword = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).inputView.inputTextField.text;
        newPassword = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]).inputView.inputTextField.text;
        againPassword = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]]).inputView.inputTextField.text;
        
        if (phone.length != 11) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            return;
        }
        if (oldPassword.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
            return;
        }
        if (newPassword.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
            return;
        }
        if (code.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            return;
        }
        if (![newPassword isEqualToString:againPassword]) {
            [SVProgressHUD showErrorWithStatus:@"两次密码并不相同"];
            return;
        }
        params = @{@"password":newPassword,@"captcha":code};
    }else{
        phone = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).inputView.inputTextField.text;
        code = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).inputView.inputTextField.text;
        password = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).inputView.inputTextField.text;
        if (phone.length != 11) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            return;
        }
        if (password.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入支付密码"];
            return;
        }
        if (code.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            return;
        }
        params = @{@"password":password,@"captcha":code};
    }
    
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/updateFullPassword" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (response[@"msg"]) {
                [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
            }else{
                [SVProgressHUD dismiss];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


- (void)forgotBtnAction{
    SWPayPasswordViewController *vc = [[SWPayPasswordViewController alloc] init];
    vc.type = PasswordTypeForgot;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)codeBtnAction{
    NSString *phone = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).inputView.inputTextField.text;
    if (phone.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    [[FVerifyCodeManager sharedManager] getVerifyCodeOnVC:self requestUrl:@"/customer/smsCode" andPhone:phone success:^{
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


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWPasswordInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWPasswordInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.inputView.titleLabel.text = self.dataList[indexPath.row][@"title"];
    [cell.inputView setPlaceholder:self.dataList[indexPath.row][@"placeholder"]];
    if ([self.dataList[indexPath.row][@"title"] hasSuffix:@"密码"]) {
        cell.inputView.inputTextField.secureTextEntry = YES;
    }
    if ([self.dataList[indexPath.row][@"title"] hasSuffix:@"手机号"]) {
        cell.inputView.inputTextField.text = [FUserModel sharedUser].phone;
    }
    if ([cell.inputView.titleLabel.text isEqualToString:@"验证码"]) {
        cell.inputView.inputTextField.width = cell.inputView.inputTextField.width - 82;
        cell.inputView.inputTextField.keyboardType = UIKeyboardTypePhonePad;
        self.codeBtn = [FControlTool createButton:@"发送验证码" font:[UIFont fontWithSize:14] textColor:RGBColor(0x666666) target:self sel:@selector(codeBtnAction)];
        self.codeBtn.frame = CGRectMake(kScreenWidth - 75 - 30, cell.inputView.titleLabel.bottom+5, 75, 44);
        [cell.inputView addSubview:self.codeBtn];
    }else{
        cell.inputView.inputTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
