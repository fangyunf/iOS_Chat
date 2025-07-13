//
//  SWRedPacketRecordViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/30.
//

#import "SWRedPacketRecordViewController.h"
#import "FReceiveMoneyDetailCell.h"
#import "FDatePickerView.h"
@interface SWRedPacketRecordViewController ()<UITableViewDelegate,UITableViewDataSource,FDatePickerViewDelegate>
@property(nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, strong) UIButton *timeBtn;
@property(nonatomic, strong) UIButton *receiveBtn;
@property(nonatomic, strong) UIButton *sendBtn;
@property(nonatomic, assign) NSInteger selectIndex;

@property(nonatomic, strong) NSString *endId;
@property(nonatomic, assign) NSInteger receiveMoney;
@property(nonatomic, assign) NSInteger sendMoney;
@property(nonatomic, strong) NSString *chooseDate;
@property(nonatomic, strong) NSMutableArray<FRedPacketUserModel*> *receiveList;

@property(nonatomic, strong) NSMutableArray<FRedPacketUserModel*> *sendList;
@end

@implementation SWRedPacketRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    self.view.backgroundColor = RGBColor(0xF1F3F7);
    
    self.timeBtn = [FControlTool createButton:self.chooseDate font:[UIFont boldFontWithSize:18] textColor:UIColor.blackColor target:self sel:@selector(timeBtnAction)];
    self.timeBtn.frame = CGRectMake(kScreenWidth - 100, self.sendBtn.bottom+10, 100, 44);
    [self.timeBtn setImage:[UIImage imageNamed:@"icn_arrow_down"] forState:UIControlStateNormal];
    [self.timeBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:5];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.timeBtn];
    
    self.title = @"红包账单";
    
    
    
    [self.tableView reloadData];
    [self initHeaderView];
    
    [self.view bringSubviewToFront:self.navTopView];
    
    [self requestReceiveData];
}

- (void)initData{
    self.selectIndex = 0;
    self.endId = @"";
    self.receiveList = [[NSMutableArray alloc] init];
    self.sendList = [[NSMutableArray alloc] init];
    
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    self.chooseDate = [FDataTool updataForNumberTimeYear:timeStamp formatter:@"yyyy-MM"];
}

- (void)initHeaderView{
    self.headerView = [[UIView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth-22, 290);
    
    self.receiveBtn = [FControlTool createButton:@"我收到的" font:[UIFont fontWithSize:16] textColor:RGBColor(0x081C2C)  target:self sel:@selector(receiveBtnAction)];
    self.receiveBtn.frame = CGRectMake(16, 16, (self.headerView.width - 48)/2, 32);
    [self.receiveBtn setTitleColor:kMainColor forState:UIControlStateSelected];
    self.receiveBtn.layer.cornerRadius = 16;
    self.receiveBtn.layer.masksToBounds = YES;
    self.receiveBtn.backgroundColor = UIColor.whiteColor;
    [self.headerView addSubview:self.receiveBtn];
    
    self.sendBtn = [FControlTool createButton:@"我发出的" font:[UIFont fontWithSize:16] textColor:RGBColor(0x081C2C) target:self sel:@selector(sendBtnAction)];
    self.sendBtn.frame = CGRectMake(self.receiveBtn.right+16, 14, (self.headerView.width - 48)/2, 32);
    [self.sendBtn setTitleColor:kMainColor forState:UIControlStateSelected];
    self.sendBtn.layer.cornerRadius = 16;
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.backgroundColor = UIColor.whiteColor;
    [self.headerView addSubview:self.sendBtn];
    
    if (self.selectIndex == 0) {
        self.receiveBtn.selected = YES;
        self.sendBtn.selected = NO;
    }else{
        self.receiveBtn.selected = NO;
        self.sendBtn.selected = YES;
    }
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(0, 78, self.headerView.width, 204);
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(11, 11)];
    [self.headerView addSubview:contentView];
    
    self.avatarImgView = [[UIImageView alloc] init];
    self.avatarImgView.frame = CGRectMake((self.headerView.width - 64)/2, self.sendBtn.bottom+20, 64, 64);
    self.avatarImgView.layer.cornerRadius = 32;
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[FUserModel sharedUser].headerIcon] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    [self.headerView addSubview:self.avatarImgView];
    
    self.nameLabel = [FControlTool createLabel:@"" textColor:RGBAlphaColor(0x081C2C, 0.5) font:[UIFont fontWithSize:14]];
    self.nameLabel.frame = CGRectMake(16, self.avatarImgView.bottom+16, kScreenWidth - 32, 22);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:self.nameLabel];
    
    self.moneyLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:40]];
    self.moneyLabel.frame = CGRectMake(16, self.nameLabel.bottom+7, kScreenWidth - 32 - 22, 56);
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:self.moneyLabel];
    
    self.tableView.tableHeaderView = self.headerView;
    
    
}

- (void)refreshData{
    self.endId = @"";
    if (self.selectIndex == 0) {
        [self requestReceiveData];
    }else{
        [self requestSendData];
    }
}

- (void)loadMoreData{
    
    if (self.selectIndex == 0) {
        self.endId = self.receiveList.lastObject.detailId;
        [self requestReceiveData];
    }else{
        self.endId = self.sendList.lastObject.detailId;
        [self requestSendData];
    }
}

