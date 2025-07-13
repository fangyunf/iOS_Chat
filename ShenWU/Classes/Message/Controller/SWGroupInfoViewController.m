//
//  SWGroupInfoViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/24.
//

#import "SWGroupInfoViewController.h"
#import "SWGroupInfoCell.h"
#import "SWSecurityPrivacyCell.h"
#import "SWGroupManagerViewController.h"
#import "SWEditNameView.h"
#import "SWGroupEditAnnouncementView.h"
#import "SWEditGroupNameViewController.h"
#import "SWUnclaimedRedPacketViewController.h"
@interface SWGroupInfoViewController ()<UITableViewDelegate,UITableViewDataSource,SWSecurityPrivacyCellDelegate>
@property(nonatomic, strong) SWGroupInfoHeaderView *headerView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, assign) BOOL isTop;
@property(nonatomic, assign) BOOL isMute;
@property(nonatomic, strong) NSMutableArray *groupMembers;
@property(nonatomic, assign) NSInteger pageNum;
@end

@implementation SWGroupInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
//    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群聊设置";
    self.navTopView.hidden = NO;
    self.view.backgroundColor = RGBColor(0xEEEDF2);
    
//    UIImageView *bgImgView = [[UIImageView alloc] init];
//    bgImgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
////    bgImgView.image = [UIImage imageNamed:@"bg_mine"];
//    bgImgView.backgroundColor = RGBColor(0xf2f2f2);
//    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
//    bgImgView.layer.masksToBounds = YES;
//    [self.view addSubview:bgImgView];
    
    self.type = self.model.rankState;
    
    if (self.type == GroupSettingTypeHost || self.type == GroupSettingTypeManage) {
        self.navigationItem.rightBarButtonItem = [self getRightBarButtonItem:@"icn_user_right" target:self action:@selector(rightBtnAction)];
        self.dataList = @[@{@"title":@"群信息",@"list":@[@"群聊名称",@"群号",@"群公告",@"我的本群昵称"]},@{@"title":@"群管理",@"list":@[@"群管理"]},@{@"title":@"聊天会话",@"list":@[@"设为置顶",@"消息免打扰",@"删除聊天记录"]}];
    }else{
        self.dataList = @[@{@"title":@"群信息",@"list":@[@"群聊名称",@"群号",@"群公告",@"我的本群昵称"]},@{@"title":@"聊天会话",@"list":@[@"设为置顶",@"消息免打扰",@"删除聊天记录"]}];
    }
    
    
    
    NIMSession *session = [NIMSession session:self.model.groupId type:NIMSessionTypeTeam];
    NIMStickTopSessionInfo *info = [NIMSDK.sharedSDK.chatExtendManager stickTopInfoForSession:session];
    if (info) {
        self.isTop = YES;
    }
    if ([[NIMSDK sharedSDK].teamManager notifyStateForNewMsg:self.model.groupId] == NIMTeamNotifyStateNone) {
        self.isMute = YES;
    } else {
        self.isMute = NO;
    }
    
    @weakify(self)
    self.headerView = [[SWGroupInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopHeight+10+117+175+110)  type:self.type];
    [self.headerView refreshViewWithData:self.model];
    self.headerView.reloadBlock = ^{
        [weak_self requestData];
    };
    self.tableView.tableHeaderView = self.headerView;
    
    [self initFooterView];
    
    [self requestData];
    [self setHeaderFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"reloadMembers" object:nil];
}

