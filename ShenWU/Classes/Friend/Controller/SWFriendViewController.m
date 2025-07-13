//
//  SWFriendViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/19.
//

#import "SWFriendViewController.h"
#import "SCIndexView.h"
#import "FFriendCell.h"
#import "SWFriendHeaderView.h"
#import "SWFriendInfoViewController.h"
#import "SWMessageDetaillViewController.h"
#import "SWSearchView.h"
#import "SWNewFriendCell.h"
@interface SWFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *friendTableView;
@property(nonatomic, strong) UITableView *groupTableView;
@property(nonatomic, strong) UITableView *addFriendTableView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) NSMutableArray *searchList;
@property(nonatomic, strong) UIView *redPointView;
@property(nonatomic, strong) SWSearchView *searchView;
@property(nonatomic, strong) UIButton *friendBtn;
@property(nonatomic, strong) UIButton *groupBtn;
@property(nonatomic, strong) UIButton *addFriendBtn;
@property(nonatomic, strong) UILabel *addFriendLabel;
@property(nonatomic, strong) UIImageView *selectImgView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) BOOL isSearch;
@property(nonatomic, assign) NSInteger selectIndex;
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, strong) NSString *searchContent;
@end

@implementation SWFriendViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
    self.navigationController.navigationBar.titleTextAttributes = attribute;
    
    self.navigationController.navigationBarHidden = YES;
    @weakify(self);
    [[FUserRelationManager sharedManager] reloadAllFriendsData:^(BOOL success) {
        [weak_self.friendTableView reloadData];
    }];
    [[FMessageManager sharedManager] requestApplyListNum];
    [[FMessageManager sharedManager] refreshUnRead];
    [self refreshUnReadCount];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBarHidden = YES;
    
    self.searchList = [[NSMutableArray alloc] init];
    self.dataList = [[NSMutableArray alloc] init];
    
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    topImgView.image = [UIImage imageNamed:@"bg_main"];
    topImgView.contentMode = UIViewContentModeScaleAspectFill;
    topImgView.userInteractionEnabled = YES;
    [self.view addSubview:topImgView];
    
    UIImageView *titleImgView = [[UIImageView alloc] init];
    titleImgView.frame = CGRectMake(14, kStatusHeight+9, 106, 26);
    titleImgView.image = [UIImage imageNamed:@"icn_contact_title"];
    [self.view addSubview:titleImgView];
    
