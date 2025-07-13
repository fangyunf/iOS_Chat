//
//  PBuyNumberViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/17.
//

#import "PBuyNumberViewController.h"
#import "SWRechargeViewController.h"
@interface PBuyNumberViewController ()
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UITextField *numTextField;
@property(nonatomic, assign) double balance;
@end

@implementation PBuyNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买副号";
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(15, kTopHeight+10, 323, 160);
    bgImgView.image = [UIImage imageNamed:@"bg_buy_number"];
    [self.view addSubview:bgImgView];
    
    self.priceLabel = [FControlTool createLabel:@"￥68" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:40]];
    self.priceLabel.frame = CGRectMake(41, 57, bgImgView.width - 82, 43);
    [bgImgView addSubview:self.priceLabel];
    
    self.tipLabel = [FControlTool createLabel:@"购买即得20个副号" textColor:UIColor.whiteColor font:[UIFont fontWithSize:12]];
    self.tipLabel.frame = CGRectMake(34, 115, bgImgView.width - 82, 15);
    [bgImgView addSubview:self.tipLabel];
    
    UILabel *titleLabel = [FControlTool createLabel:@"自定义副号" textColor:[UIColor blackColor] font:[UIFont boldFontWithSize:15]];
    titleLabel.frame = CGRectMake(25, bgImgView.bottom+25, kScreenWidth - 50, 18);
    [self.view addSubview:titleLabel];
    
    UIView *inputBgView = [[UIView alloc] init];
    inputBgView.frame = CGRectMake(25, titleLabel.bottom+15, kScreenWidth - 50, 45);
    inputBgView.backgroundColor = RGBColor(0xF2F2F2);
    inputBgView.layer.cornerRadius = 15;
    inputBgView.layer.masksToBounds = YES;
    [self.view addSubview:inputBgView];
    
    UILabel *oneLabel = [FControlTool createLabel:@"1" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
    oneLabel.frame = CGRectMake(15, 0, 6, 45);
    [inputBgView addSubview:oneLabel];
    
    self.numTextField = [[UITextField alloc] init];
    self.numTextField.frame = CGRectMake(25, 0, 115, 45);
    self.numTextField.placeholder = @"请输入自定义副号";
    self.numTextField.textColor = [UIColor blackColor];
    self.numTextField.font = [UIFont fontWithSize:14];
    self.numTextField.keyboardType = UIKeyboardTypeNumberPad;
    [inputBgView addSubview:self.numTextField];
    
    UILabel *zeroLabel = [FControlTool createLabel:@"000" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
    zeroLabel.frame = CGRectMake(155, 0, 30, 45);
    [inputBgView addSubview:zeroLabel];
    
    UILabel *tipLabel = [FControlTool createLabel:@"请输入5位数字号码，前一位和后三位为固定数字不可更改" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:12]];
    tipLabel.frame = CGRectMake(25, inputBgView.bottom+4, kScreenWidth - 50, 15);
    [self.view addSubview:tipLabel];
    
    UIButton *payBtn = [FControlTool createCommonButton:@"立即购买" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 120, 52) target:self sel:@selector(payBtnAction)];
    payBtn.frame = CGRectMake(60, kScreenHeight - 104, kScreenWidth - 120, 52);
    payBtn.layer.cornerRadius = 26;
    payBtn.layer.masksToBounds = YES;
    [self.view addSubview:payBtn];
    
    [self requestBalance];
}

- (void)requestBalance{
    @weakify(self)
    [[FUserModel sharedUser] getBalance:^(double balance) {
        weak_self.balance = balance;
    }];
}

- (void)payBtnAction{
    if (self.balance < 68) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"零钱不足" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SWRechargeViewController *vc = [[SWRechargeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    if (self.numTextField.text.length != 5) {
        [SVProgressHUD showErrorWithStatus:@"请输入5位数字号码"];
        return;
    }
    @weakify(self)
    [FPayPasswordView showPayPrice:@"68" success:^(NSString * _Nonnull password) {
        [weak_self requestBuy:password];
    }];
    
}

- (void)requestBuy:(NSString *)password{
    @weakify(self)
    [SVProgressHUD show];
    NSDictionary *parmas = @{@"phone":[NSString stringWithFormat:@"1%@000",self.numTextField.text],@"password":password};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/gmfh" parameters:parmas success:^(NSDictionary * _Nonnull response) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
