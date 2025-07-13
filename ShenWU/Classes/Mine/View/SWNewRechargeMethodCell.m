//
//  SWNewRechargeMethodCell.m
//  ShenWU
//
//  Created by Amy on 2025/2/12.
//

#import "SWNewRechargeMethodCell.h"

@implementation SWNewRechargeMethodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icnImgView = [FControlTool createImageView];
        self.icnImgView.frame = CGRectMake(12, 18, 20, 20);
        [self.contentView addSubview:self.icnImgView];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
        self.titleLabel.frame = CGRectMake(self.icnImgView.right+10, 18, kScreenWidth/2, 20);
        [self.contentView addSubview:self.titleLabel];
        
        self.selectImgView = [FControlTool createImageView];
        self.selectImgView.frame = CGRectMake(kScreenWidth - 30 - 38, 18, 20, 20);
        self.selectImgView.image = [UIImage imageNamed:@"icn_recharge_unselect"];
        [self.contentView addSubview:self.selectImgView];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.selectImgView.image = [UIImage imageNamed:@"icn_recharge_selected"];
    }else{
        self.selectImgView.image = [UIImage imageNamed:@"icn_recharge_unselect"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
