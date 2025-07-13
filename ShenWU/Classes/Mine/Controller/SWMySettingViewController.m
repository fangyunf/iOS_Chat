//
//  SWMySettingViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/23.
//

#import "SWMySettingViewController.h"
#import "SWMySettingCell.h"
#import "SWMsgNotiViewController.h"
#import "SWSecurityPrivacyViewController.h"
#import "TKPasswordSettingViewController.h"
#import "TKMessageSettingViewController.h"
#import "SWAboutViewController.h"
#import "SWEidtInfoViewController.h"
#import "TKAccountDeleteViewController.h"
#import "SWSwitchAccountViewController.h"
#import "SWMessageDetaillViewController.h"
@interface SWMySettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@end

@implementation SWMySettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.view.backgroundColor = RGBColor(0xF5F7FA);
    
    self.dataList = @[@[@"账号与安全",@"新消息通知",@"安全与隐私"],@[@"关于我们",@"帮助与反馈",@"联系客服",@"清除缓存",@"清空聊天记录"],@[@"切换账号",@"注销账号",@"退出登录"]];
    
    [self.tableView reloadData];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = [self.dataList objectAtIndex:section];
    return list.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWMySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWMySettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColor.whiteColor;
        cell.bgView.frame = CGRectMake(0, 0, kScreenWidth - 30, 48);
        cell.bgView.backgroundColor = UIColor.whiteColor;
        [cell.bgView rounded:0];
        
        cell.titleLabel.frame = CGRectMake(13, 0, kScreenWidth-56, 48);
        
        cell.detailLabel.frame = CGRectMake(kScreenWidth/2 - 71-8, 0, kScreenWidth/2, 48);
        
        cell.arrowImgView.frame = CGRectMake(kScreenWidth - 30 - 33, 14, 21, 20);
    }
    
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.section][indexPath.row];
    cell.arrowImgView.hidden = NO;
    cell.titleLabel.textColor = UIColor.blackColor;
    if ([[self.dataList objectAtIndex:indexPath.section][indexPath.row] isEqualToString:@"清除缓存"]) {
        cell.detailLabel.text = [NSString stringWithFormat:@"%.2lfM",[[FAppManager sharedManager] readCacheSize]];
    }else{
        cell.detailLabel.text = @"";
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataList[indexPath.section][indexPath.row] isEqualToString:@"账号与安全"]) {
        SWEidtInfoViewController *vc = [[SWEidtInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row] isEqualToString:@"新消息通知"]) {
        TKMessageSettingViewController *vc = [[TKMessageSettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row] isEqualToString:@"安全与隐私"]) {
        SWSecurityPrivacyViewController *vc = [[SWSecurityPrivacyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row] isEqualToString:@"关于我们"]) {
        SWAboutViewController *vc = [[SWAboutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row] isEqualToString:@"帮助与反馈"]) {

    }else if ([self.dataList[indexPath.section][indexPath.row] isEqualToString:@"联系客服"]) {
        SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = NIMSessionTypeP2P;
        vc.sessionId = [FMessageManager sharedManager].serviceUserId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row] isEqualToString:@"切换账号"]) {
        SWSwitchAccountViewController *vc = [[SWSwitchAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row] isEqualToString:@"注销账号"]) {
        TKAccountDeleteViewController *vc = [[TKAccountDeleteViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row] isEqualToString:@"退出登录"]) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:sure];
        [alertVc addAction:cancel];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else if ([self.dataList[indexPath.section][indexPath.row] isEqualToString:@"清除缓存"]) {
        [self clearCache];
    }else if ([self.dataList[indexPath.section][indexPath.row] isEqualToString:@"清空聊天记录"]) {
        [self clearAllMsg];
    }
}

- (void)clearCache{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否清除缓存" message:[NSString stringWithFormat:@"当前缓存为%.2lfM",[[FAppManager sharedManager] readCacheSize]] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[FAppManager sharedManager] clearFile];
        [SVProgressHUD showSuccessWithStatus:@"清除成功"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)clearAllMsg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"清空所有聊天记录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        for (FFriendModel *model in [FUserRelationManager sharedManager].allFriends) {
            NIMSessionDeleteAllRemoteMessagesOptions *option = [[NIMSessionDeleteAllRemoteMessagesOptions alloc] init];
            option.removeOtherClients = YES;
            [[NIMSDK sharedSDK].conversationManager deleteAllRemoteMessagesInSession:[NIMSession session:model.userId type:NIMSessionTypeP2P] options:option completion:^(NSError * _Nullable error) {
                
            }];
        }
        for (FGroupModel *model in [FUserRelationManager sharedManager].allGroups) {
            NIMSessionDeleteAllRemoteMessagesOptions *option = [[NIMSessionDeleteAllRemoteMessagesOptions alloc] init];
            option.removeOtherClients = YES;
            [[NIMSDK sharedSDK].conversationManager deleteAllRemoteMessagesInSession:[NIMSession session:model.groupId type:NIMSessionTypeTeam] options:option completion:^(NSError * _Nullable error) {
                
            }];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:FClearMsgRecord object:nil];
            [SVProgressHUD dismiss];
        });
//        NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
//        option.removeTable = YES;
//        [[NIMSDK sharedSDK].conversationManager deleteAllMessages:option];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenWidth - 32, 24);
    return view;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell radius:11 color:UIColor.whiteColor indexPath:indexPath tableView:tableView];
}

- (void)checkUpdate{
    @weakify(self)
    // 获取App的build版本
    NSString *appBuildVersion = @"1";
    [[FNetworkManager sharedManager] getRequestFromServer:@"/customer/versionCkeck" parameters:@{@"type":@"IOS", @"version":appBuildVersion} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            /// 有更新
            __block NSDictionary *data = response[@"data"];
            if (![FDataTool isNull:data]) {
                NSInteger type = [data[@"type"] integerValue];
                if (type == 1) {
                    /// 这里指做强制更新的控件
                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"upMsg"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data[@"downloadUrl"]] options:@{} completionHandler:^(BOOL success) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                exit(0);
                            });
                        }];
                    }];
                    [alertVc addAction:sureAction];
                    [self presentViewController:alertVc animated:YES completion:nil];
                }
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, kTopHeight+10, kScreenWidth-30, kScreenHeight - kTopHeight - 10) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(0xF5F7FA);
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
