//
//  TKVipItemCell.m
//  ShenWU
//
//  Created by Amy on 2024/9/19.
//

#import "TKVipItemCell.h"

@interface TKVipItemCell ()
//@property(nonatomic, strong) UIImageView *bgImgView;
//@property(nonatomic, strong) UILabel *titleLabel;
//@property(nonatomic, strong) UILabel *priceLabel;
//@property(nonatomic, strong) UILabel *tipLabel;
@end

@implementation TKVipItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.bgImgView = [[UIImageView alloc] init];
//        self.bgImgView.frame = CGRectMake(0, 0, 311, 180);
//        [self.contentView addSubview:self.bgImgView];
//        
//        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont semiBoldFontWithSize:18]];
//        self.titleLabel.frame = CGRectMake(23, 20, self.bgImgView.width - 46, 21);
//        [self.bgImgView addSubview:self.titleLabel];
//        
//        self.priceLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont semiBoldFontWithSize:30]];
//        self.priceLabel.frame = CGRectMake(23, self.titleLabel.bottom+14, self.bgImgView.width - 46, 33);
//        [self.bgImgView addSubview:self.priceLabel];
        self.icnImgView = [FControlTool createImageView];
        self.icnImgView.frame = CGRectMake(0, 0, 79, 37);
        [self.contentView addSubview:self.icnImgView];
    }
    return self;
}

- (void)refreshCellWithData:(TKMemberItemModel*)data{
    self.icnImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg_vip_%ld",self.tag]];
    
//    self.titleLabel.text = [NSString stringWithFormat:@"尊贵银卡VIP%ld",self.tag];
//    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2lf",data.memberConfig.price.integerValue/100.0];
}

@end