//    UILabel *titleLabel = [FControlTool createLabel:@"通讯录" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:21]];
//    titleLabel.frame = CGRectMake(14, kStatusHeight, kScreenWidth - 28, 44);
//    [self.view addSubview:titleLabel];
    
    self.searchView = [[SWSearchView alloc] initWithFrame:CGRectMake(16, titleImgView.bottom+13, kScreenWidth - 32, 40)];
    self.searchView.placeholder = @"搜索";
    @weakify(self)
    self.searchView.searchBlock = ^(NSString * _Nonnull content) {
        [weak_self searchContent:content];
    };
    self.searchView.searchBlock = ^(NSString * _Nonnull content) {
        weak_self.isSearch = YES;
        [weak_self searchContent:content];
    };
    self.searchView.endSearchBlock = ^{
        weak_self.isSearch = NO;
        weak_self.searchContent = @"";
        [weak_self searchContent:@""];
    };
    [self.view addSubview:self.searchView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, self.searchView.bottom+6, kScreenWidth, kScreenHeight-(self.searchView.bottom+6) - kTabBarHeight);
    [bgView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(40, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    self.selectImgView = [[UIImageView alloc] init];
    self.selectImgView.frame = CGRectMake((kScreenWidth/3 -66)/2,  self.searchView.bottom+45, 66, 9);
    self.selectImgView.backgroundColor = RGBColor(0xE3F4AD);
    self.selectImgView.layer.cornerRadius = 4.5;
    self.selectImgView.layer.masksToBounds = YES;
    [self.view addSubview:self.selectImgView];
    
    self.friendBtn = [FControlTool createButton:@"好友列表" font:[UIFont boldFontWithSize:18] textColor:RGBColor(0x666666) target:self sel:@selector(friendBtnAction)];
    self.friendBtn.frame = CGRectMake(0, self.searchView.bottom+16, kScreenWidth/3, 44);
    [self.friendBtn setTitleColor:kMainColor forState:UIControlStateSelected];
    self.friendBtn.selected = YES;
    [self.view addSubview:self.friendBtn];
    
    self.groupBtn = [FControlTool createButton:@"群组列表" font:[UIFont boldFontWithSize:18] textColor:RGBColor(0x666666) target:self sel:@selector(groupBtnAction)];
    self.groupBtn.frame = CGRectMake(kScreenWidth/3, self.searchView.bottom+16, kScreenWidth/3, 44);
    [self.groupBtn setTitleColor:kMainColor forState:UIControlStateSelected];
    [self.view addSubview:self.groupBtn];
    
    self.addFriendBtn = [FControlTool createButton:@"新的好友" font:[UIFont boldFontWithSize:18] textColor:RGBColor(0x666666) target:self sel:@selector(addFriendBtnAction)];
    self.addFriendBtn.frame = CGRectMake(kScreenWidth/3*2, self.searchView.bottom+16, kScreenWidth/3, 44);
    [self.addFriendBtn setTitleColor:kMainColor forState:UIControlStateSelected];
    [self.view addSubview:self.addFriendBtn];
    
    self.addFriendLabel = [FControlTool createLabel:@"99+" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:12]];
    self.addFriendLabel.frame = CGRectMake(kScreenWidth - 33, self.searchView.bottom+16+13, 22, 18);
    self.addFriendLabel.layer.cornerRadius = 9;
    self.addFriendLabel.layer.masksToBounds = YES;
    self.addFriendLabel.textAlignment = NSTextAlignmentCenter;
    self.addFriendLabel.backgroundColor = RGBColor(0xFF0000);
    [self.view addSubview:self.addFriendLabel];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, self.friendBtn.bottom, kScreenWidth, kScreenHeight - self.friendBtn.bottom - kTabBarHeight);
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*3, kScreenHeight - self.friendBtn.bottom - kTabBarHeight);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.friendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.scrollView.height) style:UITableViewStylePlain];
    self.friendTableView.delegate = self;
    self.friendTableView.dataSource = self;
    self.friendTableView.backgroundColor = [UIColor whiteColor];
    self.friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.friendTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.friendTableView.estimatedRowHeight = 0;
    self.friendTableView.estimatedSectionFooterHeight = 0;
    self.friendTableView.estimatedSectionHeaderHeight = 0;
    self.friendTableView.showsVerticalScrollIndicator = NO;
    self.friendTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    [self.scrollView addSubview:self.friendTableView];
    
    self.groupTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.scrollView.height) style:UITableViewStylePlain];
    self.groupTableView.delegate = self;
    self.groupTableView.dataSource = self;
    self.groupTableView.backgroundColor = [UIColor whiteColor];
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.groupTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.groupTableView.estimatedRowHeight = 0;
    self.groupTableView.estimatedSectionFooterHeight = 0;
    self.groupTableView.estimatedSectionHeaderHeight = 0;
    self.groupTableView.showsVerticalScrollIndicator = NO;
    self.groupTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    [self.scrollView addSubview:self.groupTableView];
    
    self.addFriendTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, self.scrollView.height) style:UITableViewStylePlain];
    self.addFriendTableView.delegate = self;
    self.addFriendTableView.dataSource = self;
    self.addFriendTableView.backgroundColor = [UIColor whiteColor];
    self.addFriendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addFriendTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.addFriendTableView.estimatedRowHeight = 0;
    self.addFriendTableView.estimatedSectionFooterHeight = 0;
    self.addFriendTableView.estimatedSectionHeaderHeight = 0;
    self.addFriendTableView.showsVerticalScrollIndicator = NO;
    self.addFriendTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    self.addFriendTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.addFriendTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.scrollView addSubview:self.addFriendTableView];

    [self refreshUnReadCount];
    [self refreshData];

    [[FUserRelationManager sharedManager] reloadAllFriendsData:^(BOOL success) {
        [weak_self.friendTableView reloadData];
    }];
    
    [[FUserRelationManager sharedManager] reloadAllGroupsData:^(BOOL success) {
        [weak_self.groupTableView reloadData];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnReadCount) name:FRefreshUnReadCount object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:FRefreshFriendList object:nil];
}

