//
//  SWSelectUserViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/24.
//

#import "SWSelectUserViewController.h"
#import "SWSearchView.h"
#import "SWSelectUserCell.h"
#import "SCIndexView.h"
#import "PGroupUpgradeTipView.h"
@interface SWSelectUserViewController ()<UITableViewDelegate,UITableViewDataSource,SWSelectUserCellDelegate>
@property(nonatomic, strong) SWSearchView *searchView;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titlesArray;
@property (nonatomic,strong) NSMutableDictionary *mdic;
@property (nonatomic,strong) SCIndexView *indexView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property(nonatomic, assign) BOOL isSearch;
@property(nonatomic, strong) NSString *searchContent;
@property (nonatomic,strong) NSMutableArray *searchList;
@property (nonatomic,strong) NSString *selectUserId;
@end

@implementation SWSelectUserViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == SelectFriendTypeCommon) {
        self.title = @"选择好友";
        self.dataList = [NSMutableArray array];
        for (FFriendModel *model in [FUserRelationManager sharedManager].allFriends) {
            if (![model.userId isEqualToString:self.userId]) {
                model.isSelected = NO;
                [self.dataList addObject:model];
            }
        }
    }else if(self.type == SelectFriendTypeGroupAdd){
        self.title = @"选择联系人";
        self.dataList = [NSMutableArray array];
        for (FFriendModel *model in [FUserRelationManager sharedManager].allFriends) {
            model.isGroupSelected = NO;
            model.isSelected = NO;
            [self.dataList addObject:model];
        }
    }else if(self.type == SelectFriendTypeGroupDelete){
        self.title = @"选择联系人";
        self.dataList = [NSMutableArray arrayWithArray:self.groupModel.members];
    }else if(self.type == SelectFriendTypeProhibit){
        self.dataList = [NSMutableArray array];
        for (FGroupUserInfoModel *model in self.groupModel.members) {
            [self.dataList addObject:model];
        }
        self.title = @"禁止领取红包";
    }else{
        self.dataList = [NSMutableArray array];
        for (FGroupUserInfoModel *model in self.groupModel.members) {
            [self.dataList addObject:model];
        }
        self.title = @"发送给";
    }
    
    self.searchList = [[NSMutableArray alloc] init];
    
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
        [weak_self refreshData:weak_self.dataList];
    };
    [self.view addSubview:self.searchView];
    
    [self refreshData:self.dataList];
    
    SCIndexViewConfiguration *indexViewConfiguration = [SCIndexViewConfiguration configuration];
    indexViewConfiguration.indexItemSelectedBackgroundColor = UIColor.clearColor;
    indexViewConfiguration.indicatorTextFont = [UIFont fontWithSize:20];
    indexViewConfiguration.indicatorTextColor = [UIColor whiteColor];
    indexViewConfiguration.indicatorHeight = 40;
    indexViewConfiguration.indexItemTextColor = RGBColor(0x8B5FD8);
    indexViewConfiguration.indexItemSelectedTextColor = RGBColor(0x8B5FD8);
    self.indexView = [[SCIndexView alloc] initWithTableView:self.tableView configuration:indexViewConfiguration];
    self.indexView.translucentForTableViewInNavigationBar = YES;
    
    self.indexView.dataSource = self.titlesArray;
    
    [self.view addSubview:self.indexView];
    
    if (self.type == SelectFriendTypeCommon) {
        UIButton *sendBtn = [FControlTool createCommonButtonWithText:@"立即发送" target:self sel:@selector(sendBtnAction)];
        sendBtn.frame = CGRectMake(37, kScreenHeight - 84, kScreenWidth - 74, 44);
        [self.view addSubview:sendBtn];
    }else if(self.type == SelectFriendTypeGroupDelete || self.type == SelectFriendTypeGroupAdd || self.type == SelectFriendTypeProhibit){
        UIButton *sendBtn = [FControlTool createCommonButtonWithText:@"确定" target:self sel:@selector(sendBtnAction)];
        sendBtn.frame = CGRectMake(37, kScreenHeight - 84, kScreenWidth - 74, 44);
        [self.view addSubview:sendBtn];
    }
}

- (void)setSelectData:(NSArray *)selectData{
    _selectData = selectData;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (ChatTeamMemberInfoModel *infoModel in selectData) {
        if (![infoModel.nimUser.userId isEqualToString:[FUserModel sharedUser].userID]) {
            FGroupUserInfoModel *model = [[FGroupUserInfoModel alloc] init];
            model.userId = infoModel.nimUser.userId;
            model.avatar = infoModel.nimUser.userInfo.avatarUrl;
            model.name = infoModel.nimUser.userInfo.nickName;
            [arr addObject:model];
        }
    }
    self.groupModel.members = arr;
}

- (void)setGroupModel:(FGroupModel *)groupModel{
    _groupModel = groupModel;
    if (self.type != SelectFriendTypeProhibit) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (FGroupUserInfoModel *model in self.groupModel.members) {
            if (![model.userId isEqualToString:[FUserModel sharedUser].userID]) {
                [list addObject:model];
            }
        }
        _groupModel.members = list;
    }
}

