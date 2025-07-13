//
//  SWRealNameViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/19.
//

#import "SWRealNameViewController.h"
#import <AliyunFaceAuthFacade/AliyunFaceAuthFacade.h>
#import "SWLoginViewController.h"
@interface SWRealNameViewController ()
@property(nonatomic, strong) UITextField *nameTextField;
@property(nonatomic, strong) UITextField *idNoTextField;
@property(nonatomic, strong) UIButton *confirmBtn;
@property(nonatomic, assign) BOOL isAuthSuccess;
@end

@implementation SWRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    
    UILabel *tipLabel = [FControlTool createLabel:@"根据相关法律，开通钱包功能需要先进行实名认证" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:12]];
    tipLabel.frame = CGRectMake(15, kTopHeight+18, kScreenWidth - 30, 15);
    [self.view addSubview:tipLabel];
    
    UILabel *nameLabel = [FControlTool createLabel:@"姓名" textColor:RGBColor(0x333333) font:[UIFont semiBoldFontWithSize:15]];
    nameLabel.frame = CGRectMake(15, tipLabel.bottom+15, kScreenWidth - 30, 18);
    [self.view addSubview:nameLabel];
    
    UIView *nameBgView = [[UIView alloc] init];
    nameBgView.frame = CGRectMake(15, nameLabel.bottom+5, kScreenWidth - 30, 44);
    nameBgView.backgroundColor = RGBColor(0xF2F2F2);
    nameBgView.layer.cornerRadius = 10;
    nameBgView.layer.masksToBounds = YES;
    [self.view addSubview:nameBgView];
    
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.frame = CGRectMake(9, 0, nameBgView.width - 18, 44);
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:@"您的真实姓名" attributes:@{NSForegroundColorAttributeName:RGBColor(0x999999),NSFontAttributeName:[UIFont fontWithSize:12]}];
    self.nameTextField.attributedPlaceholder = placeholderString;
    self.nameTextField.font = [UIFont fontWithSize:12];
    self.nameTextField.textColor = RGBColor(0x333333);
    [nameBgView addSubview:self.nameTextField];
    
    UILabel *idNoLabel = [FControlTool createLabel:@"身份证号" textColor:RGBColor(0x333333) font:[UIFont semiBoldFontWithSize:15]];
    idNoLabel.frame = CGRectMake(15, nameBgView.bottom+15, kScreenWidth - 30, 18);
    [self.view addSubview:idNoLabel];
    
    UIView *idNoBgView = [[UIView alloc] init];
    idNoBgView.frame = CGRectMake(15, idNoLabel.bottom+5, kScreenWidth - 30, 44);
    idNoBgView.backgroundColor = RGBColor(0xF2F2F2);
    idNoBgView.layer.cornerRadius = 10;
    idNoBgView.layer.masksToBounds = YES;
    [self.view addSubview:idNoBgView];
    
    self.idNoTextField = [[UITextField alloc] init];
    self.idNoTextField.frame = CGRectMake(9, 0, nameBgView.width - 18, 44);
    NSAttributedString *idNoPlaceholderString = [[NSAttributedString alloc] initWithString:@"您本人的身份证号" attributes:@{NSForegroundColorAttributeName:RGBColor(0x999999),NSFontAttributeName:[UIFont fontWithSize:12]}];
    self.idNoTextField.attributedPlaceholder = idNoPlaceholderString;
    self.idNoTextField.font = [UIFont fontWithSize:12];
    self.idNoTextField.textColor = RGBColor(0x333333);
    [idNoBgView addSubview:self.idNoTextField];
    
    UIButton *authenticationBtn = [FControlTool createCommonButton:@"提交认证" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 16, 52) target:self sel:@selector(authenticationBtnAction)];
    authenticationBtn.frame = CGRectMake(16, idNoBgView.bottom+56, kScreenWidth - 32, 52);
    [self.view addSubview:authenticationBtn];
    
//    self.confirmBtn = [FControlTool createButton:@"提交认证" font:[UIFont fontWithSize:21] textColor:UIColor.whiteColor target:self sel:@selector(confirmBtnAction)];
//    self.confirmBtn.frame = CGRectMake(60, authenticationBtn.bottom+10, kScreenWidth - 120, 52);
//    self.confirmBtn.backgroundColor = RGBAlphaColor(0x0052B5, 0.5);
//    self.confirmBtn.layer.cornerRadius = 26;
//    self.confirmBtn.layer.masksToBounds = YES;
//    self.confirmBtn.enabled = NO;
//    [self.view addSubview:self.confirmBtn];
}

- (void)authenticationBtnAction{
    if (self.nameTextField.text.length == 0 || self.idNoTextField.text.length != 18) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的信息"];
        return;
    }
    [SVProgressHUD show];
    NSString *metaInfo = [FDataTool convertToJsonData:[AliyunFaceAuthFacade getMetaInfo]];
    NSDictionary *params = @{@"certNo":self.idNoTextField.text, @"certName":self.nameTextField.text, @"metaInfos":metaInfo};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/consumer/certify" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
            [self realNameAuthenticationToAliyunID:response[@"data"][@"certifyId"]];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)confirmBtnAction{
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/consumer/certified" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"认证成功"];
            UIViewController *loginVc;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[SWLoginViewController class]]) {
                    loginVc = vc;
                }
            }
            if (loginVc) {
                [kAppDelegate loginIM:^(BOOL success) {
                    if (success) {
                        [kAppDelegate initTabBarController];
                        [[NSNotificationCenter defaultCenter] postNotificationName:FLoginSuccess object:nil userInfo:nil];
                    }
                }];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)realNameAuthenticationToAliyunID:(NSString *)certifyId {
    NSMutableDictionary * extParams = [@{} mutableCopy];
    [extParams setValue:self forKey:@"currentCtr"];
    [AliyunFaceAuthFacade verifyWith:certifyId extParams:extParams onCompletion:^(ZIMResponse *response) {
        NSString *message;
        switch (response.code) {
            case ZIMResponseSuccess:
            {
                message = @"验证通过";
            }
                break;
            case ZIMInternalError:
            {
                // 用户被动退出
                message = @"用户被动退出";
            }
                break;
            case ZIMInterrupt:
            {
                // 用户主动退出
                message = @"用户主动退出";
            }
                break;
            case ZIMNetworkfail:
            {
                // 网络失败
                message = @"网络失败";
            }
                break;
            case ZIMTIMEError:
            {
                // 设备时间设置不对
                message = @"设备时间设置不对";
            }
                break;
            case ZIMResponseFail:
            {
                // 服务端validate失败
                message = @"服务端validate失败";
            }
                break;
            default:
                break;
        }
        if (response.code == ZIMResponseSuccess) {
            self.isAuthSuccess = YES;
//            self.confirmBtn.enabled = YES;
//            self.confirmBtn.backgroundColor = kMainColor;
            [self confirmBtnAction];
        }else {
            [SVProgressHUD showErrorWithStatus:message];
        }
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
