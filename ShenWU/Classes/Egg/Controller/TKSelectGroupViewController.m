//
//  TKSelectGroupViewController.m
//  ShenWU
//
//  Created by Amy on 2024/8/25.
//

#import "TKSelectGroupViewController.h"
#import "FFriendCell.h"
#import "SWMessageDetaillViewController.h"
@interface TKSelectGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation TKSelectGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发放彩蛋";
    self.view.backgroundColor = RGBColor(0xF2F2F2);
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    bgImgView.image = [UIImage imageNamed:@"bg_mine"];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.layer.masksToBounds = YES;
    [self.view addSubview:bgImgView];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [FUserRelationManager sharedManager].allGroups.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    FFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FFriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    FGroupModel *group = [[FUserRelationManager sharedManager].allGroups objectAtIndex:indexPath.row];
    cell.nameLabel.text = group.name;
    [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:group.head] placeholderImage:[UIImage imageNamed:@"avatar_group"]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FGroupModel *group = [[FUserRelationManager sharedManager].allGroups objectAtIndex:indexPath.row];
    @weakify(self)
    TKPaySucceseAlertView *view = [[TKPaySucceseAlertView alloc] initWithFrame:self.view.bounds bgImgStr:@"bg_pay_sucess" title:[NSString stringWithFormat:@"发放彩蛋至 %@",group.name] des:@"" btnStr:@"确定"];
    view.clickOnSureBtn = ^{
        [weak_self requestIssueEgg:group.groupId];
    };
    [[FControlTool keyWindow] addSubview:view];
}

- (void)requestIssueEgg:(NSString*)groupId{
    [SVProgressHUD show];
    @weakify(self);
    NSDictionary *params = @{@"caiDanId":self.eggId,@"groupId":groupId};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/sjCaiDan" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"发放成功"];
            [weak_self showMsgDetail:groupId];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)showMsgDetail:(NSString*)groupId{
    SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = NIMSessionTypeTeam;
    vc.sessionId = groupId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight+13, kScreenWidth, kScreenHeight-kTopHeight-13) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
