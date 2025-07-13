//
//  SWGroupInfoHeaderView.m
//  ShenWU
//
//  Created by Amy on 2024/6/24.
//

#import "SWGroupInfoHeaderView.h"
#import "SWGroupMemberViewController.h"
#import "SWQRcodeViewController.h"
#import "SWGroupMemberCell.h"
#import "SWSelectUserViewController.h"
#import "SWGroupMemberViewController.h"
#import "SWGroupMemberInfoViewController.h"
#import "SWGroupEditAlertView.h"
#import "SWGroupEditAnnouncementView.h"
#import "SWEditGroupNameViewController.h"
@interface SWGroupInfoHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource,SWSelectUserViewControllerDelegate,SWGroupMemberInfoViewControllerDelegate,SWGroupEditAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UIButton *nameBtn;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIButton *editBtn;
@property(nonatomic, strong) UIButton *idBtn;
@property(nonatomic, strong) UIButton *myCopyBtn;
@property(nonatomic, strong) UILabel *idLabel;
@property(nonatomic, strong) UIView *memberBgView;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) GroupSettingType type;
@property(nonatomic, strong) FGroupModel *model;
@property (nonatomic, strong) TeamMemberSelectVM *viewModel;
@property(nonatomic, assign) BOOL isJump;
@end

@implementation SWGroupInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame type:(GroupSettingType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *infoBgView = [[UIView alloc] init];
        infoBgView.frame = CGRectMake(0, 0, kScreenWidth-30, 62);
        infoBgView.backgroundColor = [UIColor whiteColor];
        infoBgView.layer.cornerRadius = 5;
        infoBgView.layer.masksToBounds = YES;
        [self addSubview:infoBgView];
        
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake(15, 6, 50, 50);
        self.avatarImgView.layer.cornerRadius = 4;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImgView.userInteractionEnabled = YES;
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.model.head] placeholderImage:[UIImage imageNamed:@"avatar_group"]];
        [infoBgView addSubview:self.avatarImgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editBtnAction)];
        [self.avatarImgView addGestureRecognizer:tap];
        
        self.nameLabel = [FControlTool createLabel:self.model.name textColor:UIColor.blackColor font:[UIFont boldFontWithSize:18]];
        self.nameLabel.frame = CGRectMake(self.avatarImgView.right+12, 20, infoBgView.width - (self.avatarImgView.right+27), 22);
        [infoBgView addSubview:self.nameLabel];
        
        
//        CGSize idSize = [[NSString stringWithFormat:@"ID:%@",self.model.groupId] sizeForFont:[UIFont fontWithSize:12] size:CGSizeMake(infoBgView.width - 102, 15) mode:NSLineBreakByWordWrapping];
//
//        self.idBtn = [[UIButton alloc] init];
//        self.idBtn.frame = CGRectMake(self.avatarImgView.right+10, self.nameBtn.bottom+15, idSize.width+16+40, 15);
//        [self.idBtn addTarget:self action:@selector(copyBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [infoBgView addSubview:self.idBtn];
//
//        self.idLabel = [FControlTool createLabel:[NSString stringWithFormat:@"ID:%@",self.model.groupId] textColor:RGBColor(0x666666) font:[UIFont fontWithSize:12]];
//        self.idLabel.frame = CGRectMake(0, 0, idSize.width, 15);
//        self.idLabel.layer.masksToBounds = YES;
//        self.idLabel.textAlignment = NSTextAlignmentCenter;
//        [self.idBtn addSubview:self.idLabel];
//
//        self.myCopyBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_mine_copy"] target:self sel:@selector(copyBtnAction)];
//        self.myCopyBtn.frame = CGRectMake(idSize.width+16, 0.5, 13, 14);
//        [self.idBtn addSubview:self.myCopyBtn];
        
        
        self.memberBgView = [[UIView alloc] init];
        self.memberBgView.frame = CGRectMake(0, infoBgView.bottom+11, kScreenWidth - 30, 175);
        self.memberBgView.backgroundColor = [UIColor whiteColor];
        self.memberBgView.layer.cornerRadius = 10;
        self.memberBgView.layer.masksToBounds = YES;
        [self addSubview:self.memberBgView];
        
        UILabel *memberLabel = [FControlTool createLabel:@"群聊成员" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
        memberLabel.frame = CGRectMake(7, 18, self.memberBgView.width/2, 18);
        [self.memberBgView addSubview:memberLabel];
        
        UIButton *lookMemberBtn = [FControlTool createButton:@"查看所有成员" font:[UIFont fontWithSize:14] textColor:RGBColor(0x666666) target:self sel:@selector(lookMemberBtnAction)];
        lookMemberBtn.frame = CGRectMake(self.memberBgView.width - 92, 18, 85, 18);
        [self.memberBgView addSubview:lookMemberBtn];
        
        [self.memberBgView addSubview:self.collectionView];
    }
    return self;
}

