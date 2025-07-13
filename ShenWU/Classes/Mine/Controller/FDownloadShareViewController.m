//
//  FDownloadShareViewController.m
//  Fiesta
//
//  Created by Amy on 2024/7/3.
//

#import "FDownloadShareViewController.h"

@interface FDownloadShareViewController ()
@property(nonatomic, strong) UILabel *versionLabel;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UIButton *updateBtn;
@property(nonatomic, strong) NSMutableArray *linkUrls;
@property(nonatomic, strong) NSString *iosUrl;
@property(nonatomic, strong) NSString *androidUrl;
@end

@implementation FDownloadShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"检查更新";
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = self.view.bounds;
    bgImgView.image = [UIImage imageNamed:@"bg_check_update"];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImgView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"版本更新" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:26]];
    titleLabel.frame = CGRectMake(15, kTopHeight+130, kScreenWidth - 30, 29);
    [self.view addSubview:titleLabel];
    
    self.versionLabel = [FControlTool createLabel:@"" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:18]];
    self.versionLabel.frame = CGRectMake(15, titleLabel.bottom+20, 90, 31);
    self.versionLabel.backgroundColor = RGBColor(0xFDC040);
    self.versionLabel.layer.cornerRadius = 5;
    self.versionLabel.layer.masksToBounds = YES;
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.versionLabel];
    
    self.tipLabel = [FControlTool createLabel:[NSString stringWithFormat:@"当前是V%@,已是最新版本",AppBuildVersion] textColor:UIColor.blackColor font:[UIFont boldFontWithSize:18]];
    self.tipLabel.frame = CGRectMake(15, self.versionLabel.bottom+56, kScreenWidth - 30, 31);
    [self.view addSubview:self.tipLabel];
    
    self.updateBtn = [FControlTool createButton:@"" font:[UIFont boldFontWithSize:18] textColor:UIColor.whiteColor target:self sel:@selector(updateBtnAction)];
    self.updateBtn.frame = CGRectMake((kScreenWidth - 260)/2, self.tipLabel.bottom+88, 260, 60);
    self.updateBtn.backgroundColor = kMainColor;
    self.updateBtn.layer.cornerRadius = 30;
    self.updateBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.updateBtn];
    
    [self requestData];
}

- (void)updateBtnAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.iosUrl] options:@{} completionHandler:^(BOOL success) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
    }];
}

- (void)requestData{
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/customer/about" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"linkUrl"]]) {
                [weak_self.linkUrls addObjectsFromArray:response[@"data"][@"linkUrl"]];
                for (NSDictionary *dic in weak_self.linkUrls) {
                    if (![FDataTool isNull:dic[@"appType"]] && [dic[@"appType"] isEqualToString:@"IOS"]) {
                        weak_self.iosUrl = dic[@"downloadUrl"];
                        weak_self.versionLabel.text = AppBuildVersion;
                        weak_self.tipLabel.text = [NSString stringWithFormat:@"当前是V%@,去更新",AppBuildVersion];
                        [weak_self.updateBtn setTitle:@"去更新" forState:UIControlStateNormal];
                        weak_self.updateBtn.userInteractionEnabled = YES;
                    }
                }
            }
            [SVProgressHUD dismiss];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

//- (void)updateContent{
//    NSString * contentText = [NSString stringWithFormat:@"苹果官方下载地址：\n%@\n安卓官方下载地址：\n%@",self.iosUrl,self.androidUrl];
//    NSMutableAttributedString * contentAtt = [[NSMutableAttributedString alloc] initWithString:contentText];
//    contentAtt.lineSpacing = 0;
//    contentAtt.color = UIColor.blackColor;
//    contentAtt.font = [UIFont fontWithSize:16];
//
//    NSRange range = [contentText rangeOfString:self.iosUrl];
//    [contentAtt setColor:kMainColor range:range];
//    [contentAtt setTextHighlightRange:range color:kMainColor backgroundColor:UIColor.clearColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
//        [pasteboard setString:self.iosUrl];
//        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
//    }];
//    
//    NSRange range1 = [contentText rangeOfString:self.androidUrl];
//    [contentAtt setColor:kMainColor range:range1];
//    [contentAtt setTextHighlightRange:range1 color:kMainColor backgroundColor:UIColor.clearColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
//        [pasteboard setString:self.androidUrl];
//        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
//    }];
//    
//    self.contentLabel.attributedText = contentAtt;
//    self.contentLabel.textAlignment = NSTextAlignmentCenter;
//}

- (NSMutableArray *)linkUrls{
    if (!_linkUrls) {
        _linkUrls = [[NSMutableArray alloc] init];
    }
    return _linkUrls;
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
