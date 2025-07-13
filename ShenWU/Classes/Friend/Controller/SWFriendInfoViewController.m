//
//  SWFriendInfoViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/27.
//

#import "SWFriendInfoViewController.h"
#import "SWFriendInfoCell.h"
#import "SWSelectUserViewController.h"
#import "SWMessageDetaillViewController.h"
#import "SWEditNameView.h"
#import "TKReportViewController.h"
#import "SWFriendInfoHeaderView.h"
#import "SWFriendMoreActionViewController.h"
@interface SWFriendInfoViewController ()<UITableViewDelegate,UITableViewDataSource,SWFriendInfoCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) SWFriendInfoHeaderView *headerView;
@property(nonatomic, strong) NSArray *dataList;

@property(nonatomic, assign) BOOL isTop;
@property(nonatomic, assign) BOOL isBlack;
@property(nonatomic, assign) BOOL isMute;
@end

@implementation SWFriendInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.headerView.user = self.user;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
//    self.navigationItem.rightBarButtonItem = [self getRightBarButtonItem:@"icn_user_right" target:self action:@selector(rightBtnAction)];
    
    self.view.backgroundColor = RGBColor(0xEEEDF2);
    
    [self.view addSubview:self.tableView];
    
    self.headerView = [[SWFriendInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 159)];
    self.headerView.user = self.user;
    self.tableView.tableHeaderView = self.headerView;
    
    UIButton *sendBtn = [FControlTool createCommonButton:@"发消息" font:[UIFont boldFontWithSize:16] cornerRadius:8 size:CGSizeMake(kScreenWidth-30, 46) target:self sel:@selector(sendBtnAction)];
    sendBtn.frame = CGRectMake(15, kScreenHeight - 89, kScreenWidth-30, 46);
    sendBtn.backgroundColor = kMainColor;
    [sendBtn rounded:5];
    [self.view addSubview:sendBtn];
    
    [self initData];
}

- (void)initData{
    self.dataList = @[@[@"备注名"],@[@"消息免打扰",@"置顶聊天",@"黑名单"],@[@"清空聊天记录",@"推荐给好友"],@[@"举报投诉",@"删除好友"]];
    
    NIMSession *session = [NIMSession session:self.user.userId type:NIMSessionTypeP2P];
    NIMStickTopSessionInfo *info = [NIMSDK.sharedSDK.chatExtendManager stickTopInfoForSession:session];
    if (info) {
        self.isTop = YES;
    }
    
    self.isMute = ![[NIMSDK sharedSDK].userManager notifyForNewMsg:self.user.userId];
    self.isBlack = [[NIMSDK sharedSDK].userManager isUserInBlackList:self.user.userId];
    [self.tableView reloadData];
}

- (void)rightBtnAction{
    SWFriendMoreActionViewController *vc = [[SWFriendMoreActionViewController alloc] init];
    vc.user = self.user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendBtnAction{
    SWMessageDetaillViewController *messageVc;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SWMessageDetaillViewController class]]) {
            messageVc = (SWMessageDetaillViewController*)vc;
        }
    }
    if (messageVc) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
        vc.sessionId = self.user.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - SWFriendInfoCellDelegate