- (void)setType:(GroupSettingType)type{
    _type = type;
}

- (void)refreshViewWithData:(FGroupModel*)model{
    self.model = model;
    self.type = model.rankState;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"avatar_group"]];
    
    self.nameLabel.frame = CGRectMake(self.avatarImgView.right+12, 20, kScreenWidth - 30 - (self.avatarImgView.right+27), 22);
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%ld)",model.name,model.members.count];;
    if (self.type == GroupSettingTypeHost || self.type == GroupSettingTypeManage) {
        if (self.model.members.count <= 3) {
            self.collectionView.frame = CGRectMake(0, 54, kScreenWidth-30, 76);
            self.memberBgView.height = 54+76+12;
        }else if (self.model.members.count <= 8) {
            self.collectionView.frame = CGRectMake(0, 54, kScreenWidth-30, 76*2);
            self.memberBgView.height = 54+76*2+12;
        }else{
            self.collectionView.frame = CGRectMake(0, 54, kScreenWidth-30, 76*3);
            self.memberBgView.height = 54+76*3+12;
        }
            
    }else {
        if (self.model.members.count <= 4) {
            self.collectionView.frame = CGRectMake(0, 54, kScreenWidth-30, 76);
            self.memberBgView.height = 54+76+12;
        }else if (self.model.members.count <= 9) {
            self.collectionView.frame = CGRectMake(0, 54, kScreenWidth-30, 76*2);
            self.memberBgView.height = 54+76*2+12;
        }else{
            self.collectionView.frame = CGRectMake(0, 54, kScreenWidth-30, 76*3);
            self.memberBgView.height = 54+76*3+12;
        }
    }
    [self.collectionView reloadData];
}

- (void)announcementTapAction{
    if (self.type == GroupSettingTypeHost || self.type == GroupSettingTypeManage) {
        [self editGroupAnnouncement];
    }
}