- (void)refreshUnReadCount{
    if ([FMessageManager sharedManager].friendNum > 0) {
        self.addFriendLabel.hidden = NO;
        self.addFriendLabel.text = [NSString stringWithFormat:@"%ld",[FMessageManager sharedManager].friendNum];
    }else{
        self.addFriendLabel.hidden = YES;
    }
}

- (void)initData{
    self.dataList = [[NSMutableArray alloc] init];
    self.searchList = [[NSMutableArray alloc] init];
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
            FFriendApplyListModel *applyModel = [FFriendApplyListModel modelWithDictionary:response[@"data"]];
            for (FFriendApplyModel *model in applyModel.data) {
                [self.dataList addObject:model];
            }
            [weak_self.addFriendTableView reloadData];
            weak_self.pageNum = applyModel.pageNum;
            if (applyModel.total == weak_self.dataList.count) {
                weak_self.addFriendTableView.mj_footer = nil;
            }else{
                weak_self.addFriendTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }
        }
        
        [weak_self.addFriendTableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [weak_self.addFriendTableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
    @weakify(self)
    self.pageNum++;
    NSDictionary *params = @{@"pageNo":[NSNumber numberWithInteger:self.pageNum]};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/applyList" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            FFriendApplyListModel *applyModel = [FFriendApplyListModel modelWithDictionary:response[@"data"]];
            for (FFriendApplyModel *model in applyModel.data) {
                [self.dataList addObject:model];
            }
            [weak_self.addFriendTableView reloadData];
        }
        
        [weak_self.addFriendTableView.mj_footer endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [weak_self.addFriendTableView.mj_footer endRefreshing];
    }];
}

- (void)friendBtnAction{
    [self.searchView endSearchContent];
    self.friendBtn.selected = YES;
    self.groupBtn.selected = NO;
    self.addFriendBtn.selected = NO;
    self.selectImgView.left = (kScreenWidth/3 -66)/2;
    self.selectIndex = 0;
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)groupBtnAction{
    [self.searchView endSearchContent];
    self.friendBtn.selected = NO;
    self.groupBtn.selected = YES;
    self.addFriendBtn.selected = NO;
    self.selectImgView.left = (kScreenWidth/3 -66)/2+kScreenWidth/3;
    self.selectIndex = 1;
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
}

- (void)addFriendBtnAction{
    [self.searchView endSearchContent];
    self.friendBtn.selected = NO;
    self.groupBtn.selected = NO;
    self.addFriendBtn.selected = YES;
    self.selectImgView.left = (kScreenWidth/3 -66)/2+kScreenWidth/3*2;
    self.selectIndex = 2;
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth*2, 0)];
    
    [FMessageManager sharedManager].friendNum = 0;
    [[FMessageManager sharedManager] refreshUnRead];
}