- (void)setHeaderFrame{
    CGFloat height = 62+12;
    if (self.type == GroupSettingTypeHost || self.type == GroupSettingTypeManage) {
        if (self.model.members.count <= 3) {
            height += 54+76+12;
        }else if (self.model.members.count <= 8) {
            height += 54+76*2+12;
        }else{
            height += 54+76*3+12;
        }
            
    }else {
        if (self.model.members.count <= 4) {
            height += 54+76+12;
        }else if (self.model.members.count <= 9) {
            height += 54+76*2+12;
        }else{
            height += 54+76*3+12;
        }
    }
    self.headerView.height = height+10;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)initFooterView{
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 140);
    
    if (self.type == GroupSettingTypeHost) {
        
        UIButton *sendBtn = [FControlTool createButton:@"解散此群" font:[UIFont boldFontWithSize:18] textColor:RGBColor(0xDF0000) target:self sel:@selector(endBtnAction)];
        sendBtn.frame = CGRectMake(0, 15, kScreenWidth-30, 46);
        sendBtn.backgroundColor = UIColor.whiteColor;
        sendBtn.layer.masksToBounds = YES;
        [sendBtn rounded:5];
        [footerView addSubview:sendBtn];
    }else{
        
        UIButton *sendBtn = [FControlTool createButton:@"退出此群" font:[UIFont boldFontWithSize:15] textColor:RGBColor(0xDF0000) target:self sel:@selector(logoutGroupAction)];
        sendBtn.frame = CGRectMake(0, 15, kScreenWidth-30, 46);
        sendBtn.backgroundColor = UIColor.whiteColor;
        sendBtn.layer.masksToBounds = YES;
        [sendBtn rounded:5];
        [footerView addSubview:sendBtn];
    }
    
//    UIButton *reportBtn = [FControlTool createButton:@"投诉" font:[UIFont boldFontWithSize:15] textColor:UIColor.blackColor target:self sel:@selector(reportBtnAction)];
//    reportBtn.frame = CGRectMake(0, 77, kScreenWidth, 52);
//    reportBtn.backgroundColor = [UIColor whiteColor];
//    [reportBtn rounded:5];
//    [footerView addSubview:reportBtn];
    
    self.tableView.tableFooterView = footerView;
}

- (void)rightBtnAction{
    [self.headerView editBtnAction];
}

- (void)sendBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reportBtnAction{

}

- (void)logoutGroupAction{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出此群？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @weakify(self)
        [SVProgressHUD show];
        NSDictionary *params = @{@"groupId":self.model.groupId,@"userId":[FUserModel sharedUser].userID};
        [[FNetworkManager sharedManager] postRequestFromServer:@"/group/quitGroup" parameters:params success:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue] == 200) {
                [weak_self.navigationController popToRootViewControllerAnimated:YES];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:sure];
    [alertVc addAction:cancel];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

- (void)endBtnAction{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定解散此群？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @weakify(self)
        [SVProgressHUD show];
        NSDictionary *params = @{@"groupId":self.model.groupId};
        [[FNetworkManager sharedManager] postRequestFromServer:@"/group/dissolveGroup" parameters:params success:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue] == 200) {
                [weak_self.navigationController popToRootViewControllerAnimated:YES];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:sure];
    [alertVc addAction:cancel];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

