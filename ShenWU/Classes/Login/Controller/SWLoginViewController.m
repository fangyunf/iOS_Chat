//
//  SWLoginViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/19.
//

#import "SWLoginViewController.h"
#import "PForgotPasswordViewController.h"
#import "SWRegisterViewController.h"
#import "YXKeychain.h"
#import "SWRealNameViewController.h"
#import "SWRemoteLoginViewController.h"
#import "SWLoginView.h"
#import "SWRegisterView.h"
@interface SWLoginViewController ()
@property(nonatomic, strong) UIScrollView *bgScrollView;
@property(nonatomic, strong) UIImageView *bgView;
@property(nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) UIButton *registerBtn;
@property(nonatomic, strong) UIView *selectLineView;
@property(nonatomic, strong) SWLoginView *loginView;
@property(nonatomic, strong) SWRegisterView *registerView;
@end

@implementation SWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTopView.hidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = RGBColor(0xF8F8F8);
    
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.frame = CGRectMake(0, 0, kScreenWidth, 312);
    topImgView.image = [UIImage imageNamed:@"bg_login"];
    topImgView.contentMode = UIViewContentModeScaleAspectFill;
    topImgView.userInteractionEnabled = YES;
    [self.view addSubview:topImgView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"Hello!" textColor:RGBColor(0x262727) font:[UIFont semiBoldFontWithSize:32]];
    titleLabel.frame = CGRectMake(16, kStatusBarHeight+65, kScreenWidth - 32, 35);
    [self.view addSubview:titleLabel];
    
    UILabel *tipLabel = [FControlTool createLabel:[NSString stringWithFormat:@"欢迎登录%@",AppName] textColor:RGBColor(0x262727) font:[UIFont boldFontWithSize:20]];
    tipLabel.frame = CGRectMake(16, titleLabel.bottom+8, kScreenWidth - 32, 23);
    [self.view addSubview:tipLabel];
    
    self.bgView = [[UIImageView alloc] init];
    self.bgView.frame = CGRectMake(16, topImgView.height-48, kScreenWidth - 32, kScreenHeight - (topImgView.height-48+25));
    self.bgView.backgroundColor = UIColor.clearColor;
    self.bgView.image = [UIImage imageNamed:@"bg_login_info"];
    [self.bgView rounded:20];
    self.bgView.userInteractionEnabled = YES;
    [self.view addSubview:self.bgView];
    
    self.loginBtn = [FControlTool createButton:@"登录" font:[UIFont boldFontWithSize:16] textColor:RGBColor(0x333333) target:self sel:@selector(loginBtnAction)];
    self.loginBtn.frame = CGRectMake(0, 0, self.bgView.width/2, 48);
    [self.bgView addSubview:self.loginBtn];
    
    self.registerBtn = [FControlTool createButton:@"注册" font:[UIFont boldFontWithSize:16] textColor:RGBColor(0x333333) target:self sel:@selector(registerBtnAction)];
    self.registerBtn.frame = CGRectMake(self.bgView.width/2, 0, self.bgView.width/2, 48);
    [self.bgView addSubview:self.registerBtn];
    
    self.selectLineView = [[UIView alloc] init];
    self.selectLineView.frame = CGRectMake((self.bgView.width/2 - 32)/2, 37, 32, 3);
    [self.bgView addSubview:self.selectLineView];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.selectLineView.bounds;
    gl.startPoint = CGPointMake(1, 0.5);
    gl.endPoint = CGPointMake(0, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:246/255.0 blue:0/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:131/255.0 green:255/255.0 blue:0/255.0 alpha:1].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.selectLineView.layer insertSublayer:gl atIndex:0];
    
    self.bgScrollView = [[UIScrollView alloc] init];
    self.bgScrollView.frame = CGRectMake(0, 48, self.bgView.width, self.bgView.height - 48);
    self.bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.bgView addSubview:self.bgScrollView];
    
    self.loginView = [[SWLoginView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, self.bgView.height - 48)];
    [self.bgScrollView addSubview:self.loginView];
    
    self.registerView = [[SWRegisterView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, self.bgView.height - 48)];
    self.registerView.hidden = YES;
    [self.bgScrollView addSubview:self.registerView];
    
    self.bgScrollView.contentSize = CGSizeMake(self.bgView.width, 489);
}

- (void)loginBtnAction{
    self.bgView.image = [UIImage imageNamed:@"bg_login_info"];
    self.selectLineView.frame = CGRectMake((self.bgView.width/2 - 32)/2, 37, 32, 3);
    self.loginView.hidden = NO;
    self.registerView.hidden = YES;
}

- (void)registerBtnAction{
    self.bgView.image = [UIImage imageNamed:@"bg_register_info"];
    self.selectLineView.frame = CGRectMake(self.registerBtn.left+(self.bgView.width/2 - 32)/2, 37, 32, 3);
    self.loginView.hidden = YES;
    self.registerView.hidden = NO;
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
