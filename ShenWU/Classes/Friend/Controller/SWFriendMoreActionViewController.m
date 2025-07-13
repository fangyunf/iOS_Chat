//
//  SWFriendMoreActionViewController.m
//  ShenWU
//
//  Created by Amy on 2025/2/19.
//

#import "SWFriendMoreActionViewController.h"
#import "SWFriendInfoCell.h"
#import "TKReportViewController.h"
#import "SWEditNameView.h"
#import "SWMessageDetaillViewController.h"
@interface SWFriendMoreActionViewController ()<SWFriendInfoCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, assign) BOOL isBlack;
@end

@implementation SWFriendMoreActionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑";
    
    self.dataList = @[@"备注",@"投诉",@"拉黑"];
    self.isBlack = [[NIMSDK sharedSDK].userManager isUserInBlackList:self.user.userId];
    
    [self.view addSubview:self.tableView];
    
    UIButton *sendBtn = [FControlTool createButton:@"发消息" font:[UIFont boldFontWithSize:15] textColor:UIColor.whiteColor target:self sel:@selector(sendBtnAction)];
    sendBtn.frame = CGRectMake(15, kScreenHeight - 89, kScreenWidth-30, 46);
    sendBtn.backgroundColor = kMainColor;
    [sendBtn rounded:5];
    [self.view addSubview:sendBtn];
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

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWFriendInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWFriendInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
    }
    cell.arrowImgView.hidden = YES;
    cell.switchBtn.hidden = YES;
    cell.detailLabel.hidden = YES;
    cell.titleLabel.textColor = UIColor.blackColor;
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.row];
    if ([cell.titleLabel.text isEqualToString:@"拉黑"]) {
        cell.switchBtn.hidden = NO;
        cell.switchBtn.selected = self.isBlack;
    }else if ([cell.titleLabel.text isEqualToString:@"备注"]) {
        cell.detailLabel.hidden = NO;
        cell.detailLabel.text = self.user.remark;
        cell.arrowImgView.hidden = NO;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWFriendInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.titleLabel.text isEqualToString:@"投诉"]) {
        TKReportViewController *vc = [[TKReportViewController alloc] init];
        vc.model = self.user;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"备注"]) {
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


#pragma mark - SWFriendInfoCellDelegate
- (void)switchHandleAction:(SWFriendInfoCell *)cell{
    [SVProgressHUD show];
    if ([cell.titleLabel.text isEqualToString:@"拉黑"]) {
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

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(0xEEEDF2);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
        
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
