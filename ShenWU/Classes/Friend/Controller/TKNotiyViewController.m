//
//  TKNotiyViewController.m
//  ShenWU
//
//  Created by Amy on 2024/8/8.
//

#import "TKNotiyViewController.h"
#import "TKNotiyCell.h"
#import "PSystomNotiViewController.h"
#import "SWGroupApplyViewController.h"
#import "SWLittleHelperViewController.h"
@interface TKNotiyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation TKNotiyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统通知";
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    TKNotiyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TKNotiyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    if (indexPath.row == 0) {
        cell.icnImgView.image = [UIImage imageNamed:@"icn_system_msg"];
        cell.titleLabel.text = @"系统通知";
        cell.numLabel.hidden = NO;
        cell.numLabel.text = [NSString stringWithFormat:@"%ld",[FMessageManager sharedManager].sysNotiNum];
    } else if (indexPath.row == 1) {
        cell.icnImgView.image = [UIImage imageNamed:@"icn_group_msg"];
        cell.titleLabel.text = @"群通知";
        cell.numLabel.hidden = NO;
        cell.numLabel.text = [NSString stringWithFormat:@"%ld",[FMessageManager sharedManager].groupNum];
    } else if (indexPath.row == 2) {
        cell.icnImgView.image = [UIImage imageNamed:@"icn_wallet_msg"];
        cell.titleLabel.text = @"钱包消息";
        cell.numLabel.hidden = NO;
        NIMSession *sysSession = [NIMSession session:[FUserModel sharedUser].userID type:NIMSessionTypeP2P];
        NIMRecentSession *sysRecent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:sysSession];
        cell.numLabel.text = [NSString stringWithFormat:@"%ld",sysRecent.unreadCount];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PSystomNotiViewController *vc = [[PSystomNotiViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [FMessageManager sharedManager].sysNotiNum = 0;
    } else if (indexPath.row == 1) {
        SWGroupApplyViewController *vc = [[SWGroupApplyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        SWLittleHelperViewController *vc = [[SWLittleHelperViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        NIMSession *session = [NIMSession session:[FUserModel sharedUser].userID type:NIMSessionTypeP2P];
        [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:session];
        [[FMessageManager sharedManager] refreshUnRead];
    }
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight+14, kScreenWidth, kScreenHeight-kTopHeight-14) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
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
