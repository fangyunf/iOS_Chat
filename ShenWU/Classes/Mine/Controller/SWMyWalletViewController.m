//
//  SWMyWalletViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/29.
//

#import "SWMyWalletViewController.h"
#import "SWPayPasswordViewController.h"
#import "SWUsdtViewController.h"
#import "SWBillingDetailsViewController.h"
#import "SWRedPacketRecordViewController.h"
#import "SWBankCardViewController.h"
#import "SWZfbViewController.h"
#import "PWalletHeaderView.h"
#import "SWMySettingCell.h"
#import "SWRealNameViewController.h"
@interface SWMyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) PWalletHeaderView *headerView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, strong) NSArray *dataList1;
@end

@implementation SWMyWalletViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestBalance];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的钱包";
    self.navTopView.hidden = YES;
    
    self.view.backgroundColor = RGBColor(0xF5F7FA);
    
    UIImageView *topBgView = [[UIImageView alloc] init];
    topBgView.frame = CGRectMake(0, 0, kScreenWidth, 275*kScale);
    topBgView.image = [UIImage imageNamed:@"bg_wallet_top"];
    [self.view addSubview:topBgView];
    
    self.dataList = @[@{@"title":@"红包账单",@"imageName":@"icn_wallet_record"},
                      @{@"title":@"支付账单",@"imageName":@"icn_wallet_detail"},
                      @{@"title":@"实名认证",@"imageName":@"icn_wallet_realname"},
                      @{@"title":@"绑定支付宝",@"imageName":@"icn_wallet_zfb"}];
    
    self.headerView = [[PWalletHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-22, 350+16)];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)requestBalance{
    @weakify(self)
    [[FUserModel sharedUser] getBalance:^(double balance) {
        weak_self.headerView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",(double)balance];
    }];
}

- (void)rightBtnAction{
    
}

- (void)btnAction:(UIButton*)sender{
    NSInteger index = sender.tag - 100;
    if(index == 0){
        SWRedPacketRecordViewController *vc = [[SWRedPacketRecordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 1){
        SWBillingDetailsViewController *vc = [[SWBillingDetailsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 2){
        SWRealNameViewController *vc = [[SWRealNameViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 3){
        SWBankCardViewController *vc = [[SWBankCardViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 4){
        
    }else if (index == 5){
        SWZfbViewController *vc = [[SWZfbViewController alloc] init];
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
    return 74;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell radius:11 color:UIColor.whiteColor indexPath:indexPath tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWMySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWMySettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.bgView.backgroundColor = [UIColor whiteColor];
        cell.bgView.frame = CGRectMake(0, 8, kScreenWidth - 32, 56);
        cell.titleLabel.frame = CGRectMake(16, 0, kScreenWidth-62, 56);
        cell.arrowImgView.frame = CGRectMake(kScreenWidth - 32 - 33, 18, 21, 20);
    }
    NSDictionary *dict = [self.dataList objectAtIndex:indexPath.row];
    cell.titleLabel.text = dict[@"title"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWMySettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.titleLabel.text isEqualToString:@"红包账单"]) {
        SWRedPacketRecordViewController *vc = [[SWRedPacketRecordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([cell.titleLabel.text isEqualToString:@"支付账单"]) {
        SWBillingDetailsViewController *vc = [[SWBillingDetailsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([cell.titleLabel.text isEqualToString:@"实名认证"]) {
        SWRealNameViewController *vc = [[SWRealNameViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([cell.titleLabel.text isEqualToString:@"我的卡包"]) {
        SWBankCardViewController *vc = [[SWBankCardViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([cell.titleLabel.text isEqualToString:@"绑定支付宝"]) {
        SWZfbViewController *vc = [[SWZfbViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([cell.titleLabel.text isEqualToString:@"设置密码"]) {
        SWPayPasswordViewController *vc = [[SWPayPasswordViewController alloc] init];
        vc.type = PasswordTypeSetting;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([cell.titleLabel.text isEqualToString:@"修改密码"]) {
        SWPayPasswordViewController *vc = [[SWPayPasswordViewController alloc] init];
        vc.type = PasswordTypeEdit;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([cell.titleLabel.text isEqualToString:@"数字人民币"]) {
        
    }
    if ([cell.titleLabel.text isEqualToString:@"绑定微信"]) {
        SWZfbViewController *vc = [[SWZfbViewController alloc] init];
        vc.isWx = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([cell.titleLabel.text isEqualToString:@"娱乐游戏"]) {
        [SVProgressHUD showInfoWithStatus:@"敬请期待，等待开放"];
    }
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, kTopHeight, kScreenWidth - 32, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 30);
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
