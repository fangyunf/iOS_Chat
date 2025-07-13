//
//  TKSmashingSuccessView.m
//  ShenWU
//
//  Created by Amy on 2024/8/10.
//

#import "TKSmashingSuccessView.h"
#import "SWMyWalletViewController.h"
@implementation TKSmashingSuccessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.5);
        
        UIButton *closeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_smashing_close"] target:self sel:@selector(closeBtnAction)];
        closeBtn.frame = CGRectMake(kScreenWidth - 58*kScale, (kScreenHeight - 328*kScale)/2 - 50 - 79*kScale - 39*kScale, 24*kScale, 24*kScale);
        [self addSubview:closeBtn];
        
        UIImageView *titleImgView = [[UIImageView alloc] init];
        titleImgView.frame = CGRectMake((kScreenWidth - 380*kScale)/2, (kScreenHeight - 328*kScale)/2 - 50 - 79*kScale, 380*kScale, 79*kScale);
        titleImgView.image = [UIImage imageNamed:@"icn_egg_success_title"];
        [self addSubview:titleImgView];
        
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.frame = CGRectMake((kScreenWidth - 374*kScale)/2, (kScreenHeight - 328*kScale)/2 - 50, 374*kScale, 328*kScale);
        bgImgView.image = [UIImage imageNamed:@"bg_smashing"];
        bgImgView.userInteractionEnabled = YES;
        [self addSubview:bgImgView];
        
        UIImageView *eggImgView = [[UIImageView alloc] init];
        eggImgView.frame = CGRectMake((bgImgView.width - 182*kScale)/2, 39*kScale, 182*kScale, 250*kScale);
        eggImgView.image = [UIImage imageNamed:@"icn_smashing_egg"];
        eggImgView.userInteractionEnabled = YES;
        [bgImgView addSubview:eggImgView];
        
        UIButton *lookBtn = [FControlTool createButton:@"查看余额" font:[UIFont boldFontWithSize:20] textColor:UIColor.whiteColor target:self sel:@selector(lookBtnAction)];
        [lookBtn setBackgroundImage:[UIImage imageNamed:@"icn_smashing_btn"] forState:UIControlStateNormal];
        lookBtn.frame = CGRectMake((self.width - 145*kScale)/2, bgImgView.bottom+75*kScale, 145*kScale, 54*kScale);
        [self addSubview:lookBtn];
    }
    return self;
}

- (void)closeBtnAction{
    [self removeFromSuperview];
}

- (void)lookBtnAction{
    [self removeFromSuperview];
    SWMyWalletViewController *vc = [[SWMyWalletViewController alloc] init];
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
