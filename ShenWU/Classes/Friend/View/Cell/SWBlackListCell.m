//
//  SWBlackListCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWBlackListCell.h"
#import "SWAddFriendViewController.h"
@interface SWBlackListCell ()
{
    NIMUser *_user;
    FFriendModel *_model;
}
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;


@end

@implementation SWBlackListCell

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
        
        self.removeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"btn_remove_black"] target:self sel:@selector(removeBtnAction)];
        self.removeBtn.frame = CGRectMake(kScreenWidth - 50, 17, 40, 30);
        [self.contentView addSubview:self.removeBtn];
        
        self.addBtn = [FControlTool createButton:@"添加" font:[UIFont boldFontWithSize:15] textColor:UIColor.whiteColor target:self sel:@selector(addBtnAction)];
        self.addBtn.frame = CGRectMake(kScreenWidth - 72, 19, 60, 27);
        self.addBtn.backgroundColor = kMainColor;
        self.addBtn.layer.cornerRadius = 12;
        self.addBtn.layer.masksToBounds = YES;
        self.addBtn.hidden = YES;
        [self.contentView addSubview:self.addBtn];
    }
    return self;
}

- (void)removeBtnAction{
    if(self.isGroup){
        if (self.removeBlackBlock) {
            self.removeBlackBlock();
        }
        return;
    }
    @weakify(self)
    [[NIMSDK sharedSDK].userManager removeFromBlackBlackList:_user.userId completion:^(NSError * _Nullable error) {
        if (!error) {
            [[FUserRelationManager sharedManager] reloadAllFriendsData:nil];
            if (weak_self.removeBlackBlock) {
                weak_self.removeBlackBlock();
            }
        }else{
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

- (void)addBtnAction{
    SWAddFriendViewController *vc = [[SWAddFriendViewController alloc] init];
    vc.model = _model;
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)refreshCellWithModel:(FFriendModel*)model{
    _model = model;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    self.nameLabel.text = model.name;
}

- (void)refreshCellWithData:(NIMUser*)model{
//    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
//    if (model.friendRemark.length > 0) {
//        self.nameLabel.text = model.friendRemark;
//    }else{
//        self.nameLabel.text = model.name;
//    }
    _user = model;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    if (model.alias.length > 0) {
        self.nameLabel.text = model.alias;
    }else{
        self.nameLabel.text = model.userInfo.nickName;
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
