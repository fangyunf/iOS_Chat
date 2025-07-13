//
//  SWGroupManagerViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/26.
//

#import "SWGroupManagerViewController.h"
#import "SWSecurityPrivacyCell.h"
#import "SWGroupMemberViewController.h"
#import "PGroupUpgradeViewController.h"
#import "PGroupBlackViewController.h"
#import "SWSelectUserViewController.h"
@interface SWGroupManagerViewController ()<UITableViewDelegate,UITableViewDataSource,SWSecurityPrivacyCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@end

@implementation SWGroupManagerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
//    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群管理";
    
    self.view.backgroundColor = RGBColor(0xf2f2f2);
    
    if (self.type == GroupSettingTypeHost) {
        self.dataList = @[@"入群需审核",@"全员禁言",@"群保护模式",@"禁止领取优惠券",@"转让群主",@"设置管理员",@"群黑名单",@"禁止领取优惠券名单"];
    }else{
        self.dataList = @[@"入群需审核",@"全员禁言",@"群保护模式",@"禁止领取优惠券",@"设置管理员",@"群黑名单",@"禁止领取优惠券名单"];
    }
    
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
    
    [self requestData];
}

- (void)requestData{
    NSDictionary *params = @{@"groupId":self.groupModel.groupId};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] getRequestFromServer:@"/group/groupManage" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            FGroupModel *model = [FGroupModel modelWithDictionary:response[@"data"]];
            weak_self.groupModel.inviteState = model.inviteState;
            weak_self.groupModel.addFriendsState = model.addFriendsState;
            weak_self.groupModel.shutupState = model.shutupState;
            weak_self.groupModel.nonCollectionState = model.nonCollectionState;
            [weak_self.tableView reloadData];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - SWSecurityPrivacyCellDelegate
- (void)switchHandleAction:(SWSecurityPrivacyCell *)cell{
    NSDictionary *params = nil;
    if ([cell.titleLabel.text isEqualToString:@"入群需审核"]) {
        params = @{@"groupId":self.groupModel.groupId,@"inviteState":@(!self.groupModel.inviteState)};
        
    }else if ([cell.titleLabel.text isEqualToString:@"全员禁言"]) {
        params = @{@"groupId":self.groupModel.groupId,@"shutupState":@(!self.groupModel.shutupState)};
    }else if ([cell.titleLabel.text isEqualToString:@"禁止领取优惠券"]) {
        params = @{@"groupId":self.groupModel.groupId,@"nonCollectionState":@(!self.groupModel.nonCollectionState)};
    }else if ([cell.titleLabel.text isEqualToString:@"群保护模式"]) {
        params = @{@"groupId":self.groupModel.groupId,@"addFriendsState":@(!self.groupModel.addFriendsState)};
    }

    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/groupMember/invitationGroupConfirmed" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [cell.switchBtn setSelected:!cell.switchBtn.selected];
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
    if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2){
        return 61;
    }
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWSecurityPrivacyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWSecurityPrivacyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
    }
    cell.arrowImgView.frame = CGRectMake(kScreenWidth - 36, 16, 21, 20);
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.row];
    cell.arrowImgView.hidden = YES;
    cell.switchBtn.hidden = YES;
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        cell.switchBtn.hidden = NO;
        cell.detailLabel.hidden = NO;
        cell.titleLabel.frame = CGRectMake(12, 14, kScreenWidth-72, 15);
        cell.detailLabel.frame = CGRectMake(12, 34, kScreenWidth-72, 13);
        if (indexPath.row == 0) {
            cell.detailLabel.text = @"启用后只允许群主和管理员才能邀请群成员";
            [cell.switchBtn setSelected:!self.groupModel.inviteState];
        }else if (indexPath.row == 1) {
            cell.detailLabel.text = @"启用后只允许群主和管理员发言";
            [cell.switchBtn setSelected:!self.groupModel.shutupState];
        }else if (indexPath.row == 2) {
            cell.detailLabel.text = @"启用后群成员无法通过该群互加好友";
            [cell.switchBtn setSelected:!self.groupModel.addFriendsState];
        }
        cell.detailLabel.textAlignment = NSTextAlignmentLeft;
        cell.switchBtn.frame = CGRectMake(kScreenWidth - 55, 14, 40, 19);
        
    }else if(indexPath.row == 3){
        cell.switchBtn.hidden = NO;
        cell.detailLabel.hidden = YES;
        cell.titleLabel.frame = CGRectMake(16, 0, kScreenWidth-72, 44);
        cell.switchBtn.frame = CGRectMake(kScreenWidth - 55, 12.5, 40, 19);
        [cell.switchBtn setSelected:!self.groupModel.nonCollectionState];
    }else {
        cell.arrowImgView.hidden = NO;
        cell.detailLabel.hidden = YES;
        cell.titleLabel.frame = CGRectMake(16, 0, kScreenWidth-72, 44);
        cell.switchBtn.frame = CGRectMake(kScreenWidth - 55, 12.5, 40, 19);
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWSecurityPrivacyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.titleLabel.text isEqualToString:@"转让群主"]) {
        SWGroupMemberViewController *vc = [[SWGroupMemberViewController alloc] init];
        vc.type = GroupMemberTypeSelectHost;
        vc.model = self.groupModel;
        @weakify(self)
        vc.reloadBlock = ^{
            if (weak_self.reloadBlock) {
                weak_self.reloadBlock();
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"设置管理员"]) {
        SWGroupMemberViewController *vc = [[SWGroupMemberViewController alloc] init];
        vc.type = GroupMemberTypeSelectManage;
        vc.model = self.groupModel;
        @weakify(self)
        vc.reloadBlock = ^{
            if (weak_self.reloadBlock) {
                weak_self.reloadBlock();
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"群升级"]) {
        PGroupUpgradeViewController *vc = [[PGroupUpgradeViewController alloc] init];
        vc.model = self.groupModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"群黑名单"]) {
        PGroupBlackViewController *vc = [[PGroupBlackViewController alloc] init];
        vc.model = self.groupModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"禁止领取优惠券名单"]) {
        SWSelectUserViewController *vc = [[SWSelectUserViewController alloc] init];
        vc.type = SelectFriendTypeProhibit;
        vc.groupModel = self.groupModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight+29, kScreenWidth, kScreenHeight - (kTopHeight+29)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
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
