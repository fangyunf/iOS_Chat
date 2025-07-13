//
//  SWVerifySuccessViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/19.
//

#import "SWVerifySuccessViewController.h"

@interface SWVerifySuccessViewController ()

@end

@implementation SWVerifySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证成功";
    
    UIImageView *icnImgView = [[UIImageView alloc] init];
    icnImgView.frame = CGRectMake((kScreenWidth - 46)/2, 61+kTopHeight, 46, 46);
    icnImgView.image = [UIImage imageNamed:@"icn_verify_success"];
    [self.view addSubview:icnImgView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"恭喜您！验证成功！" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    titleLabel.frame = CGRectMake(15, icnImgView.bottom+15, kScreenWidth - 30, 18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIButton *loginBtn = [FControlTool createCommonButton:@"登录" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 120, 52) target:self sel:@selector(loginBtnAction)];
    loginBtn.frame = CGRectMake(30, titleLabel.bottom+57, kScreenWidth - 60, 52);
    loginBtn.layer.cornerRadius = 26;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
}

- (void)loginBtnAction{
    [[FUserModel sharedUser] saveUserInfoWithPhone:self.userDict[@"phoneNo"] NickName:self.userDict[@"username"] ImToken:self.userDict[@"imToken"] UserID:self.userDict[@"userId"] memberCode:self.userDict[@"memberCode"] AndUserToken:self.userDict[@"token"] avator:self.userDict[@"avatar"] AndVipLevel:self.userDict[@"grade"]AndAuthentication:self.userDict[@"verified"]];
    [kAppDelegate loginIM:^(BOOL success) {
        if (success) {
            [kAppDelegate initTabBarController];
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
