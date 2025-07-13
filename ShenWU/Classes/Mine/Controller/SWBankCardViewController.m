//
//  SWBankCardViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/1.
//

#import "SWBankCardViewController.h"
#import "FBankCardModel.h"
#import "SWAddBankCardViewController.h"
#import "SWBankCardCell.h"
@interface SWBankCardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *bankView;
@property(nonatomic, strong) UIView *emptyView;
@property(nonatomic, strong) NSMutableArray *dataList;
@end

@implementation SWBankCardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.dataList = [[NSMutableArray alloc] init];
    
    [self initEmptyView];
    [self initBankView];
    
    
}

- (void)initBankView{
    self.bankView = [[UIView alloc] init];
    self.bankView.frame = self.view.bounds;
    self.bankView.hidden = YES;
    [self.view addSubview:self.bankView];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = self.view.bounds;
    bgImgView.image = [UIImage imageNamed:@"bg_bank_card"];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.layer.masksToBounds = YES;
    [self.bankView addSubview:bgImgView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"我的银行卡" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:18]];
    titleLabel.frame = CGRectMake((kScreenWidth - 330)/2, kTopHeight+25, 330, 21);
    [self.bankView addSubview:titleLabel];
    
    UIButton *addBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_bank_card_add"] target:self sel:@selector(addBtnAction)];
    addBtn.frame = CGRectMake(kScreenWidth - (kScreenWidth - 330)/2 - 21, kTopHeight+25, 21, 21);
    [self.bankView addSubview:addBtn];
}

- (void)initEmptyView{
    self.emptyView = [[UIView alloc] init];
    self.emptyView.frame = self.view.bounds;
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    
    UIImageView *icnImgView = [[UIImageView alloc] init];
    icnImgView.frame = CGRectMake((kScreenWidth - 146)/2, kTopHeight+66, 146, 104);
    icnImgView.image = [UIImage imageNamed:@"icn_card_empty"];
    [self.emptyView addSubview:icnImgView];
    
    UILabel *tipLabel = [FControlTool createLabel:@"还没有银行卡，快去添加吧~" textColor:RGBColor(0x333333) font:[UIFont boldFontWithSize:15]];
    tipLabel.frame = CGRectMake(15, icnImgView.bottom+44, kScreenWidth - 30, 18);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.emptyView addSubview:tipLabel];
    
    UIButton *addBtn = [FControlTool createButton:@"添加" font:[UIFont boldFontWithSize:18] textColor:UIColor.whiteColor target:self sel:@selector(addBtnAction)];
    addBtn.frame = CGRectMake((kScreenWidth - 82)/2, tipLabel.bottom+24, 82, 35);
    addBtn.backgroundColor = kMainColor;
    addBtn.layer.cornerRadius = 17.5;
    addBtn.layer.masksToBounds = YES;
    [self.emptyView addSubview:addBtn];
}

- (void)requestData{
    self.dataList = [[NSMutableArray alloc] init];
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:self.isWithdraw? @"/bindCard/userZFB":@"/bindCard/bindingCards" parameters:self.isWithdraw? @{@"type":@(3)}:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            for (NSDictionary *dict in response[@"data"]) {
                [weak_self.dataList addObject:[FBankCardModel modelWithDictionary:dict]];
            }
            if (weak_self.dataList.count == 0) {
                self.title = @"银行卡";
                self.emptyView.hidden = NO;
                self.bankView.hidden = YES;
            }else{
                self.title = @"";
                self.emptyView.hidden = YES;
                self.bankView.hidden = NO;
                [weak_self.tableView reloadData];
            }
            
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)addBtnAction{
    SWAddBankCardViewController *vc = [[SWAddBankCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWBankCardCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    cell.tag = indexPath.row;
    [cell refreshCellWithData:self.dataList[indexPath.row]];
    @weakify(self)
    cell.unbindBlock = ^(NSInteger index) {
        [weak_self untieBankCard:index];
    };
    return cell;
    
}

- (void)untieBankCard:(NSInteger)index{
    @weakify(self)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否解绑该银行卡" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weak_self requestUntieBankCard:index];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}

- (void)requestUntieBankCard:(NSInteger)index{
    FBankCardModel *model = [self.dataList objectAtIndex:index];
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/card/untieCard" parameters:@{@"bankCardId":model.cardId} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [weak_self.dataList removeObjectAtIndex:index];
            [weak_self.tableView reloadData];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock) {
        self.selectBlock(self.dataList[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  kTopHeight+71, kScreenWidth, kScreenHeight-( kTopHeight+71)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
