//
//  SWLittleHelperViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/29.
//

#import "SWLittleHelperViewController.h"
#import "SWLittleHelperCell.h"
#import <JXCategoryView/JXCategoryView.h>
@interface SWLittleHelperViewController ()<UITableViewDelegate,UITableViewDataSource,JXCategoryListContentViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) NSMutableArray *allDataList;
@property(nonatomic, assign) NSInteger pageNum;
@end

@implementation SWLittleHelperViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"小助手";
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = self.view.bounds;
//    bgImgView.image = [UIImage imageNamed:@"bg_mine"];
    bgImgView.backgroundColor = RGBColor(0xf2f2f2);
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.userInteractionEnabled = YES;
    bgImgView.layer.masksToBounds = YES;
    [self.view addSubview:bgImgView];
    
    [self.tableView reloadData];
    
    self.dataList = [NSMutableArray array];
    self.allDataList = [NSMutableArray array];
    [self refreshData];
}

- (void)refreshData{
    self.pageNum = 1;
    [self requestData];
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadMoreData{
    self.pageNum++;
    [self requestData];
}

- (void)requestData{
    @weakify(self)
    
    NSDictionary *params = @{@"pageNo":[NSNumber numberWithInteger:self.pageNum]};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/aideNews/aideMsg" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (weak_self.pageNum == 1) {
                [weak_self.dataList removeAllObjects];
            }
            FLittleHelperListModel *model = [FLittleHelperListModel modelWithDictionary:response[@"data"]];
            for (FLittleHelperModel *itemModel in model.data) {
                if (itemModel.state != 103 && itemModel.state != 104 && itemModel.state != 105) {
                    [self.dataList addObject:itemModel];
                }
            }
            [weak_self.allDataList addObjectsFromArray:model.data];
            weak_self.pageNum = model.pageNum;
            if (self.allDataList.count == model.total) {
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
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 172;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWLittleHelperCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWLittleHelperCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell refreshCellWithData:[self.dataList objectAtIndex:indexPath.row]];
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

- (UIView *)listView{
    return self.view;
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