- (void)refreshData:(NSMutableArray*)list{
    NSArray *array = [self getOrderArraywithArray:list];

    NSMutableDictionary *mDic = [NSMutableDictionary new];
    self.mdic = mDic;

    for (id item in array) {
        NSString *nickName = @"";
        if ([item isKindOfClass:[FGroupUserInfoModel class]]) {
            FGroupUserInfoModel *user = item;
            nickName = [NSMutableString stringWithString:user.name];
        }else{
            FFriendModel *user = item;
            nickName = [NSMutableString stringWithString:user.name];
            if (user.remark.length > 0) {
                nickName = [NSMutableString stringWithString:user.remark];
            }
            if (self.type != SelectFriendTypeCommon) {
                for (FGroupUserInfoModel *model in self.groupModel.members) {
                    if ([user.userId isEqualToString:model.userId]) {
                        user.isGroupSelected = YES;
                        NSLog(@"user ==== :%@",user.name);
                        break;
                    }
                }
            }
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
                [userArray addObject:@{@"nickName":nickName,@"user":item}];
                mDic[firstLetter] = userArray;
            }else{
                mDic[firstLetter] = [NSMutableArray arrayWithArray:@[@{@"nickName":nickName,@"user":item}]];
            }
        }else{
            [mDic setObject:[NSMutableArray arrayWithArray:@[@{@"nickName":nickName,@"user":item}]] forKey:firstLetter];
        }

    }
    self.titlesArray = [self reqDiction:mDic];
    self.indexView.dataSource = self.titlesArray;
    [self.tableView reloadData];
}

- (void)searchUser:(NSString *)content{
    [self.searchList removeAllObjects];
    for (id item in self.dataList) {
        if ([item isKindOfClass:[FFriendModel class]]) {
            FFriendModel *user = item;
            if ([user.name.lowercaseString containsString:content.lowercaseString] || [user.remark.lowercaseString containsString:content.lowercaseString]) {
                [self.searchList addObject:user];
            }
        }else{
            FGroupUserInfoModel *user = item;
            if ([user.name.lowercaseString containsString:content.lowercaseString]) {
                [self.searchList addObject:user];
            }
        }
       
    }
    [self refreshData:self.searchList];
    [self.tableView reloadData];
}

