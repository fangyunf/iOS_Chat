//
//  SWGroupApplyViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/30.
//

#import "SWGroupApplyViewController.h"
#import "FApplyGroupModel.h"
#import "SWSearchView.h"
#import "SWNewFriendCell.h"
#import "SWGroupVerifyViewController.h"
@interface SWGroupApplyViewController ()<UITableViewDelegate,UITableViewDataSource,SWGroupVerifyViewControllerDelegate>
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

@implementation SWGroupApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTopView.hidden = YES;
    self.title = @"群申请";
    
//    UIImageView *bgImgView = [[UIImageView alloc] init];
//    bgImgView.frame = self.view.bounds;
////    bgImgView.image = [UIImage imageNamed:@"bg_mine"];
//    bgImgView.backgroundColor = RGBColor(0xf2f2f2);
//    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
//    bgImgView.userInteractionEnabled = YES;
//    bgImgView.layer.masksToBounds = YES;
//    [self.view addSubview:bgImgView];
    

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
    for (FApplyGroupModel *user in self.dataList) {
        if ([user.groupName.lowercaseString containsString:content.lowercaseString] || [user.userName.lowercaseString containsString:content.lowercaseString]) {
            [self.searchList addObject:user];
        }
    }
    [self.tableView reloadData];
}

- (void)initData{
    self.dataList = [[NSMutableArray alloc] init];
    self.searchList = [[NSMutableArray alloc] init];
    self.currentDate = [NSDate date];
    self.pageNum = 1;
    [self refreshData];
}

- (void)refreshData{
    self.pageNum = 1;
    [self requestData];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadMoreData{
    self.pageNum++;
    [self requestData];
}

- (void)requestData{
    @weakify(self)
    
    NSDictionary *params = @{@"pageNo":[NSNumber numberWithInteger:self.pageNum]};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/applyGroups" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (weak_self.pageNum == 1) {
                [weak_self.dataList removeAllObjects];
            }
            FApplyGroupListModel *model = [FApplyGroupListModel modelWithDictionary:response[@"data"]];
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
    if (self.isSearch) {
        return self.searchList.count;
    }else{
        return self.dataList.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWNewFriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.isGroup = YES;
    }
    if (self.isSearch) {
        [cell refreshCellWithGroupData:[self.searchList objectAtIndex:indexPath.row]];
    }else{
        [cell refreshCellWithGroupData:[self.dataList objectAtIndex:indexPath.row]];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWGroupVerifyViewController *vc = [[SWGroupVerifyViewController alloc] init];
    if (self.isSearch) {
        vc.model = [self.searchList objectAtIndex:indexPath.row];
    }else{
        vc.model = [self.dataList objectAtIndex:indexPath.row];
    }
    vc.delegate = self;
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - SWGroupVerifyViewControllerDelegate
- (void)refuseApply:(SWGroupVerifyViewController *)controller{

}

- (void)agreeApply:(SWGroupVerifyViewController *)controller{

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
