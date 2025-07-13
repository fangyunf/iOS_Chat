//
//  SWGroupInfoCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/25.
//

#import "SWGroupInfoCell.h"
#import "SWSecurityPrivacyCell.h"
#import "SWEditNameView.h"
#import "SWGroupManagerViewController.h"
@interface SWGroupInfoCell ()<SWSecurityPrivacyCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, assign) BOOL isTop;
@property(nonatomic, assign) BOOL isMute;
@end

@implementation SWGroupInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(15, 0, kScreenWidth-30, 30+44*2);
        self.bgView.backgroundColor = UIColor.whiteColor;
        self.bgView.layer.cornerRadius = 10;
        self.bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bgView];
    }
    return self;
}

- (void)refreshCellWithData:(NSArray*)data{
    self.dataList = data;
    if (self.tag == 0) {
        self.bgView.frame = CGRectMake(15, 5, kScreenWidth-30, 30+44*self.dataList.count);
    }else{
        self.bgView.frame = CGRectMake(15, 0, kScreenWidth-30, 30+44*self.dataList.count);
    }
    self.tableView.frame = CGRectMake(15, 15, kScreenWidth-30, 44*self.dataList.count);
    
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
    
    [self.tableView reloadData];
}

#pragma mark - SWSecurityPrivacyCellDelegate
- (void)switchHandleAction:(SWSecurityPrivacyCell *)cell{
    if ([cell.titleLabel.text isEqualToString:@"置顶聊天"]) {
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
    SWSecurityPrivacyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWSecurityPrivacyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColor.whiteColor;
        cell.delegate = self;
        cell.icnImgView.hidden = NO;
        cell.titleLabel.frame = CGRectMake(cell.icnImgView.right+5,  0, kScreenWidth-72, 44);
    }
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.row][@"title"];
    cell.icnImgView.image = [UIImage imageNamed:[self.dataList objectAtIndex:indexPath.row][@"imageName"]];
    if (![cell.titleLabel.text isEqualToString:@"清除聊天记录"] && ![cell.titleLabel.text isEqualToString:@"我的群昵称"] && ![cell.titleLabel.text isEqualToString:@"群管理"]) {
        cell.arrowImgView.hidden = YES;
        cell.switchBtn.hidden = NO;
        if (![cell.titleLabel.text isEqualToString:@"置顶聊天"]) {
            cell.switchBtn.selected = self.isMute;
        }else{
            cell.switchBtn.selected = self.isTop;
        }
    }else{
        if ([cell.titleLabel.text isEqualToString:@"我的群昵称"]){
            cell.detailLabel.text = self.model.userGroupName;
            cell.detailLabel.hidden = NO;
        }else{
            cell.detailLabel.hidden = YES;
        }
        
        cell.arrowImgView.hidden = NO;
        cell.switchBtn.hidden = YES;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWSecurityPrivacyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.titleLabel.text isEqualToString:@"清除聊天记录"]) {
        @weakify(self)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"清除聊天记录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
//            option.removeTable = YES;
//            [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:[NIMSession session:self.model.groupId type:NIMSessionTypeTeam] option:option];NIMSessionDeleteAllRemoteMessagesOptions *option = [[NIMSessionDeleteAllRemoteMessagesOptions alloc] init];
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
            if (weak_self.refreshBlock) {
                weak_self.refreshBlock();
            }
        };
        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"我的群昵称"]) {
        SWEditNameView *view = [[SWEditNameView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        view.titleLabel.text = @"编辑我的群昵称";
        [[FControlTool keyWindow] addSubview:view];
        [view show];
        @weakify(self)
        view.saveName = ^(NSString * _Nonnull name) {
            [weak_self saveNickName:name];
        };
    }
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth-30, 44*self.dataList.count) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
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
