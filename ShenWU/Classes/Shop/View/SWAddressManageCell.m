//
//  SWAddressManageCell.m
//  ShenWU
//
//  Created by Amy on 2024/11/8.
//

#import "SWAddressManageCell.h"

@interface SWAddressManageCell ()
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UILabel *namePhoneLabel;
@property(nonatomic, strong) UILabel *addresLabel;
@property(nonatomic, strong) UIButton *defaultBtn;
@property(nonatomic, strong) UIButton *editBtn;
@end

@implementation SWAddressManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(0, 0, kScreenWidth, 130);
        self.bgView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.bgView];
        
        self.namePhoneLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:12]];
        self.namePhoneLabel.frame = CGRectMake(16, 22, kScreenWidth, 12);
        [self.bgView addSubview:self.namePhoneLabel];
        
        self.addresLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:12]];
        self.addresLabel.frame = CGRectMake(16, self.namePhoneLabel.bottom+10, kScreenWidth - 82, 12);
        [self.bgView addSubview:self.addresLabel];
        
        UIImageView *lineImgView = [FControlTool createImageView];
        lineImgView.frame = CGRectMake(16, 80, kScreenWidth - 32, 1);
        lineImgView.image = [UIImage imageNamed:@"icn_address_line"];
        [self.bgView addSubview:lineImgView];
        
        self.defaultBtn = [FControlTool createButton:@"默认地址" font:[UIFont fontWithSize:12] textColor:RGBColor(0x999999) target:self sel:@selector(defaultBtnAction)];
        self.defaultBtn.frame = CGRectMake(16, lineImgView.bottom+22, 100, 18);
        [self.defaultBtn setImage:[UIImage imageNamed:@"icn_address_unselect"] forState:UIControlStateNormal];
        [self.defaultBtn setImage:[UIImage imageNamed:@"icn_address_select"] forState:UIControlStateSelected];
        [self.defaultBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:7];
        self.defaultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.bgView addSubview:self.defaultBtn];
        
        self.editBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_address_edit"] target:self sel:@selector(editBtnAction)];
        self.editBtn.frame = CGRectMake(kScreenWidth - 35, 30, 20, 20);
        [self.bgView addSubview:self.editBtn];
        
        UIButton *deleteBtn = [FControlTool createButton:@"删除" font:[UIFont fontWithSize:13] textColor:RGBColor(0x999999) target:self sel:@selector(deleteBtnAction)];
        deleteBtn.frame = CGRectMake(kScreenWidth - 65, lineImgView.bottom+22, 50, 18);
        deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.bgView addSubview:deleteBtn];
    }
    return self;
}

- (void)refreshCellWithData:(SWAddressModel*)data{
    self.namePhoneLabel.text = [NSString stringWithFormat:@"%@  %@",data.name,data.phone];
    self.addresLabel.text = data.address;
    self.defaultBtn.selected = data.isDefault;
}

- (void)defaultBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(defaultAddress:)]) {
        [self.delegate defaultAddress:self];
    }
}

- (void)editBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editAddress:)]) {
        [self.delegate editAddress:self];
    }
}

- (void)deleteBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteAddress:)]) {
        [self.delegate deleteAddress:self];
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
