//
//  FSwitchAccountCell.m
//  Fiesta
//
//  Created by Amy on 2024/5/28.
//

#import "FSwitchAccountCell.h"

@interface FSwitchAccountCell ()

@end

@implementation FSwitchAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(16, 12, kScreenWidth - 32, 88);
        self.bgView.backgroundColor = RGBColor(0xf6f6f6);
        [self.bgView rounded:28];
        [self.contentView addSubview:self.bgView];
        
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake(24, 27, 34, 34);
        self.avatarImgView.layer.cornerRadius = 17;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImgView.image = [UIImage imageNamed:@"avatar_person"];
        [self.bgView addSubview:self.avatarImgView];
        
        self.nameLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
        self.nameLabel.frame = CGRectMake(self.avatarImgView.right+15, 23, kScreenWidth - (self.avatarImgView.right+102), 17);
        [self.bgView addSubview:self.nameLabel];
        
        self.idLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
        self.idLabel.frame = CGRectMake(self.avatarImgView.right+15, 46, self.nameLabel.width, 22);
        [self.bgView addSubview:self.idLabel];
        
        self.tagLabel = [FControlTool createLabel:@"当前账号" textColor:kMainColor font:[UIFont fontWithSize:14]];
        self.tagLabel.frame = CGRectMake(self.bgView.width - 80, 33, 64, 22);
        [self.bgView addSubview:self.tagLabel];
        
        self.deleteBtn = [FControlTool createButton:@"删除" font:[UIFont fontWithSize:12] textColor:UIColor.whiteColor target:self sel:@selector(deleteBtnAction)];
        self.deleteBtn.frame = CGRectMake(kScreenWidth - 32 - 60, 31, 44, 26);
        self.deleteBtn.backgroundColor = kMainColor;
        self.deleteBtn.layer.cornerRadius = 4;
        self.deleteBtn.layer.masksToBounds = YES;
        [self.bgView addSubview:self.deleteBtn];
        
        self.titleLabel = [FControlTool createLabel:@"添加新账号" textColor:UIColor.blackColor font:[UIFont fontWithSize:16]];
        self.titleLabel.frame = CGRectMake(self.avatarImgView.right+12, 33, kScreenWidth - (self.avatarImgView.right+102), 22);
        [self.bgView addSubview:self.titleLabel];
    }
    return self;
}

- (void)deleteBtnAction{
    if (self.deleteBlock) {
        self.deleteBlock(self.tag);
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