- (void)copyBtnAction{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.model.groupId];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (void)editBtnAction{
    SWGroupEditAlertView *view = [[SWGroupEditAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.delegate = self;
    [[FControlTool keyWindow] addSubview:view];
    [view show];
}

- (void)lookMemberBtnAction{
    
    @weakify(self)
    SWGroupMemberViewController *vc = [[SWGroupMemberViewController alloc] init];
    vc.model = self.model;
    vc.reloadBlock = ^{
        if (weak_self.reloadBlock) {
            weak_self.reloadBlock();
        }
    };
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - SWSelectUserViewControllerDelegate,SWGroupMemberInfoViewControllerDelegate
- (void)reloadGroupMember{
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

#pragma mark - SWGroupEditAlertViewDelegate
- (void)editGroupName{
    @weakify(self)
    SWEditGroupNameViewController *vc = [[SWEditGroupNameViewController alloc] init];
    vc.groupModel = self.model;
    vc.saveName = ^(NSString * _Nonnull name) {
        weak_self.model.name = name;
        weak_self.nameLabel.text = name;
    };
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)editGroupAnnouncement{
    @weakify(self)
    SWGroupEditAnnouncementView *view = [[SWGroupEditAnnouncementView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.inputTextView.text = self.model.announcement;
    view.model = self.model;
    view.saveName = ^(NSString * _Nonnull name) {
        weak_self.model.announcement = name;
        weak_self.announcementDetailLabel.text = name;
    };
    [[FControlTool keyWindow] addSubview:view];
    [view show];
}

- (void)editGroupAvatar{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.delegate = self;
        vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[FControlTool getCurrentVC] presentViewController:vc animated:YES completion:nil];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.delegate = self;
        vc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[FControlTool getCurrentVC] presentViewController:vc animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];

    [alert addAction:galleryAction];
    [alert addAction:cameraAction];
    [alert addAction:cancelAction];
    [[FControlTool getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    @weakify(self);
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] uploadImgFromServer:@"/customer/upload" image:image parameters:@{@"file":[NSString stringWithFormat:@"pic_%ld.jpg", (NSInteger)[[NSDate date] timeIntervalSince1970]]} progress:^(NSProgress * progress) {
        NSLog(@"%lld_%lld",progress.completedUnitCount,progress.totalUnitCount);
    } success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            @strongify(self);
            [self saveAvatar:response[@"data"][@"url"]];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)saveAvatar:(NSString *)avatar{
    NSDictionary *params = @{@"head":avatar,@"groupId":self.model.groupId};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/updateGroupInfo" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.model.head = avatar;
            
            [weak_self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"avatar_group"]];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.type == GroupSettingTypeHost || self.type == GroupSettingTypeManage) {
        if (self.model.members.count > 12) {
            return 15;
        }else {
            return self.model.members.count + 2;
        }
            
    }else {
        if (self.model.members.count > 14) {
            return 15;
        }else {
            return self.model.members.count + 1;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWGroupMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SWGroupMemberCell class]) forIndexPath:indexPath];
    cell.nameLabel.hidden = YES;
    cell.tagLabel.hidden = YES;
    if (self.type == GroupSettingTypeHost || self.type == GroupSettingTypeManage) {
        if (self.model.members.count > 13) {
            if (indexPath.item == 14) {
                cell.avatarImgView.image = [UIImage imageNamed:@"icn_group_delete"];
                cell.avatarImgView.layer.borderWidth = 0;
                cell.nameLabel.text = @"移除";
                cell.nameLabel.hidden = NO;
            }else if (indexPath.item == 13) {
                cell.avatarImgView.image = [UIImage imageNamed:@"icn_group_add"];
                cell.avatarImgView.layer.borderWidth = 0;
                cell.nameLabel.text = @"邀请";
                cell.nameLabel.hidden = NO;
            }else{
                FGroupUserInfoModel *model = [self.model.members objectAtIndex:indexPath.item];
                [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
                cell.avatarImgView.layer.borderWidth = 1;
                cell.nameLabel.text = model.name;
                cell.nameLabel.hidden = NO;
                cell.tagLabel.hidden = NO;
                [cell refreshCellWithData:model];
            }
        }else {
            if (self.model.members.count + 1 == indexPath.item) {
                cell.avatarImgView.image = [UIImage imageNamed:@"icn_group_delete"];
                cell.avatarImgView.layer.borderWidth = 0;
                cell.nameLabel.text = @"移除";
                cell.nameLabel.hidden = NO;
            }else if (self.model.members.count == indexPath.item) {
                cell.avatarImgView.image = [UIImage imageNamed:@"icn_group_add"];
                cell.avatarImgView.layer.borderWidth = 0;
                cell.nameLabel.text = @"邀请";
                cell.nameLabel.hidden = NO;
            }else{
                FGroupUserInfoModel *model = [self.model.members objectAtIndex:indexPath.item];
                [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
                cell.avatarImgView.layer.borderWidth = 1;
                cell.nameLabel.text = model.name;
                cell.nameLabel.hidden = NO;
                cell.tagLabel.hidden = NO;
                [cell refreshCellWithData:model];
            }
        }
            
    }else {
        if (self.model.members.count > 15) {
            if (indexPath.item == 14) {
                cell.avatarImgView.image = [UIImage imageNamed:@"icn_group_add"];
                cell.avatarImgView.layer.borderWidth = 0;
                cell.nameLabel.text = @"邀请";
                cell.nameLabel.hidden = NO;
            }else{
                FGroupUserInfoModel *model = [self.model.members objectAtIndex:indexPath.item];
                [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
                cell.avatarImgView.layer.borderWidth = 1;
                cell.nameLabel.text = model.name;
                cell.nameLabel.hidden = NO;
                cell.tagLabel.hidden = NO;
                [cell refreshCellWithData:model];
            }
        }else {
            if (self.model.members.count == indexPath.item) {
                cell.avatarImgView.image = [UIImage imageNamed:@"icn_group_add"];
                cell.avatarImgView.layer.borderWidth = 0;
                cell.nameLabel.text = @"邀请";
                cell.nameLabel.hidden = NO;
            }else{
                FGroupUserInfoModel *model = [self.model.members objectAtIndex:indexPath.item];
                [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
                cell.avatarImgView.layer.borderWidth = 1;
                cell.nameLabel.text = model.name;
                cell.nameLabel.hidden = NO;
                cell.tagLabel.hidden = NO;
                [cell refreshCellWithData:model];
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == GroupSettingTypeHost || self.type == GroupSettingTypeManage) {
        if (self.model.members.count > 13) {
            if (indexPath.item == 14) {
                [self selectFriend:NO];
            }else if (indexPath.item == 13) {
                [self selectFriend:YES];
            }else{
                [[FUserRelationManager sharedManager] clickGroupMember:[self.model.members objectAtIndex:indexPath.item] group:self.model delegate:self];
            }
        }else {
            if (self.model.members.count + 1 == indexPath.item) {
                [self selectFriend:NO];
            }else if (self.model.members.count == indexPath.item) {
                [self selectFriend:YES];
            }else{
                [[FUserRelationManager sharedManager] clickGroupMember:[self.model.members objectAtIndex:indexPath.item] group:self.model delegate:self];
            }
        }
            
    }else {
        if (self.model.members.count > 15) {
            if (indexPath.item == 14) {
                [self selectFriend:YES];
            }else{
                [[FUserRelationManager sharedManager] clickGroupMember:[self.model.members objectAtIndex:indexPath.item] group:self.model delegate:self];
            }
        }else {
            if (self.model.members.count == indexPath.item) {
                [self selectFriend:YES];
            }else{
                [[FUserRelationManager sharedManager] clickGroupMember:[self.model.members objectAtIndex:indexPath.item] group:self.model delegate:self];
            }
        }
    }
}

- (void)selectFriend:(BOOL)isAdd{
    if (self.isJump) {
        return;
    }
    self.isJump = YES;
    @weakify(self)
    [self.viewModel fetchTeamMembersWithSessionId:self.model.groupId :^(NSError * _Nullable error, ChatTeamInfoModel * _Nullable team) {
        [SVProgressHUD dismiss];
        SWSelectUserViewController *vc = [[SWSelectUserViewController alloc] init];
        if (isAdd) {
            vc.type = SelectFriendTypeGroupAdd;
        }else{
            vc.type = SelectFriendTypeGroupDelete;
        }
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.model.modelToJSONObject];
        vc.groupModel = [FGroupModel modelWithDictionary:dic];
        vc.delegate = self;
        if (error) {
            NSLog(@"%@", team);
        }else {
            vc.selectData = team.users;
        }
        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        weak_self.isJump = NO;
    }];
    
    
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = (kScreenWidth - 30 - 30 - 56*5)/4;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSizeMake(56, 56);
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 54, kScreenWidth-30, 81) collectionViewLayout:layout];
        [_collectionView registerClass:[SWGroupMemberCell class] forCellWithReuseIdentifier:NSStringFromClass([SWGroupMemberCell class])];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (TeamMemberSelectVM *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TeamMemberSelectVM alloc] init];
    }
    return _viewModel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
