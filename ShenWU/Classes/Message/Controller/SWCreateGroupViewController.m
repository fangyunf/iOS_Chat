//
//  SWCreateGroupViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/23.
//

#import "SWCreateGroupViewController.h"
#import "SWSelectUserCell.h"
#import "SWSearchView.h"
#import "SCIndexView.h"
#import "SWMessageDetaillViewController.h"
@interface SWCreateGroupViewController ()<UITableViewDelegate,UITableViewDataSource,SWSelectUserCellDelegate>
@property(nonatomic, strong) SWSearchView *searchView;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titlesArray;
@property (nonatomic,strong) NSMutableDictionary *mdic;
@property (nonatomic,strong) NSMutableArray<FFriendModel*> *dataList;
@property (nonatomic,strong) NSMutableArray<FFriendModel*> *searchList;
@property (nonatomic,strong) SCIndexView *indexView;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,assign) CGFloat topHeight;
@property (nonatomic,assign) BOOL isRequesting;
@end

@implementation SWCreateGroupViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
//    self.navigationController.navigationBar.titleTextAttributes = attribute;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.whiteColor};
//    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发起群聊";
    self.view.backgroundColor = UIColor.whiteColor;
    self.searchList = [[NSMutableArray alloc] init];
    
    if (self.view.height >= kScreenHeight) {
        self.topHeight = kTopHeight;
    }else{
        self.topHeight = 0;
    }

    
    @weakify(self)
    self.searchView = [[SWSearchView alloc] initWithFrame:CGRectMake(16, self.topHeight+18, kScreenWidth - 32, 40)];
    self.searchView.placeholder = @"搜索你要查找的账号";
    self.searchView.searchBlock = ^(NSString * _Nonnull content) {
        [weak_self searchUser:content];
    };
    self.searchView.endSearchBlock = ^{
        [weak_self refreshData:weak_self.dataList];
    };
    [self.view addSubview:self.searchView];
    
    SCIndexViewConfiguration *indexViewConfiguration = [SCIndexViewConfiguration configuration];
    indexViewConfiguration.indexItemSelectedBackgroundColor = UIColor.clearColor;
    indexViewConfiguration.indicatorTextFont = [UIFont fontWithSize:20];
    indexViewConfiguration.indicatorTextColor = [UIColor whiteColor];
    indexViewConfiguration.indicatorHeight = 40;
    indexViewConfiguration.indexItemTextColor = RGBColor(0x8B5FD8);
    indexViewConfiguration.indexItemSelectedTextColor = RGBColor(0x8B5FD8);
    self.indexView = [[SCIndexView alloc] initWithTableView:self.tableView configuration:indexViewConfiguration];
    self.indexView.translucentForTableViewInNavigationBar = YES;
    
    [self.view addSubview:self.indexView];
    
    self.sureBtn = [FControlTool createButton:@"确认" font:[UIFont boldFontWithSize:18] textColor:UIColor.whiteColor target:self sel:@selector(createBtnAction)];
    self.sureBtn.frame = CGRectMake(kScreenWidth - 115, kScreenHeight - 84 - (kTopHeight - self.topHeight), 100, 51);
    self.sureBtn.backgroundColor = kMainColor;
    self.sureBtn.layer.cornerRadius = 10;
    self.sureBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.sureBtn];
    
    [[FUserRelationManager sharedManager] reloadAllFriendsData:^(BOOL success) {
        self.dataList = [FUserRelationManager sharedManager].allFriends;
        [self refreshData:self.dataList];
    }];
}

- (void)refreshData:(NSMutableArray*)list{
    if (list.count == 0) {
        [self.tableView showEmptyWtihFrame:CGRectMake(0, 0, kScreenWidth, self.tableView.height*0.8) imageName:@"icn_no_person" title:@"暂无联系人"];
        return;
    }
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

- (void)searchUser:(NSString *)content{
    [self.searchList removeAllObjects];
    for (FFriendModel *user in self.dataList) {
        if ([user.name.lowercaseString containsString:content.lowercaseString] || [user.remark.lowercaseString containsString:content.lowercaseString]) {
            [self.searchList addObject:user];
        }
    }
    [self refreshData:self.searchList];
    [self.tableView reloadData];
}

- (void)createBtnAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"群名称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入群名称";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textFeild = alert.textFields.firstObject;
        if (textFeild.text.length > 0) {
            [self requestCreateGroup:textFeild.text];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请输入群名称"];
        }
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)requestCreateGroup:(NSString*)groupName{
    if (self.isRequesting) {
        return;
    }
    self.isRequesting = YES;
    NSMutableArray *selectList = [[NSMutableArray alloc] init];
    for (FFriendModel *model in self.dataList) {
        if (model.isSelected) {
            [selectList addObject:model.userId];
        }
    }
    if (selectList.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择好友"];
        self.isRequesting = NO;
        return;
    }
//    if (selectList.count == 1) {
//        NSString *userId = selectList.firstObject;
//        SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
//        vc.sessionId = userId;
//        vc.type = NIMSessionTypeP2P;
//        [self.navigationController pushViewController:vc animated:YES];
//        self.isRequesting = NO;
//        return;
//    }
    [selectList addObject:[FUserModel sharedUser].userID];
    NSDictionary *params = @{@"members":selectList, @"groupName":groupName};
    
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/createGroup" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            [weak_self.navigationController popViewControllerAnimated:YES];
        }else{
            weak_self.isRequesting = NO;
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        weak_self.isRequesting = NO;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
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

#pragma mark - SWSelectUserCellDelegate
- (void)selectFriend:(SWSelectUserCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString * titles = self.titlesArray[indexPath.section];
    FFriendModel *user = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
    user.isSelected = cell.selectBtn.selected;
    
    NSInteger selectCount = 0;
    for (FFriendModel *model in self.dataList) {
        if (model.isSelected) {
            selectCount++;
        }
    }
    if (selectCount > 0) {
        [self.sureBtn setTitle:[NSString stringWithFormat:@"确认 %ld",selectCount] forState:UIControlStateNormal];
    }else{
        [self.sureBtn setTitle:@"确认" forState:UIControlStateNormal];
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
    cell.selectBtn.hidden = NO;
    NSString * titles = self.titlesArray[indexPath.section];
    FFriendModel *user = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
    if (user.remark.length > 0) {
        cell.nameLabel.text = user.remark;
    }else{
        cell.nameLabel.text = user.name;
    }
    cell.selectBtn.selected = user.isSelected;
    [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
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
    SWSelectUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.selectBtn.hidden) {
        [cell selectBtnAction];
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