- (void)sendBtnAction{
    if (self.type == SelectFriendTypeGroupAdd) {
        NSMutableArray *selectList = [[NSMutableArray alloc] init];
        for (FFriendModel *model in self.dataList) {
            if (model.isSelected) {
                [selectList addObject:model.userId];
            }
        }
        if (selectList.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择好友"];
            return;
        }
        NSDictionary *params = @{@"members":selectList, @"groupId":self.groupModel.groupId};
        @weakify(self)
        [SVProgressHUD show];
        [[FNetworkManager sharedManager] postRequestFromServer:@"/group/pullPeopleGroup" parameters:params success:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"邀请成功"];
                if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(reloadGroupMember)]) {
                    [weak_self.delegate reloadGroupMember];
                }
                [weak_self.navigationController popViewControllerAnimated:YES];
            }else if ([response[@"code"] integerValue] == 588) {
                PGroupUpgradeTipView *view = [[PGroupUpgradeTipView alloc] initWithFrame:self.view.bounds];
                view.model = self.groupModel;
                [[FControlTool keyWindow] addSubview:view];
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }else if (self.type == SelectFriendTypeGroupDelete) {
        NSMutableArray *selectList = [[NSMutableArray alloc] init];
        for (FGroupUserInfoModel *model in self.dataList) {
            if (model.isSelected) {
                [selectList addObject:model.userId];
            }
        }
        if (selectList.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择好友"];
            return;
        }
        NSDictionary *params = @{@"members":selectList, @"groupId":self.groupModel.groupId};
        @weakify(self)
        [SVProgressHUD show];
        [[FNetworkManager sharedManager] postRequestFromServer:@"/group/outGroup" parameters:params success:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"移出成功"];
                if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(reloadGroupMember)]) {
                    [weak_self.delegate reloadGroupMember];
                }
                [weak_self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }else if(self.type == SelectFriendTypeCommon){
        NSMutableArray *selectList = [[NSMutableArray alloc] init];
        FFriendModel *userModel = nil;
        for (FFriendModel *model in self.dataList) {
            if (model.isSelected) {
                [selectList addObject:model.userId];
                userModel = model;
            }
        }
        if (selectList.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择好友"];
            return;
        }
        if (self.groupModel) {
            [[FMessageManager sharedManager] sendUserCardWithSessionId:self.groupModel.groupId model:userModel type:2];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if(self.userModel){
            [[FMessageManager sharedManager] sendUserCardWithSessionId:selectList.firstObject model:self.userModel type:1];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[FMessageManager sharedManager] sendUserCardWithSessionId:self.userId model:userModel type:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if(self.type == SelectFriendTypeProhibit){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSArray *)getOrderArraywithArray:(NSArray *)array{
    //数组排序
    //定义一个数字数组
    //对数组进行排序
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(id      _Nonnull obj1, id      _Nonnull obj2) {
        if ([obj1 isKindOfClass:[FFriendModel class]]) {
            FFriendModel *model1 = obj1;
            FFriendModel *model2 = obj2;
            NSString *nickName1 = model1.name;
            if (model1.remark.length > 0) {
                nickName1 = model1.remark;
            }
            NSString *nickName2 = model2.name;
            if (model2.remark.length > 0) {
                nickName2 = model2.remark;
            }
            return [nickName1 compare:nickName2]; //升序
        }else{
            FGroupUserInfoModel *model1 = obj1;
            FGroupUserInfoModel *model2 = obj2;
            NSString *nickName1 = model1.name;
            NSString *nickName2 = model2.name;
            return [nickName1 compare:nickName2]; //升序
        }
        
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

#pragma mark - SWSelectUserCellDelegate
- (void)selectFriend:(SWSelectUserCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString * titles = self.titlesArray[indexPath.section];
    id obj = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
    if ([obj isKindOfClass:[FFriendModel class]]) {
        FFriendModel *user = obj;
        user.isSelected = cell.selectBtn.selected;
        if (self.type == SelectFriendTypeCommon) {
            for (FFriendModel *model in self.dataList) {
                if ([self.selectUserId isEqualToString:model.userId]) {
                    model.isSelected = NO;
                }
            }
            self.selectUserId = user.userId;
            [self.tableView reloadData];
        }
    }else{
        FGroupUserInfoModel *user = obj;
        user.isSelected = cell.selectBtn.selected;
    }
}

- (void)prohibitFriend:(SWSelectUserCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString * titles = self.titlesArray[indexPath.section];
    id obj = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
    if ([obj isKindOfClass:[FGroupUserInfoModel class]]) {
        FGroupUserInfoModel *user = obj;
        user.forbidState = !cell.isProhibit;
        NSDictionary *params = @{@"members":@[user.userId], @"groupId":self.groupModel.groupId,@"state":@(!cell.isProhibit)};
        [SVProgressHUD show];
        [[FNetworkManager sharedManager] postRequestFromServer:@"/groupMember/invitationGroupBanOnLooting" parameters:params success:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
                cell.isProhibit = !cell.isProhibit;
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * titles = self.titlesArray[section];
    return [self.mdic[titles] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWSelectUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWSelectUserCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
    }
    if (self.type == SelectFriendTypeCommon || self.type == SelectFriendTypeGroupDelete || self.type == SelectFriendTypeGroupAdd) {
        cell.selectBtn.hidden = NO;
        
    }else{
        cell.selectBtn.hidden = YES;
        if (self.type == SelectFriendTypeProhibit) {
            NSString * titles = self.titlesArray[indexPath.section];
            id obj = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
            if ([obj isKindOfClass:[FGroupUserInfoModel class]]) {
                FGroupUserInfoModel *user = obj;
                cell.prohibitBtn.hidden = NO;
                cell.isProhibit = user.forbidState;
            }
        }
    }
    
    NSString * titles = self.titlesArray[indexPath.section];
    id obj = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
    if ([obj isKindOfClass:[FFriendModel class]]) {
        FFriendModel *user = obj;
        if (user.remark.length > 0) {
            cell.nameLabel.text = user.remark;
        }else{
            cell.nameLabel.text = user.name;
        }
        [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
        cell.selectBtn.selected = user.isSelected;
        if (self.type != SelectFriendTypeCommon) {
            if (user.isGroupSelected) {
                cell.selectBtn.selected = NO;
                cell.selectBtn.enabled = NO;
            }else{
                cell.selectBtn.enabled = YES;
                cell.selectBtn.selected = user.isSelected;
            }
        }
    }else{
        FGroupUserInfoModel *user = obj;
        cell.nameLabel.text = user.name;
        [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
        cell.selectBtn.selected = user.isSelected;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenWidth, 28);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [FControlTool createLabel:self.titlesArray[section] textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    titleLabel.frame = CGRectMake(16, 0, kScreenWidth - 32, 28);
    [view addSubview:titleLabel];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == SelectFriendTypeRedPacket) {
        NSString * titles = self.titlesArray[indexPath.section];
        id obj = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
        if ([obj isKindOfClass:[FGroupUserInfoModel class]]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectUser:)]) {
                [self.delegate selectUser:(FGroupUserInfoModel*)obj];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    
    
    SWSelectUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * titles = self.titlesArray[indexPath.section];
    id obj = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
    if ([obj isKindOfClass:[FFriendModel class]]) {
        FFriendModel *user = obj;
        if (!cell.selectBtn.hidden && !user.isGroupSelected) {
            [cell selectBtnAction];
        }
    }
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchView.bottom+26, kScreenWidth, kScreenHeight-(self.searchView.bottom+26)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 134)];
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

