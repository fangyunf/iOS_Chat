//
//  SWUnclaimedRedPacketViewController.m
//  ShenWU
//
//  Created by Amy on 2025/3/27.
//

#import "SWUnclaimedRedPacketViewController.h"
#import "SWUnclaimedRedPacketCell.h"
#import "SWUnclaimedRedPacketModel.h"
#import "ShenWU-Swift.h"
#import "FRedPacketDetailModel.h"
@interface SWUnclaimedRedPacketViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, assign) BOOL isRequesting;
@end

@implementation SWUnclaimedRedPacketViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"未领取红包专区";
    
    self.view.backgroundColor = RGBColor(0xF1F3F7);
    [self setWhiteNavBack];
    
    [self.view addSubview:self.tableView];
    
    self.dataList = [NSMutableArray array];
    [self requestData];
}

- (void)requestData{
    @weakify(self);
    NSDictionary *params = @{@"groupId":self.model.groupId};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/red/vlqzsb" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (![FDataTool isNull:response[@"data"]]) {
                [weak_self.dataList removeAllObjects];
                for (NSDictionary *dict in response[@"data"]) {
                    SWUnclaimedRedPacketModel *model = [SWUnclaimedRedPacketModel modelWithDictionary:dict];
                    [weak_self.dataList addObject:model];
                }
                [weak_self.tableView reloadData];
            }
        }
        [weak_self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [weak_self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
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
    return 140;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWUnclaimedRedPacketCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWUnclaimedRedPacketCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBColor(0xF1F3F7);
        
    }
    cell.model = [self.dataList objectAtIndex:indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWUnclaimedRedPacketModel *model = [self.dataList objectAtIndex:indexPath.row];
    [self reciveRedPacket:model];
}

- (void)reciveRedPacket:(SWUnclaimedRedPacketModel*)model{
    if(self.isRequesting){
        return;
    }
    self.isRequesting = YES;
    NSString *requestUrl = @"";
    if (model.type == 21) {
        requestUrl = @"/red/reciveExclusiveRedpacket";
    }else if (model.type == 22) {
        requestUrl = @"/red/recivePersonRedpacket";
    }else if (model.type == 23) {
        requestUrl = @"/red/grab";
    }
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:requestUrl parameters:@{@"redpacketId":model.redPacketId,@"createTime":model.createTime} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            if (![FDataTool isNull:response[@"data"]]) {
                FRedPacketDetailModel *detailModel = [FRedPacketDetailModel modelWithDictionary:response[@"data"]];
                BOOL isExist = NO;
                if (detailModel.vos.count > 0) {
                    for (FRedPacketUserModel *userModel in detailModel.vos) {
                        if ([[FUserModel sharedUser].userID isEqualToString:userModel.userId]) {
                            isExist = YES;
                        }
                    }
                }
                if (isExist) {
                    if ([requestUrl isEqualToString:@"/red/grab"]) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"receiveUserName"] = [FUserModel sharedUser].nickName;
                        dic[@"receiveUserId"] = [FUserModel sharedUser].userID;
                        dic[@"sendUserName"] = detailModel.sendName;
                        dic[@"sendUserId"] = model.sendUserId;
                        [[FMessageManager sharedManager] sendTipMessage:[FDataTool convertToJsonData:dic] sessionId:weak_self.model.groupId type:2];
                    }else if ([requestUrl isEqualToString:@"/red/recivePersonRedpacket"]) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"receiveUserName"] = [FUserModel sharedUser].nickName;
                        dic[@"receiveUserId"] = [FUserModel sharedUser].userID;
                        dic[@"sendUserName"] = detailModel.sendName;
                        dic[@"sendUserId"] = model.sendUserId;
                        [[FMessageManager sharedManager] sendTipMessage:[FDataTool convertToJsonData:dic] sessionId:weak_self.model.groupId type:1];
                    }
                }
            }
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            weak_self.isRequesting = NO;
            [weak_self requestData];
        }else{
            weak_self.isRequesting = NO;
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        self.isRequesting = NO;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight+7, kScreenWidth, kScreenHeight-kTopHeight-7) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(0xF1F3F7);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
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
