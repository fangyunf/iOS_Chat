//
//  SWGroupMemberInfoViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/27.
//

#import "SWGroupMemberInfoViewController.h"
#import "SWMessageDetaillViewController.h"
#import "SWAddFriendViewController.h"
#import "SWFriendInfoCell.h"
#import "SWEditNameView.h"
@interface SWGroupMemberInfoViewController ()<UITableViewDelegate,UITableViewDataSource,SWFriendInfoCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIImageView *bgImgView;
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UIButton *idBtn;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *idLabel;
@property(nonatomic, strong) UIButton *sureBtn;
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, assign) BOOL isTop;
@property(nonatomic, assign) BOOL isMute;

@end

@implementation SWGroupMemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImgView = [[UIImageView alloc] init];
    self.bgImgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    self.bgImgView.image = [UIImage imageNamed:@"bg_mine"];
    self.bgImgView.backgroundColor = RGBColor(0xf2f2f2);
    self.bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImgView.layer.masksToBounds = YES;
    [self.view addSubview:self.bgImgView];
    
    self.title = @"详细信息";
    
    self.view.backgroundColor = RGBColor(0xf2f2f2);
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    bgImgView.image = [UIImage imageNamed:@"bg_mine"];
    bgImgView.backgroundColor = RGBColor(0xF2F2F2);
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.layer.masksToBounds = YES;
    [self.view addSubview:bgImgView];
    
    UIView *infoBgView = [[UIView alloc] init];
    infoBgView.frame = CGRectMake(0, 0, kScreenWidth, 97+kTopHeight);
    infoBgView.backgroundColor = [UIColor whiteColor];
    infoBgView.layer.cornerRadius = 5;
    infoBgView.layer.masksToBounds = YES;
    [self.view addSubview:infoBgView];
    
    self.avatarImgView = [[UIImageView alloc] init];
    self.avatarImgView.frame = CGRectMake(25, kTopHeight, 80, 80);
    self.avatarImgView.layer.cornerRadius = 6;
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImgView.userInteractionEnabled = YES;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    [infoBgView addSubview:self.avatarImgView];
    
    CGSize size = [self.userInfoModel.name sizeForFont:[UIFont boldFontWithSize:18] size:CGSizeMake(infoBgView.width - 102, 20) mode:NSLineBreakByWordWrapping];
    
    self.nameLabel = [FControlTool createLabel:self.userInfoModel.name textColor:UIColor.blackColor font:[UIFont boldFontWithSize:18]];
    self.nameLabel.frame = CGRectMake(self.avatarImgView.right+10, kTopHeight, size.width, 80);
    [infoBgView addSubview:self.nameLabel];
    
    
