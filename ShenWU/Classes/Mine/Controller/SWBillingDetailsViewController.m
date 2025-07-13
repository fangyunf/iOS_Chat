//
//  SWBillingDetailsViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/30.
//

#import "SWBillingDetailsViewController.h"
#import "FTranscationsModel.h"
#import "FBillingDetailsCell.h"
#import "FDatePickerView.h"
#import "SWBillingFilterView.h"
@interface SWBillingDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,FDatePickerViewDelegate>
@property(nonatomic, strong) UIButton *filterBtn;
@property(nonatomic, strong) UIButton *timeBtn;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) SWBillingFilterView *filterView;
@property(nonatomic, strong) NSString *chooseDate;
@property(nonatomic, strong) NSString *endId;
@property(nonatomic, strong) NSMutableArray<FTranscationsModel*> *dataList;
@property(nonatomic, assign) NSInteger moudleType;
@end

@implementation SWBillingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的账单";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.filterBtn = [FControlTool createButton:@"筛选" font:[UIFont boldFontWithSize:14] textColor:UIColor.whiteColor target:self sel:@selector(filterBtnAction)];
    self.filterBtn.frame = CGRectMake(15, kTopHeight+15, 90, 33);
    self.filterBtn.backgroundColor = kMainColor;
    self.filterBtn.layer.cornerRadius = 10;
    self.filterBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.filterBtn];
    
    self.timeBtn = [FControlTool createButton:@"" font:[UIFont boldFontWithSize:14] textColor:UIColor.whiteColor target:self sel:@selector(timeBtnAction)];
    self.timeBtn.frame = CGRectMake(kScreenWidth - 105, kTopHeight+15, 90, 33);
    self.timeBtn.backgroundColor = kMainColor;
    self.timeBtn.layer.cornerRadius = 10;
    self.timeBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.timeBtn];
    
    [self initData];
    [self refreshData];
}

- (void)initData{
    self.endId = @"";
    self.moudleType = -1;
    self.dataList = [[NSMutableArray alloc] init];
    
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    self.chooseDate = [FDataTool updataForNumberTimeYear:timeStamp formatter:@"yyyy-MM"];
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%@月",[self.chooseDate stringByReplacingOccurrencesOfString:@"-" withString:@"年"]] forState:UIControlStateNormal];
}

- (void)refreshData{
    self.endId = @"";
    [self requestData];
}

- (void)loadMoreData{
    self.endId = self.dataList.lastObject.transcationId;
    [self requestData];
}

- (void)filterBtnAction{
    if (!self.filterView) {
        self.filterView = [[SWBillingFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.view addSubview:self.filterView];
        
        @weakify(self)
        self.filterView.dismissBlock = ^{
            weak_self.filterView.hidden = YES;
        };
        
        self.filterView.selectBlock = ^(NSInteger index) {
            weak_self.filterView.hidden = YES;
            weak_self.moudleType = index;
            weak_self.endId = @"";
            [weak_self.filterBtn setTitle:[FDataTool getTransactionTypeDictionary][weak_self.filterView.selectIndex][@"title"] forState:UIControlStateNormal];
            [weak_self requestData];
        };
    }else{
        self.filterView.hidden = NO;
    }
}

- (void)timeBtnAction{
    FDatePickerView *datePickerView = [[FDatePickerView alloc] initWithFrame:self.view.bounds];
    datePickerView.delegate = self;
    datePickerView.time = [NSString stringWithFormat:@"%@",self.chooseDate];
    [[FControlTool keyWindow] addSubview:datePickerView];
    [datePickerView showView];
}

- (void)requestData{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"date"] = self.chooseDate;
    params[@"moudleType"] = @(self.moudleType);
    if (self.endId.length != 0) {
        params[@"endId"] = self.endId;
    }
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:@"/red/transcationsList" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (weak_self.endId.length == 0) {
                [weak_self.dataList removeAllObjects];
            }
            for (NSDictionary *dict in response[@"data"]) {
                FTranscationsModel *model = [FTranscationsModel modelWithDictionary:dict];
                [self.dataList addObject:model];
            }
            [weak_self.tableView reloadData];
            [weak_self.tableView.mj_header endRefreshing];
            [weak_self.tableView.mj_footer endRefreshing];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            [weak_self.tableView.mj_header endRefreshing];
            [weak_self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - FDatePickerViewDelegate
- (void)getSelectDate:(NSString *)selectDate{
    _chooseDate = selectDate;
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%@月",[self.chooseDate stringByReplacingOccurrencesOfString:@"-" withString:@"年"]] forState:UIControlStateNormal];

    [self requestData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    FBillingDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FBillingDetailsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBColor(0xF2F2F2);
        
    }
    [cell refreshCellWithData:self.dataList[indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    FCheckDetailViewController *vc = [[FCheckDetailViewController alloc] init];
//    vc.model = self.dataList[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(11, self.filterBtn.bottom+28, kScreenWidth-22, kScreenHeight-(self.filterBtn.bottom+28)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(0xF2F2F2);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorColor = RGBColor(0x009FF4);
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
