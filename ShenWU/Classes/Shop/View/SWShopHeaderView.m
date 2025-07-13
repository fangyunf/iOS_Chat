//
//  SWShopHeaderView.m
//  ShenWU
//
//  Created by Amy on 2024/10/19.
//

#import "SWShopHeaderView.h"

@implementation SWShopHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bannerImgView = [FControlTool createImageView];
        bannerImgView.frame = CGRectMake(16, 10, kScreenWidth - 32, 193);
        bannerImgView.image = [UIImage imageNamed:@"top_banner"];
        [bannerImgView setRoundedCorner:10];
        [self addSubview:bannerImgView];
        
        UIImageView *midImgView = [FControlTool createImageView];
        midImgView.frame = CGRectMake(16, bannerImgView.bottom+17, kScreenWidth - 32, 86);
        midImgView.layer.masksToBounds = YES;
        midImgView.image = [UIImage imageNamed:@"img_bonus"];
        [self addSubview:midImgView];
        
        UILabel *vipLabel = [FControlTool createLabel:@"会员专区" textColor:RGBColor(0x333333) font:[UIFont boldFontWithSize:20]];
        vipLabel.frame = CGRectMake(16, midImgView.bottom+15, kScreenWidth - 32, 28);
        [self addSubview:vipLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
