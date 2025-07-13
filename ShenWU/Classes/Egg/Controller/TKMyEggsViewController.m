//
//  TKMyEggsViewController.m
//  ShenWU
//
//  Created by Amy on 2024/8/25.
//

#import "TKMyEggsViewController.h"
#import "TKMyEggsCell.h"
#import "TKEggListModel.h"
#import "TKSelectGroupViewController.h"
@interface TKMyEggsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *unissuedTableView;
@property(nonatomic, strong) UITableView *issuedTableView;
@property(nonatomic, strong) NSMutableArray *unissuedList;
@property(nonatomic, strong) NSMutableArray *issuedList;
@property(nonatomic, strong) UIButton *unissuedBtn;
@property(nonatomic, strong) UIButton *issuedBtn;
@property(nonatomic, strong) UIImageView *selectImgView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) NSInteger selectIndex;
@end

@implementation TKMyEggsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.whiteColor};
    self.navigationController.navigationBar.titleTextAttributes = attribute;
    
    [self requestData];
    [self requestUsedData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.whiteColor};
    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的彩蛋";
    self.view.backgroundColor = RGBColor(0xC6463A);
    [self setWhiteNavBack];
    
    [self initData];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, kScreenWidth, 812*kScale);
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.image = [UIImage imageNamed:@"bg_egg_stop"];
    [self.view addSubview:bgImgView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - kTopHeight);
    bgView.backgroundColor = RGBAlphaColor(0x000000, 0.3);
    [self.view addSubview:bgView];
    
    self.selectImgView = [[UIImageView alloc] init];
    self.selectImgView.frame = CGRectMake((kScreenWidth/2 -66)/2, kTopHeight+25, 66, 9);
    self.selectImgView.image = [UIImage imageNamed:@"icn_egg_selected"];
    [self.view addSubview:self.selectImgView];
    
    self.unissuedBtn = [FControlTool createButton:@"未发放" font:[UIFont boldFontWithSize:18] textColor:UIColor.whiteColor target:self sel:@selector(unissuedBtnAction)];
    self.unissuedBtn.frame = CGRectMake(0, kTopHeight, kScreenWidth/2, 44);
    [self.view addSubview:self.unissuedBtn];
    
    self.issuedBtn = [FControlTool createButton:@"已发放" font:[UIFont boldFontWithSize:18] textColor:UIColor.whiteColor target:self sel:@selector(issuedBtnAction)];
    self.issuedBtn.frame = CGRectMake(kScreenWidth/2, kTopHeight, kScreenWidth/2, 44);
    [self.view addSubview:self.issuedBtn];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, self.unissuedBtn.bottom, kScreenWidth, kScreenHeight - self.unissuedBtn.bottom);
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight - self.unissuedBtn.bottom);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    for (NSInteger i=0; i<2; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, self.scrollView.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
        [self.scrollView addSubview:tableView];
        if (i == 0) {
            self.unissuedTableView = tableView;
        }else if (i == 1) {
            self.issuedTableView = tableView;
        }
    }
    
}

- (void)initData{
    self.unissuedList = [[NSMutableArray alloc] init];
    self.issuedList = [[NSMutableArray alloc] init];
}

- (void)requestData{
    @weakify(self);
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/wdCaidan" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            TKEggListModel *modelList = [TKEggListModel modelWithDictionary:response];
            [weak_self.unissuedList removeAllObjects];
            [weak_self.unissuedList addObjectsFromArray:modelList.data];
            
            [weak_self.unissuedTableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)requestUsedData{
    @weakify(self);
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/yffCaidan" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            TKEggListModel *modelList = [TKEggListModel modelWithDictionary:response];
            [weak_self.issuedList removeAllObjects];
            [weak_self.issuedList addObjectsFromArray:modelList.data];
            
            [weak_self.issuedTableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


- (void)unissuedBtnAction{
    self.selectImgView.left = (kScreenWidth/2 -66)/2;
    self.selectIndex = 1;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)issuedBtnAction{
    self.selectImgView.left = (kScreenWidth/2 -66)/2+kScreenWidth/2;
    self.selectIndex = 2;
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.scrollView]) {
        NSInteger index = scrollView.contentOffset.x/kScreenWidth;
        self.selectIndex = index;
        if (index == 0) {
            self.selectImgView.left = (kScreenWidth/2 -66)/2;
        }else if (index == 1) {
            self.selectImgView.left = (kScreenWidth/2 -66)/2+kScreenWidth/2;
        }
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.unissuedTableView]) {
        return self.unissuedList.count;
    }else{
        return self.issuedList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    TKMyEggsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TKMyEggsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    if ([tableView isEqual:self.unissuedTableView]) {
        TKEggListItemModel *model = [self.unissuedList objectAtIndex:indexPath.row];
        [cell refreshCellWithData:model];
    }else{
        TKEggListItemModel *model = [self.issuedList objectAtIndex:indexPath.row];
        [cell refreshCellWithData:model];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![tableView isEqual:self.unissuedTableView]) {
        return;
    }
    TKEggListItemModel *model = [self.unissuedList objectAtIndex:indexPath.row];
    TKSelectGroupViewController *vc = [[TKSelectGroupViewController alloc] init];
    vc.eggId = model.eggId;
    [self.navigationController pushViewController:vc animated:YES];
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
