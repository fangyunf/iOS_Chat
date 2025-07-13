//
//  FContactPersonCell.m
//  Fiesta
//
//  Created by Amy on 2024/5/23.
//

#import "FContactPersonCell.h"

@interface FContactPersonCell ()

@end

@implementation FContactPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake(14, 10, 42, 42);
        self.avatarImgView.layer.cornerRadius = 3;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImgView.image = [UIImage imageNamed:@"avatar_person"];
        [self.contentView addSubview:self.avatarImgView];
        
        self.numLabel = [FControlTool createLabel:@"99+" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:10]];
        self.numLabel.frame = CGRectMake(46, 6, 22, 16);
        self.numLabel.layer.cornerRadius = 8;
        self.numLabel.layer.masksToBounds = YES;
        self.numLabel.hidden = YES;
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.backgroundColor = RGBColor(0xFF0000);
        [self.contentView addSubview:self.numLabel];
        
        self.nameLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:16]];
        self.nameLabel.frame = CGRectMake(self.avatarImgView.right+8, 8, kScreenWidth - (self.avatarImgView.right+38), 44);
        [self.contentView addSubview:self.nameLabel];
        
        self.selectBtn = [[UIButton alloc] init];
        self.selectBtn.frame = CGRectMake(kScreenWidth - 38, 21, 18, 18);
        [self.selectBtn setImage:[UIImage imageNamed:@"login_unselect"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"login_select"] forState:UIControlStateSelected];
        [self.selectBtn setImage:[UIImage imageNamed:@"login_select"] forState:UIControlStateDisabled];
        self.selectBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.selectBtn addTarget:self action:@selector(selectBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.selectBtn.hidden = YES;
        [self.contentView addSubview:self.selectBtn];
        
        self.prohibitBtn = [FControlTool createButton:@"禁止" font:[UIFont fontWithSize:14] textColor:UIColor.whiteColor target:self sel:@selector(prohibitBtnAction)];
        self.prohibitBtn.frame = CGRectMake(kScreenWidth - 58-16, 17, 58, 26);
        self.prohibitBtn.backgroundColor = RGBColor(0xB591F5);
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
        self.prohibitBtn.backgroundColor = RGBColor(0xB591F5);
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
