//
//  SWMyGroupsViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/30.
//

#import "SWMyGroupsViewController.h"
#import "SCIndexView.h"
#import "FFriendCell.h"
#import "SWMessageDetaillViewController.h"
@interface SWMyGroupsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,strong) NSArray *titlesArray;
@property (nonatomic,strong) NSMutableDictionary *mdic;
@property (nonatomic,strong) SCIndexView *indexView;
@end

@implementation SWMyGroupsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"群聊";
    
    SCIndexViewConfiguration *indexViewConfiguration = [SCIndexViewConfiguration configuration];
    indexViewConfiguration.indexItemSelectedBackgroundColor = UIColor.clearColor;
    indexViewConfiguration.indicatorTextFont = [UIFont fontWithSize:20];
    indexViewConfiguration.indicatorTextColor = [UIColor whiteColor];
    indexViewConfiguration.indicatorHeight = 40;
    indexViewConfiguration.indexItemTextColor = RGBColor(0x999999);
    indexViewConfiguration.indexItemSelectedTextColor = RGBColor(0x999999);
    self.indexView = [[SCIndexView alloc] initWithTableView:self.tableView configuration:indexViewConfiguration];
    self.indexView.translucentForTableViewInNavigationBar = YES;
    
    [self.view addSubview:self.indexView];
    
    [[FUserRelationManager sharedManager] reloadAllGroupsData:^(BOOL success) {
        [self initData];
    }];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:FRefreshFriendList object:nil];
}

- (void)initData{
    
    self.dataList = [FUserRelationManager sharedManager].allGroups;
    if (self.dataList.count == 0) {
        [self.tableView showEmptyWtihFrame:CGRectMake(0, 0, kScreenWidth, self.tableView.height*0.8) imageName:@"icn_no_person" title:@"暂无联系人"];
        return;
    }
    [self.tableView hiddenEmpty];
    NSArray *array = [self getOrderArraywithArray:self.dataList];

    NSMutableDictionary *mDic = [NSMutableDictionary new];
    self.mdic = mDic;

    for (FGroupModel *user in array) {
        // 将中文转换为拼音
        NSString *nickName = [NSMutableString stringWithString:user.name];
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

- (NSArray *)getOrderArraywithArray:(NSArray *)array{
    //数组排序
    //定义一个数字数组
    //对数组进行排序
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(FGroupModel     * _Nonnull obj1, FGroupModel     * _Nonnull obj2) {
        NSString *nickName1 = obj1.name;
        NSString *nickName2 = obj2.name;
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
    return self.titlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * titles = self.titlesArray[section];
    return [self.mdic[titles] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    FFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FFriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    NSString * titles = self.titlesArray[indexPath.section];
    FGroupModel *group = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
    cell.nameLabel.text = group.name;
    [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:group.head] placeholderImage:[UIImage imageNamed:@"avatar_group"]];
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
    view.backgroundColor = RGBColor(0xf1f1f1);
    
    UILabel *titleLabel = [FControlTool createLabel:self.titlesArray[section] textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    titleLabel.frame = CGRectMake(16, 0, kScreenWidth - 32, 28);
    [view addSubview:titleLabel];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * titles = self.titlesArray[indexPath.section];
    FGroupModel *group = [self.mdic[titles] objectAtIndex:indexPath.row][@"user"];
    SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = NIMSessionTypeTeam;
    vc.sessionId = group.groupId;
    vc.groupModel = group;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight - kTabBarHeight) style:UITableViewStylePlain];
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
