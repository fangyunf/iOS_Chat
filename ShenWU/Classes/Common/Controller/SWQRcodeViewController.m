//
//  SWQRcodeViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/21.
//

#import "SWQRcodeViewController.h"
#import "LBXScanWrapper.h"
@interface SWQRcodeViewController ()
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UIImageView *qrCodeImgView;
@end

@implementation SWQRcodeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isGroup) {
        self.title = @"群二维码";
    }else{
        self.title = @"我的二维码";
    }
    self.navTopView.hidden = NO;
    self.view.backgroundColor = RGBColor(0xF5F7FA);
    
    self.avatarImgView = [FControlTool createImageView];
    self.avatarImgView.frame = CGRectMake((kScreenWidth - 52)/2, kTopHeight+19, 52, 52);
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[FUserModel sharedUser].headerIcon] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    [self.avatarImgView rounded:26];
    [self.view addSubview:self.avatarImgView];
    
    UILabel *nameLabel = [FControlTool createLabel:[FUserModel sharedUser].nickName textColor:UIColor.blackColor font:[UIFont boldFontWithSize:20]];
    nameLabel.frame = CGRectMake(0, self.avatarImgView.bottom+8, kScreenWidth, 24);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    UILabel *idLabel = [FControlTool createLabel:[NSString stringWithFormat:@"账号:%@",[FUserModel sharedUser].memberCode] textColor:RGBColor(0x081C2C) font:[UIFont fontWithSize:14]];
    idLabel.frame = CGRectMake(0, nameLabel.bottom+8, kScreenWidth, 14);
    idLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:idLabel];
    
    UIButton *copyBtn = [FControlTool createButton:@"复制账号" font:[UIFont fontWithSize:14] textColor:UIColor.blackColor target:self sel:@selector(copyBtnAction)];
    copyBtn.frame = CGRectMake((kScreenWidth - 96)/2, idLabel.bottom+6, 96, 36);
    [copyBtn rounded:4 width:0.6 color:RGBColor(0x979797)];
    [self.view addSubview:copyBtn];
    
    UIImageView *middleImgView = [[UIImageView alloc] init];
    middleImgView.frame = CGRectMake((kScreenWidth - 240)/2, copyBtn.bottom+32, 240, 240);
    middleImgView.userInteractionEnabled = YES;
    middleImgView.backgroundColor = [UIColor whiteColor];
    [middleImgView rounded:11];
    middleImgView.layer.masksToBounds = YES;
    [self.view addSubview:middleImgView];
    
    self.qrCodeImgView = [[UIImageView alloc] init];
    self.qrCodeImgView.frame = CGRectMake((middleImgView.width - 240)/2, 0, 240, 240);
    [middleImgView addSubview:self.qrCodeImgView];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //[NSString stringWithFormat:@"打开%@扫一扫，添加好友",[infoDictionary objectForKey:@"CFBundleDisplayName"]]
    UILabel *tipLabel = [FControlTool createLabel:@"扫一扫二维码，加我好友" textColor:RGBColor(0x081C2C) font:[UIFont fontWithSize:16]];
    tipLabel.frame = CGRectMake(15, middleImgView.bottom+15, kScreenWidth - 30, 24);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    
    UIButton *saveBtn = [FControlTool createButton:@"保存二维码" font:[UIFont boldFontWithSize:16] textColor:RGBColor(0xFF6004) target:self sel:@selector(saveBtnAction)];
    saveBtn.frame = CGRectMake(15, tipLabel.bottom+21, kScreenWidth - 30, 48);
    saveBtn.layer.cornerRadius = 24;
    saveBtn.backgroundColor = UIColor.clearColor;
    saveBtn.layer.masksToBounds = YES;
    [self.view addSubview:saveBtn];
    
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isGroup) {
            self.qrCodeImgView.image = [LBXScanWrapper addImageLogo:[LBXScanWrapper createQRWithString:self.groupModel.groupId size:self.qrCodeImgView.bounds.size] centerLogoImage:[UIImage imageNamed:@"icn_qrcode_logo"] logoSize:CGSizeMake(40, 40)];
        }else{
            self.qrCodeImgView.image = [LBXScanWrapper imageBlackToTransparent:[LBXScanWrapper createQRWithString:[self getQRString] size:self.qrCodeImgView.bounds.size] withRed:0 andGreen:0 andBlue:0];//[LBXScanWrapper addImageLogo:[LBXScanWrapper imageBlackToTransparent:[LBXScanWrapper createQRWithString:[self getQRString] size:self.qrCodeImgView.bounds.size] withRed:0 andGreen:0 andBlue:0] centerLogoImage:self.avatarImgView.image logoSize:CGSizeMake(80, 80)];//[UIImage imageNamed:@"logo"]
        }
        [SVProgressHUD dismiss];
    });
}

- (void)saveBtnAction{
    UIImageWriteToSavedPhotosAlbum(self.qrCodeImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)copyBtnAction{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[FUserModel sharedUser].memberCode];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}
 
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }else {
        [SVProgressHUD showSuccessWithStatus:@"保存失败"];
    }
}

- (NSString*)getQRString{
    NSString *memberCode = [NSString stringWithFormat:@"1232323213588882583285828358238582858285821238128388128381283818212323232135888825832858283582385828582858212381283881283812838182.%@.adasdasd11312adasdadae12123adadad",[FUserModel sharedUser].memberCode];
    
    return memberCode;
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
