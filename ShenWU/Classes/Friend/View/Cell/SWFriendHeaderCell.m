//
//  SWFriendHeaderCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWFriendHeaderCell.h"

@implementation SWFriendHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icnImgView = [[UIImageView alloc] init];
        self.icnImgView.frame = CGRectMake(12, 14, 32, 32);
        self.icnImgView.layer.cornerRadius = 3;
        self.icnImgView.layer.masksToBounds = YES;
        self.icnImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.icnImgView];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x333333) font:[UIFont fontWithSize:15]];
        self.titleLabel.frame = CGRectMake(self.icnImgView.right+10, 0, kScreenWidth - (self.icnImgView.right+40), 60);
        [self.contentView addSubview:self.titleLabel];
        
        self.numberLabel = [FControlTool createLabel:@"" textColor:UIColor.whiteColor font:[UIFont fontWithSize:10]];
        self.numberLabel.frame = CGRectMake(kScreenWidth - 46, 20, 20, 20);
        self.numberLabel.backgroundColor = RGBColor(0xFD2635);
        self.numberLabel.layer.cornerRadius = 10;
        self.numberLabel.layer.masksToBounds = YES;
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.numberLabel];
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