- (void)searchContent:(NSString*)content{
    
    if (self.selectIndex == 0) {
        [self.searchList removeAllObjects];
        for (FFriendModel *model in [FUserRelationManager sharedManager].allFriends) {
            if ([model.name containsString:content] || [model.remark containsString:content]) {
                [self.searchList addObject:model];
            }
        }
        [self.friendTableView reloadData];
    }else if (self.selectIndex == 1) {
        [self.searchList removeAllObjects];
        for (FGroupModel *model in [FUserRelationManager sharedManager].allGroups) {
            if ([model.name containsString:content]) {
                [self.searchList addObject:model];
            }
        }
        [self.groupTableView reloadData];
    }else{
        [self.searchList removeAllObjects];
        for (FFriendApplyModel *model in self.dataList) {
            if ([model.name containsString:content]) {
                [self.searchList addObject:model];
            }
        }
        [self.addFriendTableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.scrollView]) {
        NSInteger index = scrollView.contentOffset.x/kScreenWidth;
        self.selectIndex = index;
        if (index == 0) {
            self.friendBtn.selected = YES;
            self.groupBtn.selected = NO;
            self.addFriendBtn.selected = NO;
            self.selectImgView.left = (kScreenWidth/3 -66)/2;
        }else if (index == 1) {
            self.friendBtn.selected = NO;
            self.groupBtn.selected = YES;
            self.addFriendBtn.selected = NO;
            self.selectImgView.left = (kScreenWidth/3 -66)/2+kScreenWidth/3;
        }else{
            self.friendBtn.selected = NO;
            self.groupBtn.selected = NO;
            self.addFriendBtn.selected = YES;
            self.selectImgView.left = (kScreenWidth/3 -66)/2+kScreenWidth/3*2;
            [FMessageManager sharedManager].friendNum = 0;
            [[FMessageManager sharedManager] refreshUnRead];
        }
        [self.searchView endSearchContent];
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.friendTableView]) {
        if(self.isSearch){
            return self.searchList.count;
        }else{
            return [FUserRelationManager sharedManager].allFriends.count;
        }
        
    }else if ([tableView isEqual:self.groupTableView]) {
        if(self.isSearch){
            return self.searchList.count;
        }else{
            return [FUserRelationManager sharedManager].allGroups.count;
        }
    }else{
        if(self.isSearch){
            return self.searchList.count;
        }else{
            return self.dataList.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.friendTableView]) {
        static NSString *cellId = @"cellId";
        FFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[FFriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        FFriendModel *user = nil;
        if(self.isSearch){
            user = [self.searchList objectAtIndex:indexPath.row];
        }else{
            user = [[FUserRelationManager sharedManager].allFriends objectAtIndex:indexPath.row];
        }
        if (user.remark.length > 0) {
            cell.nameLabel.text = user.remark;
        }else{
            cell.nameLabel.text = user.name;
        }
        [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
        return cell;
    }else if ([tableView isEqual:self.groupTableView]) {
        static NSString *cellId = @"cellId";
        FFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[FFriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        FGroupModel *group = nil;
        if(self.isSearch){
            group = [self.searchList objectAtIndex:indexPath.row];
        }else{
            group = [[FUserRelationManager sharedManager].allGroups objectAtIndex:indexPath.row];
        }
        cell.nameLabel.text = group.name;
        [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:group.head] placeholderImage:[UIImage imageNamed:@"avatar_group"]];
        return cell;
    }else{
        static NSString *cellId = @"cellId";
        SWNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SWNewFriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        FFriendApplyModel *model = nil;
        if(self.isSearch){
            model = [self.searchList objectAtIndex:indexPath.row];
        }else{
            model = [self.dataList objectAtIndex:indexPath.row];
        }
        [cell refreshCellWithData:model];
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.friendTableView]) {
        FFriendModel *user = nil;
        if(self.isSearch){
            user = [self.searchList objectAtIndex:indexPath.row];
        }else{
            user = [[FUserRelationManager sharedManager].allFriends objectAtIndex:indexPath.row];
        }
        SWFriendInfoViewController *vc = [[SWFriendInfoViewController alloc] init];
        vc.user = user;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([tableView isEqual:self.groupTableView]) {
        FGroupModel *group = nil;
        if(self.isSearch){
            group = [self.searchList objectAtIndex:indexPath.row];
        }else{
            group = [[FUserRelationManager sharedManager].allGroups objectAtIndex:indexPath.row];
        }
        SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = NIMSessionTypeTeam;
        vc.sessionId = group.groupId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//
//#pragma mark - Getter
//
//- (UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight - kTabBarHeight) style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.backgroundColor = RGBColor(0xf2f2f2);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
