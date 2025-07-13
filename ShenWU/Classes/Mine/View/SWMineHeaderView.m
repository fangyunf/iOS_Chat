//
//  SWMineHeaderView.m
//  ShenWU
//
//  Created by Amy on 2024/6/21.
//

#import "SWMineHeaderView.h"
#import "SWQRcodeViewController.h"
#import "SWEidtInfoViewController.h"
#import "SWMyWalletViewController.h"
#import "SWWebViewController.h"
#import "IRQRCodeView.h"

@interface SWMineHeaderView ()
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UIImageView *arrowImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIButton *idBtn;
@property(nonatomic, strong) UILabel *idLabel;
@property(nonatomic, strong) UILabel *realLabel;
@end

@implementation SWMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(0, 0, kScreenWidth-32, 118);
        self.bgView.backgroundColor = UIColor.clearColor;
        self.bgView.layer.masksToBounds = YES;
        [self addSubview:self.bgView];
        
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake(0, 19, 64, 64);
        self.avatarImgView.layer.cornerRadius = 4;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImgView.userInteractionEnabled = YES;
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[FUserModel sharedUser].headerIcon] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
        [self.bgView addSubview:self.avatarImgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editBtnAction)];
        [self addGestureRecognizer:tap];
        
        CGSize nameSize = [[FUserModel sharedUser].nickName sizeForFont:[UIFont semiBoldFontWithSize:20] size:CGSizeMake(kScreenWidth - (self.avatarImgView.right+39), 24) mode:NSLineBreakByWordWrapping];
        
        self.nameLabel = [FControlTool createLabel:[FUserModel sharedUser].nickName textColor:UIColor.blackColor font:[UIFont semiBoldFontWithSize:20]];
        self.nameLabel.frame = CGRectMake(self.avatarImgView.right+13, self.avatarImgView.top+6, nameSize.width, 25);
        [self.bgView addSubview:self.nameLabel];
        
        self.arrowImgView = [FControlTool createImageView];
        self.arrowImgView.frame = CGRectMake(self.nameLabel.right+2, self.avatarImgView.top+11, 14, 15);
        self.arrowImgView.image = [UIImage imageNamed:@"icn_info_arrow"];
        [self.bgView addSubview:self.arrowImgView];
        
        
        CGSize idSize = [[NSString stringWithFormat:@"账号:%@",[FUserModel sharedUser].memberCode] sizeForFont:[UIFont boldFontWithSize:16] size:CGSizeMake(self.bgView.width - 102, 24) mode:NSLineBreakByWordWrapping];
        
        CGSize realSize = [@"已实名" sizeForFont:[UIFont fontWithSize:12] size:CGSizeMake(self.bgView.width - 102, 15) mode:NSLineBreakByWordWrapping];
//        if ([FUserModel sharedUser].verified.length > 0) {
//            realSize = [@"已实名" sizeForFont:[UIFont fontWithSize:12] size:CGSizeMake(self.bgView.width - 102, 15) mode:NSLineBreakByWordWrapping];
//        }
        
        self.idBtn = [[UIButton alloc] init];
        if (realSize.width > 0) {
            self.idBtn.frame = CGRectMake(self.avatarImgView.right+13, self.nameLabel.bottom+8, idSize.width+4+realSize.width, 24);
        }else{
            self.idBtn.frame = CGRectMake(self.avatarImgView.right+13, self.nameLabel.bottom+8, idSize.width, 24);
        }
        
        [self.idBtn addTarget:self action:@selector(copyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.idBtn];
        
        self.idLabel = [FControlTool createLabel:[NSString stringWithFormat:@"账号:%@",[FUserModel sharedUser].memberCode] textColor:RGBColor(0x282B2C) font:[UIFont boldFontWithSize:16]];
        self.idLabel.frame = CGRectMake(0, 0, idSize.width, 24);
        self.idLabel.layer.masksToBounds = YES;
        self.idLabel.textAlignment = NSTextAlignmentCenter;
        [self.idBtn addSubview:self.idLabel];
        
    
        self.realLabel = [FControlTool createLabel:@"已实名" textColor:RGBColor(0x081C2C) font:[UIFont fontWithSize:12]];
        self.realLabel.frame = CGRectMake(self.idLabel.right+4, 4, realSize.width+6, 16);
        self.realLabel.layer.masksToBounds = YES;
        self.realLabel.textAlignment = NSTextAlignmentCenter;
        self.realLabel.backgroundColor = RGBAlphaColor(0x000000, 0.06);
        [self.realLabel rounded:2];
        [self.idBtn addSubview:self.realLabel];
        
        
//        UIButton *qrBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_qrcode"] target:self sel:@selector(qrCodeBtnAction)];
//        qrBtn.frame = CGRectMake(self.bgView.width - 33, 18, 33, 32);
//        [self addSubview:qrBtn];
        

    }
    return self;
}

