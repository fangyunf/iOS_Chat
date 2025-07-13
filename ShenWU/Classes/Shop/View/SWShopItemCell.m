//
//  SWShopItemCell.m
//  ShenWU
//
//  Created by Amy on 2024/10/19.
//

#import "SWShopItemCell.h"

@interface SWShopItemCell ()
@property(nonatomic, strong) UIImageView *icnImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@end

@implementation SWShopItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, (kScreenWidth - 40)/2, 258);
        [bgView setRoundedCorner:15];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        self.icnImgView = [FControlTool createImageView];
        self.icnImgView.frame = CGRectMake(0, 0, bgView.width, 180);
        [self.icnImgView setRoundedCorner:15];
        [bgView addSubview:self.icnImgView];
        
        self.nameLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x333333) font:[UIFont boldFontWithSize:14]];
        self.nameLabel.frame = CGRectMake(8, self.icnImgView.bottom+11, bgView.width-16, 17);
        [bgView addSubview:self.nameLabel];
        
        self.priceLabel = [FControlTool createLabel:@"" textColor:RGBColor(0xFB4700) font:[UIFont boldFontWithSize:16]];
        self.priceLabel.frame = CGRectMake(8, self.nameLabel.bottom+11, bgView.width-26, 20);
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:self.priceLabel];
    }
    return self;
}

- (void)refreshCellWithData:(NSDictionary*)data{
    [self.icnImgView sd_setImageWithURL:[NSURL URLWithString:data[@"image"]]];
    self.nameLabel.text = data[@"name"];
    self.priceLabel.text = data[@"price"];
}

@end
