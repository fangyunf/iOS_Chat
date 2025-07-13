//
//  PGroupBlackViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/20.
//

#import "PGroupBlackViewController.h"
#import "SWSearchView.h"
#import "SWBlackListCell.h"
@interface PGroupBlackViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) SWSearchView *searchView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) NSMutableArray *showList;
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) BOOL isSearch;
@property(nonatomic, strong) NSString *searchContent;
@end

@implementation PGroupBlackViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群黑名单";
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
    
    [self.tableView reloadData];
    
    [self initData];
}

- (void)initData{
    if (!self.dataList) {
        self.dataList = [[NSMutableArray alloc] init];
    }
    if (!self.showList) {
        self.showList = [[NSMutableArray alloc] init];
    }
    [self.dataList removeAllObjects];
    [self.showList removeAllObjects];
    [self requestData];
}

- (void)searchUser:(NSString *)content{
    self.searchContent = content;
    [self.showList removeAllObjects];
    for (FFriendModel *user in self.dataList) {
        if ([user.name.lowercaseString containsString:content.lowercaseString] ) {
            [self.showList addObject:user];
        }
    }
    [self.tableView reloadData];
}

- (void)requestData{
    @weakify(self)
    [self.dataList removeAllObjects];
    [self.showList removeAllObjects];
    NSDictionary *params = @{@"groupId":self.model.groupId};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/groupBlackList" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            for (NSDictionary *data in response[@"data"]) {
                [self.dataList addObject:[FFriendModel modelWithDictionary:data]];
                [self.showList addObject:[FFriendModel modelWithDictionary:data]];
            }
            [weak_self.tableView reloadData];
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
    return self.showList.count;
    
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
    cell.isGroup = YES;
    [cell refreshCellWithModel:[self.showList objectAtIndex:indexPath.row]];
    @weakify(self)
    cell.removeBlackBlock = ^{
        [weak_self removeBlack:[weak_self.showList objectAtIndex:indexPath.row] index:indexPath.row];
    };
    return cell;
    
}

- (void)removeBlack:(FFriendModel*)model index:(NSInteger)index{
    NSDictionary *params = @{@"userId":model.userId, @"groupId":self.model.groupId};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/addDeleteBlack" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [weak_self.showList removeObjectAtIndex:index];
            for (NSInteger i=0; i<weak_self.dataList.count; i++) {
                FFriendModel *tempModel = [weak_self.dataList objectAtIndex:i];
                if (tempModel.userId == model.userId) {
                    [weak_self.dataList removeObjectAtIndex:i];
                    break;
                }
            }
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
