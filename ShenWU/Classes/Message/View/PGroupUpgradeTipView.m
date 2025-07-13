//
//  PGroupUpgradeTipView.m
//  ShenWU
//
//  Created by Amy on 2024/7/17.
//

#import "PGroupUpgradeTipView.h"
#import "PGroupUpgradeViewController.h"
@interface PGroupUpgradeTipView ()

@end

@implementation PGroupUpgradeTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.5);
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(30, (kScreenHeight - 425)/2, kScreenWidth - 60, 425);
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 20;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        
        UIImageView *icnImgView = [[UIImageView alloc] init];
        icnImgView.frame = CGRectMake((kScreenWidth -249)/2, bgView.top - 57, 249, 137);
        icnImgView.image = [UIImage imageNamed:@"icn_group_upgrade"];
        [self addSubview:icnImgView];
        
        UILabel *titleLabel = [FControlTool createLabel:@"群聊人数已达上限，须升级后方可拉入新成员！" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
        titleLabel.frame = CGRectMake(72, 142, bgView.width - 144, 43);
        titleLabel.numberOfLines = 0;
        [bgView addSubview:titleLabel];
        
        UILabel *tipLabel = [FControlTool createLabel:@"当前您的群聊人数已超过该群聊级别，不可拉入新成员，须升级该群级别方可正常使用！" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:10]];
        tipLabel.frame = CGRectMake(40, titleLabel.bottom+15, bgView.width - 80, 30);
        tipLabel.numberOfLines = 0;
        [bgView addSubview:tipLabel];
        
        UIButton *cancelBtn = [FControlTool createButton:@"取消" font:[UIFont boldFontWithSize:15] textColor:RGBColor(0x000000) target:self sel:@selector(cancelBtnAction)];
        cancelBtn.frame = CGRectMake(40, bgView.height - 127, 100, 60);
        cancelBtn.backgroundColor = RGBColor(0xF2F2F2);
        cancelBtn.layer.cornerRadius = 30;
        cancelBtn.layer.masksToBounds = YES;
        [bgView addSubview:cancelBtn];
        
        UIButton *upgradeBtn = [FControlTool createButton:@"升级" font:[UIFont boldFontWithSize:15] textColor:RGBColor(0xffffff) target:self sel:@selector(upgradeBtnAction)];
        upgradeBtn.frame = CGRectMake(bgView.width - 140, bgView.height - 127, 100, 60);
        upgradeBtn.backgroundColor = RGBColor(0xFF8400);
        upgradeBtn.layer.cornerRadius = 30;
        upgradeBtn.layer.masksToBounds = YES;
        [bgView addSubview:upgradeBtn];
    }
    return self;
}

- (void)cancelBtnAction{
    [self removeFromSuperview];
}

- (void)upgradeBtnAction{
    PGroupUpgradeViewController *vc = [[PGroupUpgradeViewController alloc] init];
    vc.model = self.model;
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