- (void)requestReceiveData{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"date"] = self.chooseDate;
    if (self.endId.length != 0) {
        params[@"endId"] = self.endId;
    }
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:@"/red/reciveRecord" parameters:params success:^(NSDictionary * _Nonnull response) {
        if (weak_self.endId.length == 0) {
            weak_self.receiveMoney = 0;
            [weak_self.receiveList removeAllObjects];
        }
        if ([response[@"code"] integerValue] == 200) {
            
            for (NSDictionary *dict in response[@"data"]) {
                FRedPacketUserModel *model = [FRedPacketUserModel modelWithDictionary:dict];
                weak_self.receiveMoney += model.amount;
                [weak_self.receiveList addObject:model];
            }
            if (weak_self.selectIndex == 0) {
                [weak_self.tableView.mj_header endRefreshing];
                [weak_self.tableView.mj_footer endRefreshing];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            [weak_self.tableView.mj_header endRefreshing];
            [weak_self.tableView.mj_footer endRefreshing];
        }
        weak_self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",weak_self.receiveMoney/100.0];
        weak_self.nameLabel.text = [NSString stringWithFormat:@"%@共收到%ld个红包",[FUserModel sharedUser].nickName,weak_self.receiveList.count];
        [weak_self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
    }];
}

- (void)requestSendData{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"date"] = self.chooseDate;
    if (self.endId.length != 0) {
        params[@"endId"] = self.endId;
    }
    @weakify(self)
    
    [[FNetworkManager sharedManager] postRequestFromServer:@"/red/sendRecord" parameters:params success:^(NSDictionary * _Nonnull response) {
        if (weak_self.endId.length == 0) {
            weak_self.sendMoney = 0;
            [weak_self.sendList removeAllObjects];
        }
        if ([response[@"code"] integerValue] == 200) {
            
            for (NSDictionary *dict in response[@"data"]) {
                FRedPacketUserModel *model = [FRedPacketUserModel modelWithDictionary:dict];
                model.avatar = [FUserModel sharedUser].headerIcon;
                model.name = [FUserModel sharedUser].nickName;
                weak_self.sendMoney += model.amount;
                [self.sendList addObject:model];
            }
            if (weak_self.selectIndex == 1) {
                
                [weak_self.tableView.mj_header endRefreshing];
                [weak_self.tableView.mj_footer endRefreshing];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            [weak_self.tableView.mj_header endRefreshing];
            [weak_self.tableView.mj_footer endRefreshing];
        }
        weak_self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",weak_self.sendMoney/100.0];
        weak_self.nameLabel.text = [NSString stringWithFormat:@"%@共发出%ld个红包",[FUserModel sharedUser].nickName,weak_self.sendList.count];
        [weak_self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
    }];
}

- (void)timeBtnAction{
    FDatePickerView *datePickerView = [[FDatePickerView alloc] initWithFrame:self.view.bounds];
    datePickerView.delegate = self;
    datePickerView.time = [NSString stringWithFormat:@"%@",self.chooseDate];
    [[FControlTool keyWindow] addSubview:datePickerView];
    [datePickerView showView];
}

- (void)receiveBtnAction{
    self.receiveBtn.selected = YES;
    self.sendBtn.selected = NO;
    self.selectIndex = 0;
    [self.tableView reloadData];
    if (self.receiveList.count == 0) {
        [self refreshData];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.receiveMoney/100.0];
    self.nameLabel.text = [NSString stringWithFormat:@"%@共收到%ld个红包",[FUserModel sharedUser].nickName,self.receiveList.count];
}

- (void)sendBtnAction{
    self.receiveBtn.selected = NO;
    self.sendBtn.selected = YES;
    self.selectIndex = 1;
    [self.tableView reloadData];
    if (self.sendList.count == 0) {
        [self refreshData];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.sendMoney/100.0];
    self.nameLabel.text = [NSString stringWithFormat:@"%@共发出%ld个红包",[FUserModel sharedUser].nickName,self.sendList.count];
}

#pragma mark - FDatePickerViewDelegate
- (void)getSelectDate:(NSString *)selectDate{
    _chooseDate = selectDate;
    [self.timeBtn setTitle:self.chooseDate forState:UIControlStateNormal];
    
    if (self.selectIndex == 0) {
        self.receiveMoney = 0;
        [self.receiveList removeAllObjects];
    }else{
        self.sendMoney = 0;
        [self.sendList removeAllObjects];
    }
    [self refreshData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectIndex == 1) {
        return self.sendList.count;
    }
    return self.receiveList.count;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell radius:11 color:UIColor.whiteColor indexPath:indexPath tableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    FReceiveMoneyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FReceiveMoneyDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBColor(0xf2f2f2);
        cell.bestBtn.hidden = YES;
        cell.moneyLabel.frame = CGRectMake(self.avatarImgView.right+12, 10, kScreenWidth-22 - (self.avatarImgView.right+28), 22);
    }
    if (self.selectIndex == 1) {
        [cell refreshCellWithData:[self.sendList objectAtIndex:indexPath.row]];
    }else{
        [cell refreshCellWithData:[self.receiveList objectAtIndex:indexPath.row]];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(11, kTopHeight, kScreenWidth-22, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = UIColor.whiteColor;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 58, 0, 16);
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
