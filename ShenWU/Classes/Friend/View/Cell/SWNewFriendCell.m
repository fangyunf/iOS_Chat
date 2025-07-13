//
//  SWNewFriendCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWNewFriendCell.h"
#import "SWFriendVerifyViewController.h"
#import "SWGroupVerifyViewController.h"
@interface SWNewFriendCell ()<SWFriendVerifyViewControllerDelegate,SWGroupVerifyViewControllerDelegate>
{
    
}
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *infoLabel;
@property(nonatomic, strong) UILabel *inviteLabel;
@property(nonatomic, strong) FFriendApplyModel *model;
@property(nonatomic, strong) FApplyGroupModel *groupModel;
@end

@implementation SWNewFriendCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake(14, 5, 43, 43);
        self.avatarImgView.layer.cornerRadius = 3;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImgView.image = [UIImage imageNamed:@"avatar_person"];
        [self.contentView addSubview:self.avatarImgView];
        
        self.nameLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
        self.nameLabel.frame = CGRectMake(self.avatarImgView.right+5, 7, kScreenWidth - (self.avatarImgView.right+92), 19);
        [self.contentView addSubview:self.nameLabel];
        
        self.infoLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x959595) font:[UIFont fontWithSize:12]];
        self.infoLabel.frame = CGRectMake(self.avatarImgView.right+5, self.nameLabel.bottom+5, kScreenWidth - (self.avatarImgView.right+92), 15);
        [self.contentView addSubview:self.infoLabel];
        
        self.inviteLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:12]];
        self.inviteLabel.frame = CGRectMake(self.avatarImgView.right+5, self.infoLabel.bottom+5, kScreenWidth - (self.avatarImgView.right+92), 15);
        self.inviteLabel.hidden = YES;
        [self.contentView addSubview:self.inviteLabel];
        
        self.lookBtn = [FControlTool createButton:@"查看" font:[UIFont boldFontWithSize:13] textColor:UIColor.whiteColor target:self sel:@selector(lookBtnAction)];
        self.lookBtn.frame = CGRectMake(kScreenWidth - 74, 15, 47, 23);
        self.lookBtn.backgroundColor = RGBColor(0x04C15E);
        self.lookBtn.layer.cornerRadius = 3;
        self.lookBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.lookBtn];
        
        self.statusLabel = [FControlTool createLabel:@"已同意" textColor:UIColor.blackColor font:[UIFont fontWithSize:13]];
        self.statusLabel.frame = CGRectMake(kScreenWidth - 74, 15, 47, 23);
        self.statusLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.statusLabel];
    }
    return self;
}

- (void)refreshCellWithData:(FFriendApplyModel*)data{
    _model = data;

    if (data.applyState == 0) {
        self.lookBtn.hidden = NO;
        self.statusLabel.hidden = YES;
    }else if(data.applyState == 1) {
        self.lookBtn.hidden = YES;
        self.statusLabel.hidden = NO;
        self.statusLabel.text = @"已添加";
        self.statusLabel.textColor = RGBColor(0xB6B6B6);
    }else if(data.applyState == 2) {
        self.lookBtn.hidden = YES;
        self.statusLabel.hidden = NO;
        self.statusLabel.text = @"已拒绝";
        self.statusLabel.textColor = RGBColor(0xB6B6B6);
    }

    self.nameLabel.text = data.name;
    
    self.infoLabel.text = data.leaveMessage;
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
}

- (void)refreshCellWithGroupData:(FApplyGroupModel *)data{
    _groupModel = data;

    if (data.applyState == 0) {
        self.lookBtn.hidden = NO;
        self.statusLabel.hidden = YES;
    }else if(data.applyState == 1) {
        self.lookBtn.hidden = YES;
        self.statusLabel.hidden = NO;
        self.statusLabel.text = @"已同意";
        self.statusLabel.textColor = RGBColor(0x8B5FD8);
    }else if(data.applyState == 2) {
        self.lookBtn.hidden = YES;
        self.statusLabel.hidden = NO;
        self.statusLabel.text = @"已拒绝";
        self.statusLabel.textColor = RGBColor(0x666666);
    }

    self.nameLabel.text = data.userName;
    
    self.infoLabel.text = [NSString stringWithFormat:@"申请加入%@",data.groupName];
    self.inviteLabel.hidden = NO;
    self.inviteLabel.text = [NSString stringWithFormat:@"邀请人：%@",data.inviteName];
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:data.userAvatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
}

- (void)lookBtnAction{
    if (self.isGroup) {
        SWGroupVerifyViewController *vc = [[SWGroupVerifyViewController alloc] init];
        vc.model = _groupModel;
        vc.delegate = self;
        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else{
        SWFriendVerifyViewController *vc = [[SWFriendVerifyViewController alloc] init];
        vc.model = _model;
        vc.delegate = self;
        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - SWFriendVerifyViewControllerDelegate
- (void)refuseApply:(SWFriendVerifyViewController *)controller{
    if (controller.model == self.model) {
        self.model.applyState = 2;
        [self refreshCellWithData:self.model];
    }
}

- (void)agreeApply:(SWFriendVerifyViewController *)controller{
    if (controller.model == self.model) {
        self.model.applyState = 1;
        [self refreshCellWithData:self.model];
    }
}

#pragma mark - SWGroupVerifyViewControllerDelegate

- (void)groupRefuseApply:(SWGroupVerifyViewController *)controller{
    if (controller.model == self.groupModel) {
        self.groupModel.applyState = 2;
        [self refreshCellWithGroupData:self.groupModel];
    }
}

- (void)groupAgreeApply:(SWGroupVerifyViewController *)controller{
    if (controller.model == self.groupModel) {
        self.groupModel.applyState = 1;
        [self refreshCellWithGroupData:self.groupModel];
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

