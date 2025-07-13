//
//  TKAddressBookViewController.m
//  ShenWU
//
//  Created by Amy on 2024/10/4.
//

#import "TKAddressBookViewController.h"
#import "SWNotiScrollView.h"
#import "SWSearchView.h"
#import "TKNotiyViewController.h"
#import "PMessageHomeMoreView.h"
#import "ScanHelper.h"
#import "SCIndexView.h"
#import "SWFriendInfoViewController.h"
#import "SWAddFriendViewController.h"
#import "FContactPersonCell.h"
#import "SWFriendInfoViewController.h"
#import "SWMyGroupsViewController.h"
#import "SWNewFriendViewController.h"
#import "FMoreActionView.h"
#import "SWBlackListViewController.h"
#import "SWMessageDetaillViewController.h"
@interface TKAddressBookViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) SWSearchView *searchView;
@property(nonatomic, strong) UILabel *redPointView;
@property(nonatomic, strong) SWNotiScrollView *notiView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic,strong) NSArray *titlesArray;
@property (nonatomic,strong) NSMutableDictionary *mdic;
@property (nonatomic,strong) SCIndexView *indexView;
@property(nonatomic, assign) BOOL isSearch;
@property(nonatomic, strong) NSString *searchContent;
@property(nonatomic, strong) FMoreActionView *moreView;
@end

@implementation TKAddressBookViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
    self.navTopView.hidden = YES;
    self.navTopView.backgroundColor = RGBColor(0xFF6004);
    
    UIImageView *topBgImgView = [FControlTool createImageView];
    topBgImgView.frame = CGRectMake(0, 0, kScreenWidth, 267*kScale);
    topBgImgView.image = [UIImage imageNamed:@"bg_common_top"];
    [self.view addSubview:topBgImgView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"通讯录" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:24]];
    titleLabel.frame = CGRectMake(16, kStatusHeight+7, kScreenWidth - 32, 30);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLabel];
    
    self.view.backgroundColor = RGBColor(0xF5F7FA);
    
    self.searchView = [[SWSearchView alloc] initWithFrame:CGRectMake(16, self.navTopView.bottom+10, kScreenWidth - 32, 48)];
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
        [weak_self.searchList removeAllObjects];
        [weak_self refreshData:weak_self.dataList];
    };
    [self.view addSubview:self.searchView];
    
    UIButton *moreBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_friend_add"] target:self sel:@selector(moreBtnAction)];
    moreBtn.frame = CGRectMake(kScreenWidth - 61, kStatusHeight, 44, 44);
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:moreBtn];
    
    UIButton *notiBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_friend_msg_noti"] target:self sel:@selector(notiBtnAction)];
    notiBtn.frame = CGRectMake(moreBtn.left - 27, kStatusHeight, 44, 44);
    notiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:notiBtn];
    
    self.redPointView = [FControlTool createLabel:@"99+" textColor:UIColor.whiteColor font:[UIFont fontWithSize:10]];
    self.redPointView.frame = CGRectMake(moreBtn.left - 13, kStatusHeight+6, 24, 12);
    self.redPointView.backgroundColor = RGBAlphaColor(0xFF0000, 0.8);
    self.redPointView.layer.cornerRadius = 6;
    self.redPointView.layer.masksToBounds = YES;
    self.redPointView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.redPointView];
    
    self.notiView = [[SWNotiScrollView alloc] initWithFrame:CGRectMake(10, self.searchView.bottom, kScreenWidth - 20, 0)];
    self.notiView.backgroundColor = RGBAlphaColor(0x8F55FF, 0.08);
    self.notiView.hidden = YES;
    [self.view addSubview:self.notiView];
    
    SCIndexViewConfiguration *indexViewConfiguration = [SCIndexViewConfiguration configuration];
    indexViewConfiguration.indexItemSelectedBackgroundColor = UIColor.clearColor;
    indexViewConfiguration.indicatorTextFont = [UIFont fontWithSize:20];
    indexViewConfiguration.indicatorTextColor = [UIColor whiteColor];
    indexViewConfiguration.indicatorHeight = 40;
    indexViewConfiguration.indexItemTextColor = RGBColor(0x666666);
    indexViewConfiguration.indexItemSelectedTextColor = RGBColor(0x666666);
    self.indexView = [[SCIndexView alloc] initWithTableView:self.tableView configuration:indexViewConfiguration];
    self.indexView.translucentForTableViewInNavigationBar = YES;
    
    [self.view addSubview:self.indexView];
    
    [self refreshUnReadCount];
    
    [[FUserRelationManager sharedManager] reloadAllFriendsData:^(BOOL success) {
        [self initData];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnreadCount) name:FRefreshUnReadCount object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:FRefreshFriendList object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnReadCount) name:FRefreshUnReadCount object:nil];
}

