//
//  FReceiveMoneyDetailViewController.m
//  Fiesta
//
//  Created by Amy on 2024/6/1.
//

#import "FReceiveMoneyDetailViewController.h"
#import "FReceiveMoneyDetailHeaderView.h"
#import "FReceiveMoneyDetailCell.h"
//#import "FShoppingCouponRecordViewController.h"
#import "FRedPacketDetailModel.h"
#import "ShenWU-Swift.h"
@interface FReceiveMoneyDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) FReceiveMoneyDetailHeaderView *headerView;
@property(nonatomic, strong) FRedPacketMessageModel *redPacketModel;
@property(nonatomic, strong) FRedPacketDetailModel *redPacketDetailModel;
@end

@implementation FReceiveMoneyDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, 0.34)]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = RGBColor(0xF6F6F6);
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:RGBColor(0xF6F6F6) size:CGSizeMake(kScreenWidth, 0.34)]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTopView.hidden = YES;
    
//    self.navigationItem.rightBarButtonItem = [self getRightBarButtonItemWithTitle:@"红包记录" titleColor:UIColor.whiteColor font:[UIFont fontWithSize:14] target:self action:@selector(rightBtnAction)];
    
    self.headerView = [[FReceiveMoneyDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130+212*kScale+kStatusBarHeight)];
    
    self.tableView.tableHeaderView = self.headerView;
    
    UIImageView *topBgImgView = [[UIImageView alloc] init];
    topBgImgView.frame = CGRectMake(0, -80*kScale, kScreenWidth, 212*kScale);
    topBgImgView.image = [UIImage imageNamed:@"bg_get_top"];
    [self.view addSubview:topBgImgView];
    
    [self requestData];
}

- (void)initFooterView{
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 79);
    
    UILabel *tipLabel = [FControlTool createLabel:@"24小时未领完，将原路返回" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
    tipLabel.frame = CGRectMake(16, 25, kScreenWidth - 32, 20);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:tipLabel];
    
    self.tableView.tableFooterView = footerView;
}

- (void)rightBtnAction{
//    FShoppingCouponRecordViewController *vc = [[FShoppingCouponRecordViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setRedPacketDict:(NSDictionary *)redPacketDict{
    _redPacketDict = redPacketDict;
    self.redPacketModel = [FRedPacketMessageModel modelWithDictionary:redPacketDict];
    NSLog(@"redPacketDict === :%@",self.redPacketModel.redPacketId);
}

- (void)requestData{
    [SVProgressHUD show];
    NSString *requestUrl = @"";
    if (self.isLook) {
        requestUrl = @"/red/redpacketDetail";
    }else{
        if (self.redPacketModel.customType == 21) {
            requestUrl = @"/red/reciveExclusiveRedpacket";
        }else if (self.redPacketModel.customType == 22) {
            if ([self.redPacketModel.fromUserId isEqualToString:[FUserModel sharedUser].userID]) {
                requestUrl = @"/red/redpacketDetail";
            }else{
                requestUrl = @"/red/recivePersonRedpacket";
            }
            
        }else if (self.redPacketModel.customType == 23) {
            requestUrl = @"/red/grab";
        }
    }
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:requestUrl parameters:@{@"redpacketId":self.redPacketModel.redPacketId,@"createTime":self.redPacketModel.createTime} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            if (weak_self.isLook) {
                weak_self.redPacketModel.sendAvatar = response[@"data"][@"sendAvatar"];
                weak_self.redPacketModel.sendName = response[@"data"][@"sendName"];
                weak_self.redPacketModel.title = response[@"data"][@"title"];
                weak_self.redPacketModel.sendLevel = [response[@"data"][@"sendLevel"] integerValue];
                weak_self.redPacketModel.customType = [response[@"data"][@"redpacketType"] integerValue];
            }
            weak_self.redPacketDetailModel = [FRedPacketDetailModel modelWithDictionary:response[@"data"]];
            if (weak_self.redPacketDetailModel.vos.count == weak_self.redPacketDetailModel.totalNum) {
                double maxPrice = 0.0;
                NSInteger maxIndex = 0;
                for (NSInteger i=0; i<weak_self.redPacketDetailModel.vos.count; i++) {
                    FRedPacketUserModel *userModel = [weak_self.redPacketDetailModel.vos objectAtIndex:i];
                    if (userModel.amount > maxPrice) {
                        maxPrice = userModel.amount;
                        maxIndex = i;
                    }
                }
                FRedPacketUserModel *userModel = [weak_self.redPacketDetailModel.vos objectAtIndex:maxIndex];
                for (FFriendModel *model in [FUserRelationManager sharedManager].allFriends) {
                    if([userModel.userId isEqualToString:model.userId]){
                        userModel.remark = model.remark;
                    }
                    
                }
                userModel.isFirstGood = YES;
            }
            
            [weak_self.tableView reloadData];
            if (weak_self.redPacketModel.customType == 23) {
                [weak_self initFooterView];
            }
            [weak_self reloadView];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)reloadView{
    self.headerView.customType = self.redPacketModel.customType;
    self.headerView.fromUserId = self.redPacketModel.fromUserId;
    [self.headerView refreshViewWithData:self.redPacketDetailModel];
    if (self.redPacketModel.customType == 21) {
        [self.headerView changeViewFrame:self.redPacketModel.toUserId];
        
        if([self.redPacketModel.toUserId isEqualToString:[FUserModel sharedUser].userID]){
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 117+206*kScale);
        }else{
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 52+206*kScale);
        }
        self.tableView.tableHeaderView = self.headerView;
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.redPacketModel.toUserId isEqualToString:[FUserModel sharedUser].userID]){
        return self.redPacketDetailModel.vos.count;
    }else{
        return self.redPacketDetailModel.vos.count;
    }
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
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    [cell refreshCellWithData:[self.redPacketDetailModel.vos objectAtIndex:indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = RGBColor(0xF2F2F2);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
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
