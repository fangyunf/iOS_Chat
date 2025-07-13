//
//  FMyCollectViewController.m
//  Fiesta
//
//  Created by Amy on 2024/5/28.
//

#import "FMyCollectViewController.h"
#import "FMyCollectCell.h"
@interface FMyCollectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NIMCollectQueryOptions *option;
@property(nonatomic, strong) NSMutableArray<NIMCollectInfo *> *dataList;
@end

@implementation FMyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    
    [self.tableView reloadData];
    
    [self initData];
}

- (void)initData{
    self.dataList = [NSMutableArray array];
    self.option = [[NIMCollectQueryOptions alloc] init];
    self.option.excludeId = 0;
    self.option.reverse = NO;
    self.option.toTime = 0;
    self.option.fromTime = 1692460800;
    self.option.limit = 100;
    
    [self loadData];
}

- (void)refreshData{
    self.option.excludeId = 0;
    [self loadData];
}

- (void)loadData{
    @weakify(self)
    [[NIMSDK sharedSDK].chatExtendManager queryCollect:self.option completion:^(NSError * _Nullable error, NSArray<NIMCollectInfo *> * _Nullable collectInfos, NSInteger totalCount) {
        if (error == nil) {
            if (weak_self.option.excludeId == 0) {
                [weak_self.dataList removeAllObjects];
            }
            
            [weak_self.dataList addObjectsFromArray:collectInfos];
//            NSLog(@"excludeId == %ld %lu",weak_self.option.excludeId,(unsigned long)weak_self.dataList.lastObject.id);
//            weak_self.option.excludeId = weak_self.dataList.lastObject.id;
            if (totalCount == weak_self.dataList.count) {
                [weak_self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak_self.tableView reloadData];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weak_self.tableView.mj_footer endRefreshing];
            [weak_self.tableView.mj_header endRefreshing];
        });
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NIMCollectInfo *info = [self.dataList objectAtIndex:indexPath.row];
    if (info.type == 1024) {
        return 83;
    }
    return 127;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    FMyCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FMyCollectCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBColor(0xF6F6F6);
        
    }
    NIMCollectInfo *info = [self.dataList objectAtIndex:indexPath.row];
    NSLog(@"data ==== :%@",info.data);
    cell.titleLabel.hidden = YES;
    cell.contentImgView.hidden = YES;
    cell.nameLabel.hidden = YES;
    NSString *time = [NSString stringWithFormat:@"%f", info.createTime];
    cell.timeLabel.text = [FDataTool updataForNumberTimeYear:time formatter:@"YYY-MM-dd"];
    if (info.type == 1024) {
        cell.titleLabel.hidden = NO;
        cell.titleLabel.text = [AESUtil aesDecrypt:info.data AndKey:@"wallstreetimchat"];
        [cell updateViewFrame:NO];
    }else{
        cell.contentImgView.hidden = NO;
        [cell.contentImgView sd_setImageWithURL:[NSURL URLWithString:info.data]];
        [cell updateViewFrame:YES];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(0xF6F6F6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
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
