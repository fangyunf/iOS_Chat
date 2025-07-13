//
//  SWForgotPasswordViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWForgotPasswordViewController.h"
#import "SWRegisterView.h"
@interface SWForgotPasswordViewController ()
@property(nonatomic, strong) SWRegisterView *registerView;
@end

@implementation SWForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = self.view.bounds;
//    bgImgView.image = [UIImage imageNamed:@"bg_login"];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgImgView];
    
    UIImageView *titleImgView = [[UIImageView alloc] init];
    titleImgView.frame = CGRectMake(kScreenWidth - 198, kTopHeight+23, 146, 146);
    titleImgView.image = [UIImage imageNamed:@"icn_forgot"];
    [self.view addSubview:titleImgView];
    
    self.registerView = [[SWRegisterView alloc] initWithFrame:CGRectMake((kScreenWidth - 313)/2, 258+kStatusBarHeight, 313, 280)];
    self.registerView.isForgot = YES;
    self.registerView.backgroundColor = RGBAlphaColor(0xffffff, 0.6);
    self.registerView.layer.cornerRadius = 15;
    self.registerView.layer.masksToBounds = YES;
    [bgImgView addSubview:self.registerView];
    
    @weakify(self)
    NSString * agreementText = @"登录代表你已经同意《用户协议》和《隐私权政策》";
    NSMutableAttributedString * agreementAtt = [[NSMutableAttributedString alloc] initWithString:agreementText];
    agreementAtt.lineSpacing = 0;
    agreementAtt.color = RGBColor(0x666666);
    agreementAtt.font = [UIFont fontWithSize:13];

    NSRange range = [agreementText rangeOfString:@"《用户协议》"];
    [agreementAtt setColor:RGBColor(0x244DC6) range:range];
    [agreementAtt setTextHighlightRange:range color:RGBColor(0x244DC6) backgroundColor:UIColor.clearColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        FHtmlViewController *vc = [[FHtmlViewController alloc] init];
        vc.localHTMLParh = [[NSBundle mainBundle] pathForResource:@"tiaokuan" ofType:@"html"];
        vc.title = @"用户协议";
        [weak_self.navigationController pushViewController:vc animated:YES];
    }];
    
    NSRange range1 = [agreementText rangeOfString:@"《隐私权政策》"];
    [agreementAtt setColor:RGBColor(0x244DC6) range:range1];
    [agreementAtt setTextHighlightRange:range1 color:RGBColor(0x244DC6) backgroundColor:UIColor.clearColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        FHtmlViewController *vc = [[FHtmlViewController alloc] init];
        vc.localHTMLParh = [[NSBundle mainBundle] pathForResource:@"xieyi" ofType:@"html"];
        vc.title = @"隐私权政策";
        [weak_self.navigationController pushViewController:vc animated:YES];
    }];
    
    YYLabel *agreementLabel = [[YYLabel alloc] init];
    agreementLabel.frame = CGRectMake(15, kScreenHeight - 14 - kBottomSafeHeight, kScreenWidth - 30, 16);
    agreementLabel.font = [UIFont fontWithSize:13];
    agreementLabel.textColor = RGBColor(0x666666);
    agreementLabel.numberOfLines = 0;
    agreementLabel.userInteractionEnabled = YES;
    agreementLabel.attributedText = agreementAtt;
    agreementLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:agreementLabel];
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