//    CGSize idSize = [[NSString stringWithFormat:@"ID:%@",self.userInfoModel.memberCode] sizeForFont:[UIFont fontWithSize:12] size:CGSizeMake(infoBgView.width - 102, 15) mode:NSLineBreakByWordWrapping];
//    
//    self.idBtn = [[UIButton alloc] init];
//    self.idBtn.frame = CGRectMake(16, self.nameLabel.bottom+5, idSize.width+16+40, 15);
//    [self.idBtn addTarget:self action:@selector(copyBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [infoBgView addSubview:self.idBtn];
//    
//    self.idLabel = [FControlTool createLabel:[NSString stringWithFormat:@"ID:%@",self.userInfoModel.memberCode] textColor:RGBColor(0x666666) font:[UIFont fontWithSize:12]];
//    self.idLabel.frame = CGRectMake(0, 0, idSize.width, 15);
//    self.idLabel.layer.masksToBounds = YES;
//    self.idLabel.textAlignment = NSTextAlignmentCenter;
//    [self.idBtn addSubview:self.idLabel];
//    
//    UIButton *copyBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_mine_copy"] target:self sel:@selector(copyBtnAction)];
//    copyBtn.frame = CGRectMake(idSize.width+16, 0.5, 13, 14);
//    [self.idBtn addSubview:copyBtn];
    
    NIMSession *session = [NIMSession session:self.userInfoModel.userId type:NIMSessionTypeP2P];
    NIMStickTopSessionInfo *info = [NIMSDK.sharedSDK.chatExtendManager stickTopInfoForSession:session];
    if (info) {
        self.isTop = YES;
    }
    
    self.isMute = ![[NIMSDK sharedSDK].userManager notifyForNewMsg:self.userInfoModel.userId];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, infoBgView.bottom+13, kScreenWidth, kScreenHeight - (infoBgView.bottom+13));
    self.bgView.layer.cornerRadius = 10;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.masksToBounds = YES;
    [self.view addSubview:self.bgView];
    
    [self.tableView reloadData];
    
    
    self.sureBtn = [FControlTool createCommonButton:@"发消息" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 120, 52) target:self sel:@selector(sureBtnAction)];
    self.sureBtn.frame = CGRectMake(60, kScreenHeight - 144, kScreenWidth - 120, 52);
    self.sureBtn.backgroundColor = kMainColor;
    self.sureBtn.layer.cornerRadius = 26;
    self.sureBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.sureBtn];
    
    self.sureBtn.hidden = YES;
    
    if (self.type == GroupClickMemberTypeHost || self.type == GroupClickMemberTypeHostFriend) {
        UIButton *kickOutBtn = [FControlTool createButton:@"踢出群聊" font:[UIFont boldFontWithSize:15] textColor:UIColor.blackColor target:self sel:@selector(kickOutBtnAction)];
        kickOutBtn.frame = CGRectMake(60, self.sureBtn.bottom+10, kScreenWidth - 120, 24);
        [self.view addSubview:kickOutBtn];
    }
    switch (self.type) {
        case GroupClickMemberTypeHost:
            self.dataList = @[@"邀请人",@"禁止领取红包",@"加入群黑名单"];
            self.sureBtn.hidden = NO;
            [self.sureBtn setTitle:@"加好友" forState:UIControlStateNormal];
            
            break;
        case GroupClickMemberTypeHostFriend:
            self.dataList = @[@"消息免打扰",@"置顶聊天",@"加入群黑名单",@"邀请人",@"禁止领取红包"];
            self.sureBtn.hidden = NO;
            [self.sureBtn setTitle:@"发消息" forState:UIControlStateNormal];
            break;
        case GroupClickMemberTypeNormal:
            self.idLabel.hidden = YES;
            [self requestGroupManageData];
            break;
        case GroupClickMemberTypeNormalFriend:
        {
            self.dataList = @[@"消息免打扰",@"置顶聊天"];
            self.idLabel.hidden = YES;
            self.sureBtn.hidden = NO;
            [self.sureBtn setTitle:@"发消息" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    self.bgView.frame = CGRectMake(0, infoBgView.bottom+13, kScreenWidth, self.dataList.count*44+30);
    
    
}

- (void)requestGroupManageData{
    NSDictionary *params = @{@"groupId":self.groupModel.groupId};
    @weakify(self)
    [[FNetworkManager sharedManager] getRequestFromServer:@"/group/groupManage" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            FGroupModel *model = [FGroupModel modelWithDictionary:response[@"data"]];
            weak_self.groupModel.inviteState = model.inviteState;
            weak_self.groupModel.addFriendsState = model.addFriendsState;
            weak_self.groupModel.shutupState = model.shutupState;
            weak_self.groupModel.nonCollectionState = model.nonCollectionState;
            if (weak_self.groupModel.addFriendsState) {
                weak_self.sureBtn.hidden = NO;
                [weak_self.sureBtn setTitle:@"加好友" forState:UIControlStateNormal];
            }else{
                weak_self.sureBtn.hidden = YES;
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)copyBtnAction{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.userInfoModel.memberCode];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (void)sureBtnAction{
    if(self.type == GroupClickMemberTypeHostFriend || self.type == GroupClickMemberTypeNormalFriend){
        SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
        vc.type = NIMSessionTypeP2P;
        vc.sessionId = self.userInfoModel.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        FFriendModel *model = [FFriendModel modelWithDictionary:self.userInfoModel.modelToJSONObject];
        SWAddFriendViewController *vc = [[SWAddFriendViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)kickOutBtnAction{
    NSDictionary *params = @{@"members":@[self.userInfoModel.userId], @"groupId":self.groupModel.groupId};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/outGroup" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"移出成功"];
            if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(reloadGroupMember)]) {
                [weak_self.delegate reloadGroupMember];
            }
            [weak_self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - SWFriendInfoCellDelegate
- (void)switchHandleAction:(SWFriendInfoCell *)cell{
    [SVProgressHUD show];
    if ([cell.titleLabel.text isEqualToString:@"置顶聊天"]) {
        NIMSession *session = [NIMSession session:self.userInfoModel.userId type:NIMSessionTypeP2P];
        if (cell.switchBtn.selected) {
            NIMStickTopSessionInfo *info = [NIMSDK.sharedSDK.chatExtendManager stickTopInfoForSession:session];
            [[NIMSDK sharedSDK].chatExtendManager removeStickTopSession:info completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable removedInfo) {
                if (!error) {
                    [cell.switchBtn setSelected:!cell.switchBtn.selected];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                }
            }];
        }else{
            
            NIMAddStickTopSessionParams *params = [[NIMAddStickTopSessionParams alloc] initWithSession:session];
            [[NIMSDK sharedSDK].chatExtendManager addStickTopSession:params completion:^(NSError * _Nullable error, NIMStickTopSessionInfo * _Nullable newInfo) {
                if (!error) {
                    [cell.switchBtn setSelected:!cell.switchBtn.selected];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                }
            }];
        }
    }else if ([cell.titleLabel.text isEqualToString:@"消息免打扰"]) {
        [[NIMSDK sharedSDK].userManager updateNotifyState:cell.switchBtn.selected forUser:self.userInfoModel.userId completion:^(NSError * _Nullable error) {
            if (!error) {
                [cell.switchBtn setSelected:!cell.switchBtn.selected];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
        }];
    }else if ([cell.titleLabel.text isEqualToString:@"加入群黑名单"]) {
        if (!cell.switchBtn.selected) {
            NSDictionary *params = @{@"userId":self.userInfoModel.userId, @"groupId":self.groupModel.groupId};
            @weakify(self)
            [SVProgressHUD show];
            [[FNetworkManager sharedManager] postRequestFromServer:@"/group/addDeleteBlack" parameters:params success:^(NSDictionary * _Nonnull response) {
                if ([response[@"code"] integerValue] == 200) {
                    [cell.switchBtn setSelected:!cell.switchBtn.selected];
                    [weak_self kickoutGroup];
                }else{
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
                
            } failure:^(NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
        }else{
            
        }
    }else if ([cell.titleLabel.text isEqualToString:@"禁止领取红包"]) {
        NSDictionary *params = @{@"members":@[self.userInfoModel.userId], @"groupId":self.groupModel.groupId,@"state":@(!self.userInfoModel.forbidState)};
        @weakify(self)
        [SVProgressHUD show];
        [[FNetworkManager sharedManager] postRequestFromServer:@"/groupMember/invitationGroupBanOnLooting" parameters:params success:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue] == 200) {
                [cell.switchBtn setSelected:!cell.switchBtn.selected];
                weak_self.userInfoModel.forbidState = !weak_self.userInfoModel.forbidState;
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

- (void)kickoutGroup{
    NSDictionary *params = @{@"members":@[self.userInfoModel.userId], @"groupId":self.groupModel.groupId};
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/outGroup" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            NSMutableArray *list = [[NSMutableArray alloc] initWithArray:weak_self.groupModel.members];
            for (NSInteger i=list.count - 1; i>=0; i--) {
                FGroupUserInfoModel *infoModel = [list objectAtIndex:i];
                if ([infoModel.userId isEqualToString:self.userInfoModel.userId]) {
                    [list removeObjectAtIndex:i];
                    break;
                }
            }
            weak_self.groupModel.members = list;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMembers" object:nil];
            [weak_self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWFriendInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWFriendInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    cell.arrowImgView.hidden = YES;
    cell.switchBtn.hidden = YES;
    cell.detailLabel.hidden = YES;
    cell.titleLabel.textColor = UIColor.blackColor;
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.row];
    if ([cell.titleLabel.text isEqualToString:@"置顶聊天"]) {
        cell.switchBtn.hidden = NO;
        cell.switchBtn.selected = self.isTop;
    }else if ([cell.titleLabel.text isEqualToString:@"消息免打扰"]) {
        cell.switchBtn.hidden = NO;
        cell.switchBtn.selected = self.isMute;
    }else if ([cell.titleLabel.text isEqualToString:@"加入群黑名单"]) {
        cell.switchBtn.hidden = NO;
    }else if ([cell.titleLabel.text isEqualToString:@"禁止领取红包"]) {
        cell.switchBtn.hidden = NO;
        cell.switchBtn.selected = self.userInfoModel.forbidState;
    }else if ([cell.titleLabel.text isEqualToString:@"备注"]) {
        cell.detailLabel.hidden = NO;
        cell.detailLabel.text = self.userInfoModel.remark;
        cell.arrowImgView.hidden = NO;
    }else if ([cell.titleLabel.text isEqualToString:@"邀请人"]) {
        cell.detailLabel.hidden = NO;
        cell.detailLabel.text = [NSString stringWithFormat:@"%@ ID:%@",self.userInfoModel.inviteName,self.userInfoModel.inviteMemberCode];
        cell.arrowImgView.hidden = NO;
    }else{
        cell.arrowImgView.hidden = NO;
        if([cell.titleLabel.text isEqualToString:@"删除好友"]){
            cell.titleLabel.textColor = RGBColor(0xFF0000);
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWFriendInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.titleLabel.text isEqualToString:@"备注"]) {
        SWEditNameView *view = [[SWEditNameView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        view.titleLabel.text = @"编辑备注";
        [[FControlTool keyWindow] addSubview:view];
        [view show];
        @weakify(self)
        view.saveName = ^(NSString * _Nonnull name) {
            [weak_self saveRemark:name];
        };
    }
}

- (void)saveRemark:(NSString *)name{
    [SVProgressHUD show];
    @weakify(self)
    NSDictionary *params = @{@"memberCode":self.userInfoModel.memberCode,@"alias":name};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/updateRemark" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.userInfoModel.remark = name;
            [[FUserRelationManager sharedManager] updateFriendRemark:self.userInfoModel.userId remark:name];
            [SVProgressHUD dismiss];
            [weak_self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bgView.top+15, kScreenWidth, kScreenHeight - (self.bgView.top+15)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
