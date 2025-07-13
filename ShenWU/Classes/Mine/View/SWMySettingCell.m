//
//  SWMySettingCell.m
//  ShenWU
//
//  Created by Amy on 2025/2/10.
//

#import "SWMySettingCell.h"

@interface SWMySettingCell ()

@end

@implementation SWMySettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(18, 8, kScreenWidth - 36, 56);
        self.bgView.backgroundColor = RGBColor(0xF6F6F6);
        [self.bgView rounded:28];
        [self.contentView addSubview:self.bgView];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
        self.titleLabel.frame = CGRectMake(24, 0, kScreenWidth-84, 56);
        [self.bgView addSubview:self.titleLabel];
        
        self.detailLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
        self.detailLabel.frame = CGRectMake(kScreenWidth/2 - 71-8, 0, kScreenWidth/2, 56);
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:self.detailLabel];
        
        self.arrowImgView = [[UIImageView alloc] init];
        self.arrowImgView.frame = CGRectMake(kScreenWidth - 36 - 33, 18, 21, 20);
        self.arrowImgView.image = [UIImage imageNamed:@"icn_mine_arrow"];
        [self.bgView addSubview:self.arrowImgView];
        
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
