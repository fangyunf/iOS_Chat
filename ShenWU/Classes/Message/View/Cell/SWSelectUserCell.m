//
//  SWSelectUserCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/23.
//

#import "SWSelectUserCell.h"

@interface SWSelectUserCell ()

@end

@implementation SWSelectUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_unselect"] target:self sel:@selector(selectBtnAction)];
        self.selectBtn.frame = CGRectMake(kScreenWidth - 25 - 36, 20, 25, 25);
        [self.selectBtn setImage:[UIImage imageNamed:@"icn_selected"] forState:UIControlStateSelected];
        [self.selectBtn setImage:[UIImage imageNamed:@"icn_selected"] forState:UIControlStateDisabled];
        [self.contentView addSubview:self.selectBtn];
        
        
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake(15, 14, 36, 36);
        self.avatarImgView.layer.cornerRadius = 3;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.avatarImgView];
        
        self.nameLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x333333) font:[UIFont fontWithSize:15]];
        self.nameLabel.frame = CGRectMake(self.avatarImgView.right+16, 0, kScreenWidth - (self.avatarImgView.right+46), 64);
        [self.contentView addSubview:self.nameLabel];
        
        self.prohibitBtn = [FControlTool createButton:@"禁止" font:[UIFont fontWithSize:14] textColor:UIColor.whiteColor target:self sel:@selector(prohibitBtnAction)];
        self.prohibitBtn.frame = CGRectMake(kScreenWidth - 58-16, 17, 58, 26);
        self.prohibitBtn.backgroundColor = kMainColor;
        [self.prohibitBtn setTitleColor:RGBColor(0x999999) forState:UIControlStateSelected];
        [self.prohibitBtn setTitle:@"禁领中" forState:UIControlStateSelected];
        self.prohibitBtn.layer.cornerRadius = 4;
        self.prohibitBtn.layer.masksToBounds = YES;
        self.prohibitBtn.hidden = YES;
        [self.contentView addSubview:self.prohibitBtn];
    }
    return self;
}

- (void)selectBtnAction{
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectFriend:)]) {
        [self.delegate selectFriend:self];
    }
}

- (void)prohibitBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(prohibitFriend:)]) {
        [self.delegate prohibitFriend:self];
    }
}

- (void)setIsProhibit:(BOOL)isProhibit{
    _isProhibit = isProhibit;
    self.prohibitBtn.selected = isProhibit;
    if (self.prohibitBtn.selected) {
        self.prohibitBtn.backgroundColor = RGBColor(0xF2F2F2);
    }else{
        self.prohibitBtn.backgroundColor = kMainColor;
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
