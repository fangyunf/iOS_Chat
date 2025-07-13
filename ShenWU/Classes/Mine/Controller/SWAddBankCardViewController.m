//
//  SWAddBankCardViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/1.
//

#import "SWAddBankCardViewController.h"
#import "SWPasswordInputCell.h"
@interface SWAddBankCardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, strong) UIButton *codeBtn;
@property(nonatomic, assign) NSInteger timeCount;
@property(nonatomic, strong) NSTimer *codeTimer;
@property(nonatomic, strong) NSString *applyId;
@property(nonatomic, strong) NSString *memberId;
@end

@implementation SWAddBankCardViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"添加银行卡";
    
    UILabel *tipLabel = [FControlTool createLabel:@"请填写您本人的银行卡信息" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
    tipLabel.frame = CGRectMake(15, kTopHeight+20, kScreenWidth - 30, 16);
    [self.view addSubview:tipLabel];
    
    self.dataList = @[@{@"title":@"姓名",@"placeholder":@"您的真实姓名"},
                      @{@"title":@"身份证号",@"placeholder":@"您的身份证号码"},
                      @{@"title":@"银行卡卡号",@"placeholder":@"您本人的银行卡卡号"},
                      @{@"title":@"银行名称",@"placeholder":@"所属银行"},
                      @{@"title":@"预留手机号",@"placeholder":@"请输入您的手机号码"},
                      @{@"title":@"输入验证码",@"placeholder":@"请输入验证码"}];
    
    [self.tableView reloadData];
    
    UIButton *sureBtn = [FControlTool createButton:@"完成" font:[UIFont boldFontWithSize:18] textColor:UIColor.whiteColor target:self sel:@selector(sureBtnAction)];
    sureBtn.frame = CGRectMake(60, kScreenHeight - 104, kScreenWidth - 120, 52);
    sureBtn.backgroundColor = kMainColor;
    sureBtn.layer.cornerRadius = 26;
    sureBtn.layer.masksToBounds = YES;
    [self.view addSubview:sureBtn];
    
//    ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).inputView.inputTextField.text = @"房云峰";
//    ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).inputView.inputTextField.text = @"6228 4800 39048990970";
//    ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).inputView.inputTextField.text = @"农业银行";
//    ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]).inputView.inputTextField.text = @"13761543036";
    
}

- (void)sureBtnAction{
    NSString *userName = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).inputView.inputTextField.text;
    NSString *cardNo = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).inputView.inputTextField.text;
    NSString *phone = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]]).inputView.inputTextField.text;
    NSString *code = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]]).inputView.inputTextField.text;;
    if (self.applyId.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先请求验证码"];
        return;
    }
    if (code.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    [SVProgressHUD show];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"apply_id"] = self.applyId;
    params[@"memberId"] = self.memberId;
    params[@"smsCode"] = code;
    params[@"configId"] = @"3";
    params[@"userId"] = [FUserModel sharedUser].userID;
    [[FNetworkManager sharedManager] postRequestFromServer:@"/pay/createCardConfirm" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            params[@"name"] = userName;
            params[@"certNo"] = cardNo;
            params[@"phone"] = phone;
            params[@"usdt"] = self.memberId;
            params[@"userId"] = [FUserModel sharedUser].userID;
            params[@"type"] = @(3);
            [[FNetworkManager sharedManager] postRequestFromServer:@"/card/buildCard" parameters:params success:^(NSDictionary * _Nonnull response) {
                [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:error.description];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
}

- (void)codeBtnAction{
    NSString *userName = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).inputView.inputTextField.text;
    NSString *idNumber = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).inputView.inputTextField.text;
    NSString *cardNo = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).inputView.inputTextField.text;
    NSString *bankName = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]).inputView.inputTextField.text;
    NSString *phone = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]]).inputView.inputTextField.text;
    if (userName.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的真实姓名"];
        return;
    }
    if (cardNo.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您本人的银行卡卡号"];
        return;
    }
    if (bankName.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入所属银行"];
        return;
    }
    if (phone.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    [SVProgressHUD show];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"bankUserName"] = userName;
    params[@"bankCardNo"] = [cardNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    params[@"bankPhone"] = phone;
    params[@"bankName"] = bankName;
    params[@"idNumber"] = idNumber;
    params[@"configId"] = @"3";
    params[@"userId"] = [FUserModel sharedUser].userID;
    [[FNetworkManager sharedManager] postRequestFromServer:@"/pay/createCardApply" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            self.applyId = response[@"data"][@"id"];
            self.memberId = response[@"data"][@"member_id"];
            [SVProgressHUD showSuccessWithStatus:@"请求验证码成功"];
            [self startTimer];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.description];
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
    if ([cell.inputView.titleLabel.text containsString:@"银行卡卡号"] || [cell.inputView.titleLabel.text containsString:@"手机号"]) {
        cell.inputView.inputTextField.keyboardType = UIKeyboardTypePhonePad;
    }else{
        cell.inputView.inputTextField.keyboardType = UIKeyboardTypeDefault;
    }
    if ([cell.inputView.titleLabel.text containsString:@"验证码"]) {
        cell.inputView.inputTextField.width = cell.inputView.inputTextField.width - 82;
        cell.inputView.inputTextField.keyboardType = UIKeyboardTypePhonePad;
        self.codeBtn = [FControlTool createButton:@"发送验证码" font:[UIFont fontWithSize:14] textColor:RGBColor(0x666666) target:self sel:@selector(codeBtnAction)];
        self.codeBtn.frame = CGRectMake(kScreenWidth - 75 - 30, cell.inputView.titleLabel.bottom+5, 75, 44);
        [cell.inputView addSubview:self.codeBtn];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight+46, kScreenWidth, kScreenHeight-kTopHeight - 46) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 134)];
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
