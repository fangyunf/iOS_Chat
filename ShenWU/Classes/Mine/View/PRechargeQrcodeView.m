//
//  PRechargeQrcodeView.m
//  ShenWU
//
//  Created by Amy on 2024/7/27.
//

#import "PRechargeQrcodeView.h"

@interface PRechargeQrcodeView ()
@property(nonatomic, strong) UIView *bgView;
@end

@implementation PRechargeQrcodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.5);
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(kScreenWidth/4, (kScreenHeight - kScreenWidth/2 - 30)/2, kScreenWidth/2,  kScreenWidth/2+20);
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        self.rechargeTipLabel = [FControlTool createLabel:@"请使用支付宝扫二维码进行充值" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
        self.rechargeTipLabel.frame = CGRectMake(0, 5, kScreenWidth/2, 20);
        self.rechargeTipLabel.textAlignment = NSTextAlignmentCenter;
        self.rechargeTipLabel.numberOfLines = 0;
        [self.bgView addSubview:self.rechargeTipLabel];
        
        self.rechargeImgView = [[UIImageView alloc] init];
        self.rechargeImgView.frame = CGRectMake(0, self.rechargeTipLabel.bottom+10, kScreenWidth/2, kScreenWidth/2);
        self.rechargeImgView.contentMode = UIViewContentModeScaleToFill;
        [self.bgView addSubview:self.rechargeImgView];
        
        
    }
    return self;
}

#pragma mark - 方法重新
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (!CGRectContainsPoint(self.bgView.frame, [touch locationInView:self])) {
        [self removeFromSuperview];
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
