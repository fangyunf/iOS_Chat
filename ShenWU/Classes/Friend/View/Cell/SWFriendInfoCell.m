//
//  SWFriendInfoCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/27.
//

#import "SWFriendInfoCell.h"

@implementation SWFriendInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:16]];
        self.titleLabel.frame = CGRectMake(25, 0, kScreenWidth-72, 50);
        [self.contentView addSubview:self.titleLabel];
        
        self.switchBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_off"] target:self sel:@selector(switchBtnAction)];
        self.switchBtn.frame = CGRectMake(kScreenWidth - 40 - 15, 17, 34, 20);
        [self.switchBtn setImage:[UIImage imageNamed:@"icn_on"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.switchBtn];
        
        self.detailLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x999999) font:[UIFont boldFontWithSize:12]];
        self.detailLabel.frame = CGRectMake(50, 0, kScreenWidth - 46 -50, 50);
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.detailLabel];
        
        self.arrowImgView = [[UIImageView alloc] init];
        self.arrowImgView.frame = CGRectMake(kScreenWidth - 46, 19, 21, 20);
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
