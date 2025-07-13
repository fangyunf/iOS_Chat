//
//  SWBlackListViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWBlackListViewController.h"
#import "SWSearchView.h"
#import "SWBlackListCell.h"
@interface SWBlackListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) SWSearchView *searchView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) BOOL isSearch;
@property(nonatomic, strong) NSString *searchContent;
@end

@implementation SWBlackListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTopView.hidden = NO;
    self.title = @"黑名单";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.searchView = [[SWSearchView alloc] initWithFrame:CGRectMake(16, kTopHeight+18, kScreenWidth - 32, 40)];
    self.searchView.placeholder = @"搜索";
    @weakify(self)
    self.searchView.searchBlock = ^(NSString * _Nonnull content) {
        weak_self.isSearch = YES;
        [weak_self searchUser:content];
    };
    self.searchView.endSearchBlock = ^{
        weak_self.isSearch = NO;
        weak_self.searchContent = @"";
        [weak_self initData];
    };
    [self.view addSubview:self.searchView];
    
    [self.tableView reloadData];
    
    [self initData];
}

- (void)initData{
    if (!self.dataList) {
        self.dataList = [[NSMutableArray alloc] init];
    }
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:[[NIMSDK sharedSDK].userManager myBlackList]];
//    self.pageNum = 0;
//    [self refreshData];
    [self.tableView reloadData];
}

- (void)searchUser:(NSString *)content{
    self.searchContent = content;
    [self.dataList removeAllObjects];
    for (NIMUser *user in [[NIMSDK sharedSDK].userManager myBlackList]) {
        if ([user.alias.lowercaseString containsString:content.lowercaseString] || [user.userInfo.nickName.lowercaseString containsString:content.lowercaseString]) {
            [self.dataList addObject:user];
        }
    }
    [self.tableView reloadData];
}

//- (void)refreshData{
//    @weakify(self)
//    [self.dataList removeAllObjects];
//    NSDictionary *params = @{@"pageNo":[NSNumber numberWithInteger:0]};
//    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/blackList" parameters:params success:^(NSDictionary * _Nonnull response) {
//        if ([response[@"code"] integerValue] == 200) {
//            weak_self.model = [FBlackListModel modelWithDictionary:response[@"data"]];
//            [weak_self.dataList addObjectsFromArray:weak_self.model.data];
//            [weak_self.tableView reloadData];
//            weak_self.pageNum = weak_self.model.pageNum;
//            if (weak_self.model.total == weak_self.dataList.count) {
//                weak_self.tableView.mj_footer = nil;
//            }
//        }
//
//        [weak_self.tableView.mj_header endRefreshing];
//    } failure:^(NSError * _Nonnull error) {
//        [weak_self.tableView.mj_header endRefreshing];
//    }];
//
//
//}
//
//- (void)loadMoreData{
//    @weakify(self)
//    NSDictionary *params = @{@"pageNo":[NSNumber numberWithInteger:self.pageNum]};
//    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/blackList" parameters:params success:^(NSDictionary * _Nonnull response) {
//        if ([response[@"code"] integerValue] == 200) {
//            weak_self.model = [FBlackListModel modelWithDictionary:response[@"data"]];
//            [weak_self.dataList addObjectsFromArray:weak_self.model.data];
//            [weak_self.tableView reloadData];
//        }
//
//        [weak_self.tableView.mj_footer endRefreshing];
//    } failure:^(NSError * _Nonnull error) {
//        [weak_self.tableView.mj_footer endRefreshing];
//    }];
//}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWBlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWBlackListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    }
    [cell refreshCellWithData:[self.dataList objectAtIndex:indexPath.row]];
    @weakify(self)
    cell.removeBlackBlock = ^{
        if (weak_self.isSearch) {
            [weak_self searchUser:weak_self.searchContent];
        }else{
            [weak_self initData];
        }
        
    };
    return cell;
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchView.bottom+26, kScreenWidth, kScreenHeight-(self.searchView.bottom+26)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = RGBColor(0xF2F2F2);
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
