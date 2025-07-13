//
//  SWWalletNotiDetailViewController.m
//  ShenWU
//
//  Created by Amy on 2025/3/3.
//

#import "SWWalletNotiDetailViewController.h"
#import "SWWalletMessageCell.h"
#import <JXCategoryView/JXCategoryView.h>
@interface SWWalletNotiDetailViewController ()<UITableViewDelegate,UITableViewDataSource,JXCategoryListContentViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, assign) NSInteger pageNum;
@end

@implementation SWWalletNotiDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"钱包通知";
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = self.view.bounds;
    bgImgView.backgroundColor = RGBColor(0xf2f2f2);
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.userInteractionEnabled = YES;
    bgImgView.layer.masksToBounds = YES;
    [self.view addSubview:bgImgView];
    
    [self.tableView reloadData];
    
    self.dataList = [NSMutableArray array];
    [self refreshData];
}

- (void)refreshData{
    self.pageNum = 1;
    [self requestData];
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadMoreData{
    self.pageNum++;
    [self requestData];
}

- (void)requestData{
    @weakify(self)
    
    NSDictionary *params = @{@"pageNo":[NSNumber numberWithInteger:self.pageNum],@"pageSize":@(20),@"userId":[FUserModel sharedUser].userID};
    NSString *url = @"";
    if (self.isRecharge) {
        url = @"/send/queryRecharge";
    }else{
        url = @"/send/queryPayWith";
    }
    [[FNetworkManager sharedManager] postRequestFromServer:url parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (weak_self.pageNum == 1) {
                [weak_self.dataList removeAllObjects];
            }
            SWWalletMessageModel *model = [SWWalletMessageModel modelWithDictionary:response[@"data"]];
            [self.dataList addObjectsFromArray:model.data];
            weak_self.pageNum = model.pageNum;
            if (self.dataList.count == model.total) {
                weak_self.tableView.mj_footer = nil;
            }
            [weak_self.tableView reloadData];
        }
        
        [weak_self.tableView.mj_footer endRefreshing];
        [weak_self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [weak_self.tableView.mj_footer endRefreshing];
        [weak_self.tableView.mj_header endRefreshing];
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
    SWWalletMessageItemModel *model = [self.dataList objectAtIndex:indexPath.row];
    NSString *contentStr = @"";
    if (self.isRecharge) {
        if([model.state isEqualToString:@"1"]){
            contentStr = [NSString stringWithFormat:@"成功充值%.02lf元到您的余额",[model.amount doubleValue]/100];
        }else if([model.state isEqualToString:@"0"]){
            contentStr = [NSString stringWithFormat:@"充值中,充值%.02lf元",[model.amount doubleValue]/100];
        }else {
            contentStr = [NSString stringWithFormat:@"充值%.02lf元失败",[model.amount doubleValue]/100];
        }
    }else{
        if([model.state isEqualToString:@"0"]){
            contentStr = [NSString stringWithFormat:@"发起申请提现操作:提现%.02lf元",[model.amount doubleValue]/100];
        }else if([model.state isEqualToString:@"1"]){
            contentStr = [NSString stringWithFormat:@"您提现%.02lf元审核通过,注意查看银行短信通知",[model.remitAmount doubleValue]/100];
        }else {
            contentStr = [NSString stringWithFormat:@"您提现%.02lf元失败",[model.amount doubleValue]/100];
        }
    }
    
    CGSize size = [contentStr sizeForFont:[UIFont fontWithSize:13] size:CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    return 30+48+size.height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWWalletMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWWalletMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBColor(0xf2f2f2);
        
    }
    cell.isRecharge = self.isRecharge;
    cell.model = [self.dataList objectAtIndex:indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-52) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)listView{
    return self.view;
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
