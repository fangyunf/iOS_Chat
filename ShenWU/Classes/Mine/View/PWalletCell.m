//
//  PWalletCell.m
//  ShenWU
//
//  Created by Amy on 2024/7/9.
//

#import "PWalletCell.h"

@implementation PWalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, kScreenWidth-32, 52);
        bgView.backgroundColor = UIColor.whiteColor;
        bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:bgView];
        
        self.icnImgView = [[UIImageView alloc] init];
        self.icnImgView.frame = CGRectMake(15, 18, 16, 16);
        self.icnImgView.contentMode = UIViewContentModeScaleAspectFill;
        [bgView addSubview:self.icnImgView];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x333333) font:[UIFont boldFontWithSize:14]];
        self.titleLabel.frame = CGRectMake(15, 0, bgView.width - 30, 52);
        [bgView addSubview:self.titleLabel];
        
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.frame = CGRectMake(bgView.width - 21, 20, 6, 12);
        arrowImgView.image = [UIImage imageNamed:@"icn_setting_arrow"];
        [bgView addSubview:arrowImgView];
    }
    return self;
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