- (void)refreshUnReadCount{
    NIMSession *sysSession = [NIMSession session:[FUserModel sharedUser].userID type:NIMSessionTypeP2P];
    NIMRecentSession *sysRecent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:sysSession];
    if ([FMessageManager sharedManager].groupNum > 0 || sysRecent.unreadCount > 0 || [FMessageManager sharedManager].sysNotiNum > 0) {
        self.redPointView.hidden = NO;
        self.redPointView.text = [FDataTool getUnreadCount:[FMessageManager sharedManager].groupNum+sysRecent.unreadCount+[FMessageManager sharedManager].sysNotiNum];
    }else{
        self.redPointView.hidden = YES;
    }
}

- (void)initData{
    self.dataList = [[NSMutableArray alloc] init];
    self.searchList = [[NSMutableArray alloc] init];
    for (FFriendModel *model in [FUserRelationManager sharedManager].allFriends) {
        if (![model.userId isEqualToString:[FMessageManager sharedManager].serviceUserId]) {
            [self.dataList addObject:model];
        }
    }
    if (self.dataList.count == 0) {
        [self.tableView showEmptyWtihFrame:CGRectMake(0, 0, kScreenWidth, self.tableView.height*0.8) imageName:@"icn_no_person" title:@"暂无联系人"];
        self.titlesArray = nil;
        self.mdic = nil;
        [self.tableView reloadData];
        return;
    }
    [self.tableView hiddenEmpty];
    [self refreshData:self.dataList];
}

- (void)getUnreadCount{
    [self.tableView reloadData];
}


- (void)refreshData:(NSMutableArray *)list{
    
    NSArray *array = [self getOrderArraywithArray:list];

    NSMutableDictionary *mDic = [NSMutableDictionary new];
    self.mdic = mDic;

    for (FFriendModel *user in array) {
        // 将中文转换为拼音
        NSString *nickName = [NSMutableString stringWithString:user.name];
        if (user.remark.length > 0) {
            nickName = [NSMutableString stringWithString:user.remark];
        }
        CFStringTransform((__bridge CFMutableStringRef)nickName, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)nickName, NULL, kCFStringTransformStripCombiningMarks, NO);
        // 拿到首字母作为key
        NSString *firstLetter = [[nickName uppercaseString]substringToIndex:1];
        // 检查是否有firstLetter对应的分组存在, 有的话直接把city添加到对应的分组中
        // 没有的话, 新建一个以firstLetter为key的分组

        if ([mDic objectForKey:firstLetter]) {
            NSMutableArray * userArray = mDic[firstLetter];
            if (userArray) {
                [userArray addObject:@{@"nickName":nickName,@"user":user}];
                mDic[firstLetter] = userArray;
            }else{
                mDic[firstLetter] = [NSMutableArray arrayWithArray:@[@{@"nickName":nickName,@"user":user}]];
            }
        }else{
            [mDic setObject:[NSMutableArray arrayWithArray:@[@{@"nickName":nickName,@"user":user}]] forKey:firstLetter];
        }

    }
    self.titlesArray = [self reqDiction:mDic];
    self.indexView.dataSource = self.titlesArray;
    [self.tableView reloadData];
}

- (void)moreBtnAction{
//    PMessageHomeMoreView *view = [[PMessageHomeMoreView alloc] initWithFrame:self.view.bounds];
//    view.scanBlock = ^{
//        [self scanAction];
//    };
//    [[FControlTool keyWindow] addSubview:view];
    
    self.moreView = [[FMoreActionView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kStatusBarHeight)];
    [self.view addSubview:self.moreView];
}

- (void)scanAction{
    @weakify(self);
    __block ScanQRViewController *scanVc = [[ScanHelper shareInstance] scanVCWithStyle:qqStyle qrResultCallBack:^(id result) {
        @strongify(self);
        [scanVc.navigationController popViewControllerAnimated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showScanResult:result];
        });
    }];
    [[FControlTool getCurrentVC].navigationController pushViewController:scanVc animated:YES];
}

