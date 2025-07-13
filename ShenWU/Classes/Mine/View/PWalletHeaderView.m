//
//  PWalletHeaderView.m
//  ShenWU
//
//  Created by Amy on 2024/7/9.
//

#import "PWalletHeaderView.h"
#import "SWRechargeViewController.h"
#import "SWWithdrawViewController.h"
#import "SWNewRechargeViewController.h"
@interface PWalletHeaderView ()

@end

@implementation PWalletHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 70, kScreenWidth-32, 280);
        bgView.backgroundColor = [UIColor clearColor];
        [bgView rounded:8];
        [self addSubview:bgView];
        
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = bgView.bounds;
        gl.startPoint = CGPointMake(0.98, 0);
        gl.endPoint = CGPointMake(0.54, 0.58);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.43].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        gl.cornerRadius = 8;
        [bgView.layer insertSublayer:gl atIndex:0];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualView.frame = bgView.bounds;
        [bgView addSubview:visualView];

        UILabel *tipLabel = [FControlTool createLabel:@"资金安全有保障" textColor:RGBColor(0xFF6004) font:[UIFont fontWithSize:14]];
        tipLabel.frame = CGRectMake(0, 10, bgView.width, 40);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [tipLabel addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(8, 8)];
        [bgView addSubview:tipLabel];
        
        UILabel *titleLabel = [FControlTool createLabel:@"可用余额(元)" textColor:RGBColor(0x282B2C) font:[UIFont fontWithSize:16]];
        titleLabel.frame = CGRectMake(17, 68, bgView.width - 34, 24);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:titleLabel];
        
        self.moneyLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont semiBoldFontWithSize:40]];
        self.moneyLabel.frame = CGRectMake(17, titleLabel.bottom+16, bgView.width - 34, 40);
        self.moneyLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:self.moneyLabel];
        
        UIButton *withdrawBtn = [FControlTool createButton:@"提现" font:[UIFont boldFontWithSize:16] textColor:UIColor.blackColor target:self sel:@selector(withdrawBtnAction)];
        withdrawBtn.frame = CGRectMake(16, bgView.height-64, (bgView.width - 41)/2, 48);
        withdrawBtn.layer.masksToBounds = YES;
        [withdrawBtn rounded:8 width:1 color:RGBColor(0x979797)];
        [bgView addSubview:withdrawBtn];
        
        UIButton *rechargeBtn = [FControlTool createCommonButton:@"充值" font:[UIFont boldFontWithSize:16] cornerRadius:8 size:CGSizeMake((bgView.width - 41)/2, 48) target:self sel:@selector(rechargeBtnAction)];
        rechargeBtn.frame = CGRectMake(withdrawBtn.right + 9, bgView.height-64, (bgView.width - 41)/2, 48);
        rechargeBtn.layer.masksToBounds = YES;
        [rechargeBtn rounded:8];
        rechargeBtn.backgroundColor = kMainColor;
        [bgView addSubview:rechargeBtn];
    }
    return self;
}

- (void)rechargeBtnAction{
//    SWRechargeViewController *vc = [[SWRechargeViewController alloc] init];
//    vc.url = @"/pay/adaPay";
//    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    SWRechargeViewController *vc = [[SWRechargeViewController alloc] init];
    vc.url = @"/pay/six";
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)rechargeBtn1Action{
    SWRechargeViewController *vc = [[SWRechargeViewController alloc] init];
    vc.url = @"/pay/sixL";
    vc.isSelect = YES;
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)withdrawBtnAction{
    SWWithdrawViewController *vc = [[SWWithdrawViewController alloc] init];
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
