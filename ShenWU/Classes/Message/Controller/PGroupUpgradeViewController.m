//
//  PGroupUpgradeViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/17.
//

#import "PGroupUpgradeViewController.h"
#import "SWRechargeViewController.h"
#import "PEscalationRuleViewController.h"
@interface PGroupUpgradeViewController ()
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, assign) double balance;
@end

@implementation PGroupUpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"升级群组";
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(15, kTopHeight+10, 323, 160);
    bgImgView.image = [UIImage imageNamed:@"bg_group_upgrade"];
    [self.view addSubview:bgImgView];
    
    self.priceLabel = [FControlTool createLabel:@"￥88" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:40]];
    self.priceLabel.frame = CGRectMake(41, 57, bgImgView.width - 82, 43);
    [bgImgView addSubview:self.priceLabel];
    
    self.tipLabel = [FControlTool createLabel:@"购买即升级当前群组为500人群" textColor:UIColor.whiteColor font:[UIFont fontWithSize:12]];
    self.tipLabel.frame = CGRectMake(34, 115, bgImgView.width - 82, 15);
    [bgImgView addSubview:self.tipLabel];
    
    
    UIButton *payBtn = [FControlTool createCommonButton:@"立即购买" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 120, 52) target:self sel:@selector(payBtnAction)];
    payBtn.frame = CGRectMake(60, kScreenHeight - 104, kScreenWidth - 120, 52);
    payBtn.layer.cornerRadius = 26;
    payBtn.layer.masksToBounds = YES;
    [self.view addSubview:payBtn];
    
    UIButton *infoBtn = [FControlTool createButton:@"群升级规则" font:[UIFont fontWithSize:14] textColor:kMainColor target:self sel:@selector(infoBtnAction)];
    infoBtn.frame = CGRectMake(60, payBtn.top - 38, kScreenWidth - 120, 17);
    [self.view addSubview:infoBtn];
    
    [self requestBalance];
}

- (void)requestBalance{
    @weakify(self)
    [[FUserModel sharedUser] getBalance:^(double balance) {
        weak_self.balance = balance;
    }];
}

- (void)infoBtnAction{
    PEscalationRuleViewController *vc = [[PEscalationRuleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)payBtnAction{
    if (self.balance < 88) {
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
    @weakify(self)
    [FPayPasswordView showPayPrice:@"88" success:^(NSString * _Nonnull password) {
        [weak_self requestBuy:password];
    }];
    
}

- (void)requestBuy:(NSString *)password{
    @weakify(self)
    [SVProgressHUD show];
    NSDictionary *parmas = @{@"groupId":self.model.groupId,@"password":password,@"grade":@"2"};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/buyGroupGrade" parameters:parmas success:^(NSDictionary * _Nonnull response) {
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
