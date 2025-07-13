//
//  SWRemoteLoginViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/19.
//

#import "SWRemoteLoginViewController.h"
#import "SWSecurityVerifyViewController.h"
@interface SWRemoteLoginViewController ()

@end

@implementation SWRemoteLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"异地登录";
    
    UIImageView *icnImgView = [[UIImageView alloc] init];
    icnImgView.frame = CGRectMake((kScreenWidth - 187)/2, 45+kTopHeight, 187, 186);
    icnImgView.image = [UIImage imageNamed:@"icn_remeto_login"];
    [self.view addSubview:icnImgView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"您正在异地登录，须完成验证方可继续" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    titleLabel.frame = CGRectMake(15, icnImgView.bottom+10, kScreenWidth - 30, 42);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    
    UILabel *tipLabel = [FControlTool createLabel:@"为了保证你的帐号安全，需先脸证你的手机信息，验证成功后可以进行下一步操作。" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:10]];
    tipLabel.frame = CGRectMake(72, titleLabel.bottom+15, kScreenWidth - 144, 30);
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    
    UIButton *verifyBtn = [FControlTool createCommonButton:@"去验证" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 120, 52) target:self sel:@selector(verifyBtnAction)];
    verifyBtn.frame = CGRectMake(60, kScreenHeight - 174, kScreenWidth - 120, 52);
    verifyBtn.layer.cornerRadius = 26;
    verifyBtn.layer.masksToBounds = YES;
    [self.view addSubview:verifyBtn];
    
    UIButton *cancelBtn = [FControlTool createButton:@"暂不验证" font:[UIFont boldFontWithSize:18] textColor:UIColor.blackColor target:self sel:@selector(cancelBtnAction)];
    cancelBtn.frame = CGRectMake(60, verifyBtn.bottom+5, kScreenWidth - 120, 24);
    [self.view addSubview:cancelBtn];
}

- (void)verifyBtnAction{
    SWSecurityVerifyViewController *vc = [[SWSecurityVerifyViewController alloc] init];
    vc.phone = self.phone;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cancelBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
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