- (void)requestData{
    if ([FDataTool isNull:self.model.groupId]) {
        return;
    }
    @weakify(self)
    [SVProgressHUD show];
    NSDictionary *params = @{@"groupId":self.model.groupId};
    [[FNetworkManager sharedManager] getRequestFromServer:@"/group/groupHomeInfo" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.model = [FGroupModel modelWithDictionary:response[@"data"]];
            weak_self.type = weak_self.model.rankState;
            weak_self.pageNum = 1;
            [weak_self requestMembers:^{
                [weak_self.headerView refreshViewWithData:weak_self.model];
                [weak_self setHeaderFrame];
                for (FGroupUserInfoModel *userInfo in self.model.members) {
                    if ([userInfo.userId isEqualToString:[FUserModel sharedUser].userID]) {
                        weak_self.model.userGroupName = userInfo.userGroupName;
                        break;
                    }
                }
                [weak_self.tableView reloadData];
                [SVProgressHUD dismiss];
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)requestMembers:(void(^)(void))success{
    @weakify(self)
    NSDictionary *params = @{@"groupId":self.model.groupId,@"page":@(self.pageNum)};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/groupUserListPost" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (weak_self.pageNum == 1) {
                [weak_self.groupMembers removeAllObjects];
            }
            if ([response[@"data"] count] == 0) {
                weak_self.model.members = weak_self.groupMembers;
                if (success) {
                    success();
                }
            }else{
                for (NSDictionary *dict in response[@"data"]) {
                    FGroupUserInfoModel *model = [FGroupUserInfoModel modelWithDictionary:dict];
                    [weak_self.groupMembers addObject:model];
                }
                weak_self.pageNum++;
                [weak_self requestMembers:success];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (NSMutableArray *)groupMembers{
    if (!_groupMembers) {
        _groupMembers = [[NSMutableArray alloc] init];
    }
    return _groupMembers;
}

#pragma mark - SWSecurityPrivacyCellDelegate
- (void)switchHandleAction:(SWSecurityPrivacyCell *)cell{
    if ([cell.titleLabel.text isEqualToString:@"设为置顶"]) {
        NIMSession *session = [NIMSession session:self.model.groupId type:NIMSessionTypeTeam];
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
        NIMTeamNotifyState state = NIMTeamNotifyStateNone;
        if (cell.switchBtn.selected) {
            state = NIMTeamNotifyStateAll;
        }
        [[NIMSDK sharedSDK].teamManager updateNotifyState:state inTeam:self.model.groupId completion:^(NSError * _Nullable error) {
            if (!error) {
                [cell.switchBtn setSelected:!cell.switchBtn.selected];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
        }];
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = self.dataList[section][@"list"];
    return list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenWidth - 30, 10);
    
//    UILabel *titleLabel = [FControlTool createLabel:self.dataList[section][@"title"] textColor:RGBColor(0x999999) font:[UIFont fontWithSize:12]];
//    titleLabel.frame = CGRectMake(9, 11, kScreenWidth - 49, 12);
//    [view addSubview:titleLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.dataList objectAtIndex:indexPath.section][@"list"][indexPath.row] isEqualToString:@"群公告"]) {
        if (self.model.announcement.length > 0) {
            CGSize size = [self.model.announcement sizeForFont:[UIFont fontWithSize:11] size:CGSizeMake(kScreenWidth - 46-60, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
            return size.height+35+15;
        }else{
            return 48;
        }
    }else{
        return 48;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell radius:5 color:UIColor.whiteColor indexPath:indexPath tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.dataList objectAtIndex:indexPath.section][@"list"][indexPath.row] isEqualToString:@"群公告"]) {
        static NSString *cellId = @"acocellId";
        SWSecurityPrivacyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SWSecurityPrivacyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = UIColor.whiteColor;
            cell.delegate = self;
            cell.icnImgView.hidden = YES;
            cell.titleLabel.frame = CGRectMake(16,  0, kScreenWidth-72, 48);
            
        }
        CGSize size = [self.model.announcement sizeForFont:[UIFont fontWithSize:11] size:CGSizeMake(kScreenWidth - 46-60, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
        cell.detailLabel.frame = CGRectMake(7,  cell.titleLabel.bottom+6, kScreenWidth - 46-60, size.height);
        cell.detailLabel.font = [UIFont fontWithSize:11];
        cell.detailLabel.numberOfLines = 0;
        cell.detailLabel.textColor = RGBColor(0x999999);
        cell.detailLabel.text = self.model.announcement;
        cell.detailLabel.textAlignment = NSTextAlignmentLeft;
        cell.arrowImgView.top = ((size.height+35+15) - cell.arrowImgView.height)/2;
        cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.section][@"list"][indexPath.row];
        cell.arrowImgView.hidden = NO;
        cell.switchBtn.hidden = YES;
        return cell;
    }else{
        static NSString *cellId = @"cellId";
        SWSecurityPrivacyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SWSecurityPrivacyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = UIColor.whiteColor;
            cell.delegate = self;
            cell.icnImgView.hidden = YES;
            cell.titleLabel.frame = CGRectMake(16,  0, kScreenWidth-72, 48);
        }
        cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.section][@"list"][indexPath.row];
        if (![cell.titleLabel.text isEqualToString:@"删除聊天记录"] && ![cell.titleLabel.text isEqualToString:@"我的本群昵称"] && ![cell.titleLabel.text isEqualToString:@"群管理"] && ![cell.titleLabel.text isEqualToString:@"群聊名称"] && ![cell.titleLabel.text isEqualToString:@"群号"]  && ![cell.titleLabel.text isEqualToString:@"未领取红包专区"] ) {
            cell.arrowImgView.hidden = YES;
            cell.switchBtn.hidden = NO;
            cell.detailLabel.hidden = YES;
            if (![cell.titleLabel.text isEqualToString:@"设为置顶"]) {
                cell.switchBtn.selected = self.isMute;
            }else{
                cell.switchBtn.selected = self.isTop;
            }
        }else{
            if ([cell.titleLabel.text isEqualToString:@"我的本群昵称"]){
                cell.detailLabel.text = self.model.userGroupName;
                cell.detailLabel.hidden = NO;
            }else if ([cell.titleLabel.text isEqualToString:@"群聊名称"]){
                cell.detailLabel.text = self.model.name;
                cell.detailLabel.hidden = NO;
            }else if ([cell.titleLabel.text isEqualToString:@"群号"]){
                cell.detailLabel.text = self.model.groupId;
                cell.detailLabel.hidden = NO;
            }else{
                cell.detailLabel.hidden = YES;
            }
            cell.arrowImgView.hidden = NO;
            cell.switchBtn.hidden = YES;
        }
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWSecurityPrivacyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.titleLabel.text isEqualToString:@"删除聊天记录"]) {
        @weakify(self)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"删除聊天记录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NIMSessionDeleteAllRemoteMessagesOptions *option = [[NIMSessionDeleteAllRemoteMessagesOptions alloc] init];
            option.removeOtherClients = YES;
            [[NIMSDK sharedSDK].conversationManager deleteAllRemoteMessagesInSession:[NIMSession session:self.model.groupId type:NIMSessionTypeTeam] options:option completion:^(NSError * _Nullable error) {
                
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:FClearMsgRecord object:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [[FControlTool getCurrentVC] presentViewController:alert animated:YES completion:^{
            
        }];
    }else if ([cell.titleLabel.text isEqualToString:@"群管理"]) {
        SWGroupManagerViewController *vc = [[SWGroupManagerViewController alloc] init];
        vc.groupModel = self.model;
        vc.type = self.model.rankState;
        @weakify(self)
        vc.reloadBlock = ^{
            [weak_self requestData];
        };
        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"我的本群昵称"]) {
        SWEditNameView *view = [[SWEditNameView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        view.titleLabel.text = @"编辑我的本群昵称";
        [[FControlTool keyWindow] addSubview:view];
        [view show];
        @weakify(self)
        view.saveName = ^(NSString * _Nonnull name) {
            [weak_self saveNickName:name];
        };
    }else if ([cell.titleLabel.text isEqualToString:@"群公告"]) {
        [self editGroupAnnouncement];
    }else if ([cell.titleLabel.text isEqualToString:@"群聊名称"]) {
        [self editGroupName];
    }else if ([cell.titleLabel.text isEqualToString:@"未领取红包专区"]) {
        SWUnclaimedRedPacketViewController *vc = [[SWUnclaimedRedPacketViewController alloc] init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - SWGroupEditAlertViewDelegate
- (void)editGroupName{
    if (self.type != GroupSettingTypeHost && self.type != GroupSettingTypeManage) {
        return;
    }
    @weakify(self)
    SWEditGroupNameViewController *vc = [[SWEditGroupNameViewController alloc] init];
    vc.groupModel = self.model;
    vc.saveName = ^(NSString * _Nonnull name) {
        weak_self.model.name = name;
        [weak_self.tableView reloadData];
        [weak_self.headerView refreshViewWithData:self.model];
    };
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)editGroupAnnouncement{
    if (self.type != GroupSettingTypeHost && self.type != GroupSettingTypeManage) {
        return;
    }
    @weakify(self)
    SWGroupEditAnnouncementView *view = [[SWGroupEditAnnouncementView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.inputTextView.text = self.model.announcement;
    view.model = self.model;
    view.saveName = ^(NSString * _Nonnull name) {
        weak_self.model.announcement = name;
        [weak_self.tableView reloadData];
    };
    [[FControlTool keyWindow] addSubview:view];
    [view show];
}

- (void)saveNickName:(NSString*)name{
    NSDictionary *params = @{@"nickName":name,@"groupId":self.model.groupId};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/groupMember/installGroupNickName" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.model.userGroupName = name;
            [weak_self.tableView reloadData];
            [SVProgressHUD dismiss];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, kTopHeight+16, kScreenWidth-30, kScreenHeight-kTopHeight - 16) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(0xEEEDF2);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = RGBColor(0xEAEEF2);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
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
