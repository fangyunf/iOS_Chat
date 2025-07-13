//
//  SWNewFriendViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWNewFriendViewController.h"
#import "FFriendApplyListModel.h"
#import "SWSearchView.h"
#import "SWNewFriendCell.h"
@interface SWNewFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) SWSearchView *searchView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) NSMutableArray *searchList;
@property(nonatomic, strong) FFriendApplyListModel *model;
@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) BOOL isSearch;
@property(nonatomic, strong) NSString *searchContent;
@end

@implementation SWNewFriendViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTopView.hidden = NO;
    self.title = @"新朋友";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.searchView = [[SWSearchView alloc] initWithFrame:CGRectMake(16, kTopHeight+18, kScreenWidth - 32, 40)];
    self.searchView.placeholder = @"搜索你要查找的账号";
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
    
    [self initData];
}

- (void)searchUser:(NSString *)content{
    self.searchContent = content;
    [self.searchList removeAllObjects];
    for (FFriendApplyModel *user in self.dataList) {
        if ([user.name.lowercaseString containsString:content.lowercaseString] || [user.memberCode.lowercaseString containsString:content.lowercaseString]) {
            [self.searchList addObject:user];
        }
    }
    [self.tableView reloadData];
}

- (void)initData{
    self.dataList = [[NSMutableArray alloc] init];
    self.searchList = [[NSMutableArray alloc] init];
    self.currentDate = [NSDate date];
    self.pageNum = 0;
    [self refreshData];
}

- (void)refreshData{
    @weakify(self)
    self.pageNum = 0;
    [self.dataList removeAllObjects];
    
    NSDictionary *params = @{@"pageNo":[NSNumber numberWithInteger:0]};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/applyList" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.model = [FFriendApplyListModel modelWithDictionary:response[@"data"]];
            for (FFriendApplyModel *model in weak_self.model.data) {
                [self.dataList addObject:model];
            }
            [weak_self.tableView reloadData];
            weak_self.pageNum = weak_self.model.pageNum;
            if (weak_self.model.total == weak_self.dataList.count) {
                [weak_self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [FMessageManager sharedManager].friendNum = 0;
            [[FMessageManager sharedManager] refreshUnRead];
        }
        
        [weak_self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [weak_self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    @weakify(self)
    self.pageNum++;
    NSDictionary *params = @{@"pageNo":[NSNumber numberWithInteger:self.pageNum]};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/applyList" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.model = [FFriendApplyListModel modelWithDictionary:response[@"data"]];
            for (FFriendApplyModel *model in weak_self.model.data) {
                [self.dataList addObject:model];
            }
            [weak_self.tableView reloadData];
        }
        
        [weak_self.tableView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [weak_self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)getTimeDay:(NSString*)endDateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [dateFormatter dateFromString:[FDataTool updataForNumberTimeYear:[NSString stringWithFormat:@"%ld",endDateStr.integerValue/1000] formatter:@"YYYY-MM-dd HH:mm:ss"]];

    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSCalendarUnit unit = NSCalendarUnitWeekdayOrdinal;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:self.currentDate toDate:endDate options:0];
    //打印
    NSLog(@"%@",delta);
    //获取其中的"天"
    NSLog(@"day: %ld",delta.day);
    return delta.day;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        if (section == 0) {
            return self.searchList.count;
        }
        return 0;
    }else{
        return self.dataList.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return 0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return nil;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWNewFriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    if (self.isSearch) {
        [cell refreshCellWithData:[self.searchList objectAtIndex:indexPath.row]];
    }else{
        [cell refreshCellWithData:[self.dataList objectAtIndex:indexPath.row]];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchView.bottom+26, kScreenWidth, kScreenHeight-(self.searchView.bottom+26)) style:UITableViewStylePlain];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
