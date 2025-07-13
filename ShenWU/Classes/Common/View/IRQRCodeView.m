//
//  IRQRCodeView.m
//  ShenWU
//
//  Created by Amy on 2024/8/24.
//

#import "IRQRCodeView.h"
#import "LBXScanWrapper.h"
@interface IRQRCodeView ()
@property(nonatomic, strong) UIImageView *qrCodeImgView;
@end

@implementation IRQRCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.6);
        
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.frame = CGRectMake((kScreenWidth - 320)/2, (kScreenHeight - 538)/2, 320, 538);
//        bgImageView.image = [UIImage imageNamed:@"bg_qrcode_1"];
        bgImageView.backgroundColor = UIColor.whiteColor;
        bgImageView.userInteractionEnabled = YES;
        [bgImageView rounded:11];
        [self addSubview:bgImageView];
        
        UIImageView *avatarImgView = [[UIImageView alloc] init];
        avatarImgView.frame = CGRectMake(45, 24, 74, 74);
        avatarImgView.layer.cornerRadius = 37;
        avatarImgView.layer.masksToBounds = YES;
        avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        [avatarImgView sd_setImageWithURL:[NSURL URLWithString:[FUserModel sharedUser].headerIcon] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
        [bgImageView addSubview:avatarImgView];
        
        UILabel *nameLabel = [FControlTool createLabel:[FUserModel sharedUser].nickName textColor:UIColor.blackColor font:[UIFont boldFontWithSize:16]];
        nameLabel.frame = CGRectMake(avatarImgView.right+15, 39, bgImageView.width - (avatarImgView.right+30), 18);
        [bgImageView addSubview:nameLabel];
        
        UILabel *idLabel = [FControlTool createLabel:[NSString stringWithFormat:@"ID:%@",[FUserModel sharedUser].memberCode] textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
        idLabel.frame = CGRectMake(avatarImgView.right+15, nameLabel.bottom+12, bgImageView.width - (avatarImgView.right+30), 14);
        [bgImageView addSubview:idLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(35, 121, bgImageView.width - 70, 1);
        lineView.backgroundColor = RGBColor(0xe4e4e4);
        [bgImageView addSubview:lineView];
        
        UIButton *closeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_qrcode_close"] target:self sel:@selector(closeBtnAction)];
        closeBtn.frame = CGRectMake(bgImageView.width - 37, 15, 24, 24);
        [bgImageView addSubview:closeBtn];
        
        
        self.qrCodeImgView = [[UIImageView alloc] init];
        self.qrCodeImgView.frame = CGRectMake((bgImageView.width - 250)/2, 161, 250, 250);
        [bgImageView addSubview:self.qrCodeImgView];
        
        UIButton *saveBtn = [FControlTool createButton:@"保存二维码" font:[UIFont boldFontWithSize:16] textColor:kMainColor target:self sel:@selector(saveBtnAction)];
        saveBtn.frame = CGRectMake(70, bgImageView.height+82, bgImageView.width - 140, 60);
        saveBtn.backgroundColor = [UIColor whiteColor];
        [saveBtn rounded:5 width:1 color:kMainColor];
        [bgImageView addSubview:saveBtn];
        
        [SVProgressHUD show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.qrCodeImgView.image = [LBXScanWrapper createQRWithString:[FUserModel sharedUser].memberCode size:self.qrCodeImgView.bounds.size];
//            self.qrCodeImgView.image = [LBXScanWrapper addImageLogo:[LBXScanWrapper createQRWithString:[FUserModel sharedUser].memberCode size:self.qrCodeImgView.bounds.size] centerLogoImage:[UIImage imageNamed:@"icn_qrcode_logo"] logoSize:CGSizeMake(40, 40)];
            [SVProgressHUD dismiss];
        });
    }
    return self;
}

- (void)closeBtnAction{
    [SVProgressHUD dismiss];
    [self removeFromSuperview];
}

- (void)saveBtnAction{
    UIImageWriteToSavedPhotosAlbum(self.qrCodeImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
 
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }else {
        [SVProgressHUD showSuccessWithStatus:@"保存失败"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
