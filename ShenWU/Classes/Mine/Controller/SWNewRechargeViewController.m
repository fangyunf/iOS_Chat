//
//  SWNewRechargeViewController.m
//  ShenWU
//
//  Created by Amy on 2025/2/12.
//

#import "SWNewRechargeViewController.h"
#import "SWMessageDetaillViewController.h"
#import "SWNewRechargeHeaderView.h"
#import "SWNewRechargeMethodCell.h"
#import <AlipaySDK/AlipaySDK.h>
@interface SWNewRechargeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) SWNewRechargeHeaderView *headerView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, assign) NSInteger selectIndex;
@property(nonatomic, strong) NSString *rechargeMethod;
@end

@implementation SWNewRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值";
    
    self.navTopView.hidden = YES;
    
    self.view.backgroundColor = RGBColor(0xF5F7FA);
    
    UIImageView *topBgView = [[UIImageView alloc] init];
    topBgView.frame = CGRectMake(0, 0, kScreenWidth, 275*kScale);
    topBgView.image = [UIImage imageNamed:@"bg_wallet_top"];
    [self.view addSubview:topBgView];
    
    self.dataList = @[@{@"title":@"支付宝充值",@"imageName":@"icn_recharge_zfb"}];
    
    self.navigationItem.rightBarButtonItem = [self getRightBarButtonItemWithTitle:@"客服" titleColor:UIColor.whiteColor font:[UIFont fontWithSize:15] target:self action:@selector(rightBtnAction)];
    
    self.headerView = [[SWNewRechargeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-32 , 280)];
    self.tableView.tableHeaderView = self.headerView;
    
    UIButton *sureBtn = [FControlTool createButton:@"确定购买" font:[UIFont boldFontWithSize:16] textColor:UIColor.whiteColor target:self sel:@selector(sureBtnAction)];
    sureBtn.frame = CGRectMake(71, kScreenHeight - 52 - 50, kScreenWidth - 142, 50);
    sureBtn.backgroundColor = kMainColor;
    [sureBtn rounded:25];
    [self.view addSubview:sureBtn];
    
    self.rechargeMethod = @"alipay";
}

- (void)rightBtnAction{
    SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = NIMSessionTypeP2P;
    vc.sessionId = [FMessageManager sharedManager].serviceUserId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sureBtnAction{
    if (self.headerView.moneyValue.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择充值金额"];
        return;
    }
    NSString *url = @"";
    NSDictionary *params = nil;
    if ([[self.dataList objectAtIndex:self.selectIndex][@"title"] isEqualToString:@"支付宝充值一"]) {
        url = @"/pay/six";
        params = @{@"amount":@([self.headerView.moneyValue doubleValue]*100)};
    }else if ([[self.dataList objectAtIndex:self.selectIndex][@"title"] isEqualToString:@"微信充值一"]) {
        url = @"/pay/sixwx";
        params = @{@"amount":@([self.headerView.moneyValue doubleValue]*100),@"type":self.rechargeMethod};
    }else if ([[self.dataList objectAtIndex:self.selectIndex][@"title"] isEqualToString:@"支付宝充值二"]) {
        url = @"/pay/sixwx";
        params = @{@"amount":@([self.headerView.moneyValue doubleValue]*100),@"type":self.rechargeMethod};
    }else if ([[self.dataList objectAtIndex:self.selectIndex][@"title"] isEqualToString:@"微信充值二"]) {
        url = @"/pay/sixL";
        params = @{@"amount":@([self.headerView.moneyValue doubleValue]*100),@"type":self.rechargeMethod};
    }
    
    [[FNetworkManager sharedManager] postRequestFromServer:url parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
//            if ([self.rechargeMethod isEqualToString:@"alipay"]) {
//                if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"qrUrl"]]){
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"data"][@"qrUrl"]] options:@{} completionHandler:nil];
//                }else if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"payUrl"]]){
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"data"][@"payUrl"]] options:@{} completionHandler:nil];
//                }
            if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"url"]]){
                NSString *payUrl = response[@"data"][@"url"];
                if (![payUrl hasPrefix:@"http://"] && ![payUrl hasPrefix:@"https://"] && ![payUrl hasPrefix:@"alipay://"]) {
                    [[AlipaySDK defaultService] payOrder:payUrl fromScheme:@"pyramid" callback:^(NSDictionary *resultDic) {
                        NSLog(@"resultDic === ：%@", resultDic);
                    }];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:payUrl] options:@{} completionHandler:nil];
                }

                
            }else{
                [SVProgressHUD showErrorWithStatus:@"支付数据为空"];
            }
//            }else {
//                if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"payUrl"]]){
//                    [self showQrcodeView:response[@"data"][@"payUrl"]];
//                }else if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"qrUrl"]]){
//                    [self showQrcodeView:response[@"data"][@"qrUrl"]];;
//                }else if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"url"]]){
//                    [self showQrcodeView:response[@"data"][@"url"]];;
//                }
//            }
            
            
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell radius:11 color:UIColor.whiteColor indexPath:indexPath tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWNewRechargeMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWNewRechargeMethodCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.row][@"title"];
    cell.icnImgView.image = [UIImage imageNamed:[self.dataList objectAtIndex:indexPath.row][@"imageName"]];
    if (self.selectIndex == indexPath.row) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
    if ([[self.dataList objectAtIndex:indexPath.row][@"title"] isEqualToString:@"支付宝充值一"]) {
        self.rechargeMethod = @"alipay";
    }else if ([[self.dataList objectAtIndex:indexPath.row][@"title"] isEqualToString:@"微信充值一"]) {
        self.rechargeMethod = @"wxpay";
    }else if ([[self.dataList objectAtIndex:indexPath.row][@"title"] isEqualToString:@"支付宝充值二"]) {
        self.rechargeMethod = @"alipay";
    }else if ([[self.dataList objectAtIndex:indexPath.row][@"title"] isEqualToString:@"微信充值二"]) {
        self.rechargeMethod = @"wxpay";
    }
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, kTopHeight, kScreenWidth-32, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
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
