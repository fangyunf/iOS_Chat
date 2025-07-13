//
//  TKPaySucceseAlertView.m
//  ShenWU
//
//  Created by Amy on 2024/8/25.
//

#import "TKPaySucceseAlertView.h"

@interface TKPaySucceseAlertView ()
@property(nonatomic, strong) UIImageView *bgImgView;
@end

@implementation TKPaySucceseAlertView

- (instancetype)initWithFrame:(CGRect)frame bgImgStr:(NSString*)bgImgStr title:(NSString*)title des:(NSString*)des btnStr:(NSString*)btnStr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.6);
        
        self.bgImgView = [[UIImageView alloc] init];
        self.bgImgView.frame = CGRectMake((kScreenWidth - 345)/2, (kScreenHeight - 250)/2, 345, 250);
        self.bgImgView.image = [UIImage imageNamed:bgImgStr];
        self.bgImgView.userInteractionEnabled = YES;
        [self addSubview:self.bgImgView];
        
        UILabel *titleLabel = [FControlTool createLabel:title textColor:UIColor.blackColor font:[UIFont boldFontWithSize:18]];
        titleLabel.frame = CGRectMake(10, 60, self.bgImgView.width - 20, 21);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgImgView addSubview:titleLabel];
        
        UILabel *desLabel = [FControlTool createLabel:des textColor:RGBColor(0x999999) font:[UIFont boldFontWithSize:14]];
        desLabel.frame = CGRectMake(10, titleLabel.bottom+10, self.bgImgView.width - 20, 17);
        desLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgImgView addSubview:desLabel];
        
        UIButton *cancelBtn = [FControlTool createButton:@"取消" font:[UIFont boldFontWithSize:15] textColor:UIColor.blackColor target:self sel:@selector(cancelBtnAction)];
        cancelBtn.frame = CGRectMake(54, self.bgImgView.height - 104, 100, 60);
        cancelBtn.backgroundColor = RGBColor(0xF2F2F2);
        cancelBtn.layer.cornerRadius = 30;
        cancelBtn.layer.masksToBounds = YES;
        [self.bgImgView addSubview:cancelBtn];
        
        UIButton *sureBtn = [FControlTool createButton:btnStr font:[UIFont boldFontWithSize:15] textColor:UIColor.whiteColor target:self sel:@selector(sureBtnAction)];
        sureBtn.frame = CGRectMake(self.bgImgView.width - 154, self.bgImgView.height - 104, 100, 60);
        sureBtn.backgroundColor = kMainColor;
        sureBtn.layer.cornerRadius = 30;
        sureBtn.layer.masksToBounds = YES;
        [self.bgImgView addSubview:sureBtn];
    }
    return self;
}

- (void)cancelBtnAction{
    [self removeFromSuperview];
}

- (void)sureBtnAction{
    if (self.clickOnSureBtn) {
        self.clickOnSureBtn();
    }
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
