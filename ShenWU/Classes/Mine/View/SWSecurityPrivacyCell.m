//
//  SWSecurityPrivacyCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/23.
//

#import "SWSecurityPrivacyCell.h"

@interface SWSecurityPrivacyCell ()

@end

@implementation SWSecurityPrivacyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.icnImgView = [[UIImageView alloc] init];
        self.icnImgView.frame = CGRectMake(10, 12.5, 17, 19);
        self.icnImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.icnImgView.hidden = YES;
        [self.contentView addSubview:self.icnImgView];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:16]];
        self.titleLabel.frame = CGRectMake(12, 0, kScreenWidth-72, 44);
        [self.contentView addSubview:self.titleLabel];
        
        self.switchBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_off"] target:self sel:@selector(switchBtnAction)];
        self.switchBtn.frame = CGRectMake(kScreenWidth - 30 - 55, 12, 34, 20);
        [self.switchBtn setImage:[UIImage imageNamed:@"icn_on"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.switchBtn];
        
        self.detailLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x999999) font:[UIFont boldFontWithSize:12]];
        self.detailLabel.frame = CGRectMake(50, 0, kScreenWidth - 80 - 41, 44);
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.detailLabel];
        
        self.arrowImgView = [[UIImageView alloc] init];
        self.arrowImgView.frame = CGRectMake(kScreenWidth - 30 - 36, 16, 21, 20);
        self.arrowImgView.image = [UIImage imageNamed:@"icn_setting_arrow"];
        [self.contentView addSubview:self.arrowImgView];
        
    }
    return self;
}

- (void)switchBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchHandleAction:)]) {
        [self.delegate switchHandleAction:self];
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