- (void)switchHandleAction:(SWFriendInfoCell *)cell{
    [SVProgressHUD show];
    if ([cell.titleLabel.text isEqualToString:@"置顶聊天"]) {
        NIMSession *session = [NIMSession session:self.user.userId type:NIMSessionTypeP2P];
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
        [[NIMSDK sharedSDK].userManager updateNotifyState:cell.switchBtn.selected forUser:self.user.userId completion:^(NSError * _Nullable error) {
            if (!error) {
                [cell.switchBtn setSelected:!cell.switchBtn.selected];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
        }];
    }else if ([cell.titleLabel.text isEqualToString:@"黑名单"]) {
        if (cell.switchBtn.selected) {
            [[NIMSDK sharedSDK].userManager removeFromBlackBlackList:self.user.userId completion:^(NSError * _Nullable error) {
                if (!error) {
                    [cell.switchBtn setSelected:!cell.switchBtn.selected];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                }
            }];
        }else{
            [[NIMSDK sharedSDK].userManager addToBlackList:self.user.userId completion:^(NSError * _Nullable error) {
                if (!error) {
                    [cell.switchBtn setSelected:!cell.switchBtn.selected];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                }
            }];
        }
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = self.dataList[section];
    return list.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenWidth - 22, 12);
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell radius:11 color:UIColor.whiteColor indexPath:indexPath tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWFriendInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWFriendInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
        cell.switchBtn.frame = CGRectMake(kScreenWidth - 62 - 15, 16, 41, 22);
        cell.detailLabel.frame = CGRectMake(50, 0, kScreenWidth - 45 - 60, 50);
        cell.arrowImgView.frame = CGRectMake(kScreenWidth - 55, 15, 21, 20);
    }
    cell.arrowImgView.hidden = YES;
    cell.switchBtn.hidden = YES;
    cell.detailLabel.hidden = YES;
    cell.titleLabel.textColor = UIColor.blackColor;
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.section][indexPath.row];

    if ([cell.titleLabel.text isEqualToString:@"置顶聊天"]) {
        cell.switchBtn.hidden = NO;
        cell.switchBtn.selected = self.isTop;
    }else if ([cell.titleLabel.text isEqualToString:@"消息免打扰"]) {
        cell.switchBtn.hidden = NO;
        cell.switchBtn.selected = self.isMute;
    }else if ([cell.titleLabel.text isEqualToString:@"黑名单"]) {
        cell.switchBtn.hidden = NO;
        cell.switchBtn.selected = self.isBlack;
    }else if ([cell.titleLabel.text isEqualToString:@"备注名"]) {
        cell.detailLabel.hidden = NO;
        cell.detailLabel.text = self.user.remark;
        cell.arrowImgView.hidden = NO;
        cell.detailLabel.frame = CGRectMake(50, 0, kScreenWidth - 80 - 30, 50);
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
    if ([cell.titleLabel.text isEqualToString:@"清空聊天记录"]) {
        @weakify(self)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"清除聊天记录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
//            option.removeTable = YES;
//            [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:[NIMSession session:weak_self.user.userId type:NIMSessionTypeP2P] option:option];
            
            NIMSessionDeleteAllRemoteMessagesOptions *option = [[NIMSessionDeleteAllRemoteMessagesOptions alloc] init];
            option.removeOtherClients = YES;
            [[NIMSDK sharedSDK].conversationManager deleteAllRemoteMessagesInSession:[NIMSession session:weak_self.user.userId type:NIMSessionTypeP2P] options:option completion:^(NSError * _Nullable error) {
                
            }];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FClearMsgRecord object:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }else if ([cell.titleLabel.text isEqualToString:@"推荐给好友"]) {
        SWSelectUserViewController *vc = [[SWSelectUserViewController alloc] init];
        vc.type = SelectFriendTypeCommon;
        vc.userModel = self.user;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"举报投诉"]) {
        TKReportViewController *vc = [[TKReportViewController alloc] init];
        vc.model = self.user;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"备注名"]) {
        SWEditNameView *view = [[SWEditNameView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        view.titleLabel.text = @"编辑备注";
        if (self.user.remark.length > 0) {
            view.nickName = self.user.remark;
        }else{
            view.nickName = self.user.name;
        }
        
        [[FControlTool keyWindow] addSubview:view];
        [view show];
        @weakify(self)
        view.saveName = ^(NSString * _Nonnull name) {
            [weak_self saveRemark:name];
        };
    }else if ([cell.titleLabel.text isEqualToString:@"删除好友"]) {
        @weakify(self)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"删除好友" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weak_self deleteFriend];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

- (void)saveRemark:(NSString *)name{
    [SVProgressHUD show];
    @weakify(self)
    NSDictionary *params = @{@"memberCode":self.user.memberCode,@"alias":name};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/updateRemark" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.user.remark = name;
            [[FUserRelationManager sharedManager] updateFriendRemark:self.user.userId remark:name];
            [SVProgressHUD dismiss];
            [weak_self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)deleteFriend{
    if ([FDataTool isNull:self.user.memberCode]) {
        return;
    }
    NSDictionary *params = @{@"memberCode":self.user.memberCode};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/delFriend" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
            [[NIMSDK sharedSDK].userManager deleteFriend:self.user.userId completion:^(NSError * _Nullable error) {
                
            }];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(11, kTopHeight, kScreenWidth-22, (kScreenHeight-kTopHeight)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = RGBColor(0xEAEEF2);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        
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