- (void)refreshView{
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[FUserModel sharedUser].headerIcon] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    
    CGSize nameSize = [[FUserModel sharedUser].nickName sizeForFont:[UIFont semiBoldFontWithSize:20] size:CGSizeMake(kScreenWidth - (self.avatarImgView.right+39), 24) mode:NSLineBreakByWordWrapping];
    
    self.nameLabel.frame = CGRectMake(self.avatarImgView.right+13, self.avatarImgView.top+6, nameSize.width, 25);
    
    self.arrowImgView.frame = CGRectMake(self.nameLabel.right+2, self.avatarImgView.top+11, 14, 15);
    
    CGSize idSize = [[NSString stringWithFormat:@"账号:%@",[FUserModel sharedUser].memberCode] sizeForFont:[UIFont boldFontWithSize:16] size:CGSizeMake(self.bgView.width - 102, 24) mode:NSLineBreakByWordWrapping];
    
    CGSize realSize = [@"已实名" sizeForFont:[UIFont fontWithSize:12] size:CGSizeMake(self.bgView.width - 102, 15) mode:NSLineBreakByWordWrapping];
//    if ([FUserModel sharedUser].verified.length > 0) {
//        realSize = [@"已实名" sizeForFont:[UIFont fontWithSize:12] size:CGSizeMake(self.bgView.width - 102, 15) mode:NSLineBreakByWordWrapping];
//    }
    if (realSize.width > 0) {
        self.idBtn.frame = CGRectMake(self.avatarImgView.right+13, self.nameLabel.bottom+8, idSize.width+4+realSize.width, 24);
    }else{
        self.idBtn.frame = CGRectMake(self.avatarImgView.right+13, self.nameLabel.bottom+8, idSize.width, 24);
    }
    
    self.idLabel.frame = CGRectMake(0, 0, idSize.width, 24);
    self.realLabel.frame = CGRectMake(self.idLabel.right+4, 4, realSize.width+6, 16);
    
    self.nameLabel.text = [FUserModel sharedUser].nickName;
    self.idLabel.text = [NSString stringWithFormat:@"账号:%@",[FUserModel sharedUser].memberCode];
}

- (void)qrCodeBtnAction{
//    IRQRCodeView *view = [[IRQRCodeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [[FControlTool keyWindow] addSubview:view];
    SWQRcodeViewController *vc = [[SWQRcodeViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)copyBtnAction{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[FUserModel sharedUser].memberCode];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (void)editBtnAction{
    SWEidtInfoViewController *vc = [[SWEidtInfoViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)gameBtnAction{
    [SVProgressHUD showInfoWithStatus:@"敬请期待，等待开放"];
}

- (void)walletBtnAction{
    SWMyWalletViewController *vc = [[SWMyWalletViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)drawBtnAction{
    SWWebViewController *vc = [[SWWebViewController alloc] init];
    vc.urlStr = [NSString stringWithFormat:@"%@:8087/activity/draw",BaseUrl];
    vc.title = @"抽奖";
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