- (void)notiBtnAction{
    TKNotiyViewController *vc = [[TKNotiyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showScanResult:(NSString *)result{
    
    NSArray *list = [result componentsSeparatedByString:@"."];
    NSDictionary *params = @{@"phoneAndCode":list[1],@"type":@0};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/search" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            NSDictionary *dict = response[@"data"];
            FFriendModel *model = [FFriendModel modelWithDictionary:dict];
            if ([[NIMSDK sharedSDK].userManager isMyFriend:model.userId]) {
                SWFriendInfoViewController *vc = [[SWFriendInfoViewController alloc] init];
                vc.user = model;
                [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
            }else{
                SWAddFriendViewController *vc = [[SWAddFriendViewController alloc] init];
                vc.model = model;
                [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
            }
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)searchContent:(NSString*)content{
    [self.searchList removeAllObjects];
    for (FFriendModel *model in [FUserRelationManager sharedManager].allFriends) {
        if ([model.name matchSearch:content] || [model.remark matchSearch:content]) {
            [self.searchList addObject:model];
        }
    }
    [self refreshData:self.searchList];
}

- (NSArray *)getOrderArraywithArray:(NSArray *)array{
    //数组排序
    //定义一个数字数组
    //对数组进行排序
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(FFriendModel     * _Nonnull obj1, FFriendModel     * _Nonnull obj2) {
        NSString *nickName1 = obj1.name;
        if (obj1.remark.length > 0) {
            nickName1 = obj1.remark;
        }
        NSString *nickName2 = obj2.name;
        if (obj2.remark.length > 0) {
            nickName2 = obj2.remark;
        }
        return [nickName1 compare:nickName2]; //升序
    }];
    return result;
}

//通过取出字典的所有key值，利用sortedArrayUsingComparator进行降序排序
- (NSArray *)reqDiction:(NSDictionary *)dict{
 
    NSArray *allKeyArray = [dict allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];  //[obj1 compare:obj2]：升序
        return resuest;
    }];
    NSLog(@"afterSortKeyArray:%@",afterSortKeyArray);
     
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
 
    return afterSortKeyArray;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titlesArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    NSString * titles = self.titlesArray[section-1];
    return [self.mdic[titles] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellId = @"cellId";
        FContactPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[FContactPersonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = UIColor.whiteColor;
        }
        cell.avatarImgView.frame = CGRectMake(16, 11, 40, 40);
        if (indexPath.row == 2) {
            cell.avatarImgView.image = [UIImage imageNamed:@"icn_mine_kefu"];
            cell.nameLabel.text = @"官方客服";
            cell.numLabel.hidden = YES;
        } else if (indexPath.row == 1) {
            cell.avatarImgView.image = [UIImage imageNamed:@"icn_group_apply"];
            cell.nameLabel.text = @"我的群组";
            cell.numLabel.hidden = YES;
        } else if (indexPath.row == 3) {
            cell.avatarImgView.image = [UIImage imageNamed:@"icn_contact_black"];
            cell.nameLabel.text = @"黑名单";
            cell.numLabel.hidden = YES;
        } else if (indexPath.row == 0) {
            cell.avatarImgView.image = [UIImage imageNamed:@"icn_new_friend"];
            cell.nameLabel.text = @"新的好友";
            if ([FMessageManager sharedManager].friendNum > 0) {
                cell.numLabel.hidden = NO;
                cell.numLabel.text = [NSString stringWithFormat:@"%ld",[FMessageManager sharedManager].friendNum];
            }else{
                cell.numLabel.hidden = YES;
            }
        }
        return cell;
    }
    static NSString *cellId = @"userCellId";
    FContactPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FContactPersonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColor.whiteColor;
        cell.avatarImgView.frame = CGRectMake(16, 11, 40, 40);
    }
    NSString * titles = self.titlesArray[indexPath.section-1];
    FFriendModel *user = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
    if (user.remark.length > 0) {
        cell.nameLabel.text = user.remark;
    }else{
        cell.nameLabel.text = user.name;
    }
    [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0;
    }
    return 28;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return nil;
    }
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenWidth, 28);
    view.backgroundColor = RGBColor(0xF6F6F6);
    
    UILabel *titleLabel = [FControlTool createLabel:self.titlesArray[section-1] textColor:RGBColor(0x666666) font:[UIFont boldFontWithSize:14]];
    titleLabel.frame = CGRectMake(16, 0, kScreenWidth - 32, 28);
    [view addSubview:titleLabel];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SWNewFriendViewController *vc = [[SWNewFriendViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [FMessageManager sharedManager].friendNum = 0;
            [self.tableView reloadData];
        }else if (indexPath.row == 1) {
            SWMyGroupsViewController *vc = [[SWMyGroupsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2) {
            SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.type = NIMSessionTypeP2P;
            vc.sessionId = [FMessageManager sharedManager].serviceUserId;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            SWBlackListViewController *vc = [[SWBlackListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        NSString * titles = self.titlesArray[indexPath.section-1];
        FFriendModel *user = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
        SWFriendInfoViewController *vc = [[SWFriendInfoViewController alloc] init];
        vc.user = user;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.notiView.bottom+10, kScreenWidth, kScreenHeight-(self.notiView.bottom+10) - kTabBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = RGBColor(0xE1E1E1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 67, 0, 0);
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
