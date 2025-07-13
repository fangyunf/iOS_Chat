//
//  SWSearchViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWSearchViewController.h"
#import "SWSearchView.h"
#import "SWBlackListCell.h"

@interface SWSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) SWSearchView *searchView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, assign) BOOL isSearch;
@property(nonatomic, strong) NSString *searchContent;
@property (nonatomic,strong) NSMutableArray *searchList;
@end

@implementation SWSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
//    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
//    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索";
    self.navTopView.hidden = YES;
    
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
        [weak_self.tableView reloadData];
    };
    [self.view addSubview:self.searchView];
    
    [self.tableView reloadData];
    
    [self initData];
}

- (void)initData{
    self.dataList = [NSMutableArray arrayWithArray:[FUserRelationManager sharedManager].allFriends];
    self.searchList = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
}

- (void)searchUser:(NSString *)content{
    [self.searchList removeAllObjects];
    for (FFriendModel *user in self.dataList) {
        if ([user.name.lowercaseString matchSearch:content.lowercaseString] || [user.remark.lowercaseString matchSearch:content.lowercaseString]) {
            [self.searchList addObject:user];
        }
       
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        return self.searchList.count;
    }
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
    cell.addBtn.hidden = YES;
    cell.removeBtn.hidden = YES;
    if (self.isSearch) {
        [cell refreshCellWithModel:[self.searchList objectAtIndex:indexPath.row]];
    }else{
        [cell refreshCellWithModel:[self.dataList objectAtIndex:indexPath.row]];
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

@end

