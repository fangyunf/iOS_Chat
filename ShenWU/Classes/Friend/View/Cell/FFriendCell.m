//
//  FFriendCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "FFriendCell.h"

@implementation FFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake(12, 14, 36, 36);
        self.avatarImgView.layer.cornerRadius = 3;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.avatarImgView];
        
        self.nameLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x333333) font:[UIFont fontWithSize:15]];
        self.nameLabel.frame = CGRectMake(self.avatarImgView.right+16, 0, kScreenWidth - (self.avatarImgView.right+46), 64);
        [self.contentView addSubview:self.nameLabel];
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
