//
//  SWSecurityPrivacyViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/23.
//

#import "SWSecurityPrivacyViewController.h"
#import "SWSecurityPrivacyCell.h"
#import "FAccountSafeModel.h"
#import "SWBlackListViewController.h"
@interface SWSecurityPrivacyViewController ()<UITableViewDelegate,UITableViewDataSource,SWSecurityPrivacyCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *topSwitchBtn;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, strong) FAccountSafeModel *model;
@end

@implementation SWSecurityPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"隐私设置";
    
    self.view.backgroundColor = RGBColor(0xf2f2f2);
    
//    UIImageView *bgImgView = [[UIImageView alloc] init];
//    bgImgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
////    bgImgView.image = [UIImage imageNamed:@"bg_mine"];
//    bgImgView.backgroundColor = RGBColor(0xf2f2f2);
//    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
//    bgImgView.layer.masksToBounds = YES;
//    [self.view addSubview:bgImgView];
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(15, kTopHeight+14, kScreenWidth-30, 74);
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 5;
    topView.layer.masksToBounds = YES;
    [self.view addSubview:topView];
    
    UILabel *topTitleLabel = [FControlTool createLabel:@"添加我为好友" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    topTitleLabel.frame = CGRectMake(10, 20, topView.width-72, 14);
    [topView addSubview:topTitleLabel];
    
    self.topSwitchBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_off"] target:self sel:@selector(topSwitchBtnAction)];
    self.topSwitchBtn.frame = CGRectMake(topView.width - 55, 27, 34, 20);
    [self.topSwitchBtn setImage:[UIImage imageNamed:@"icn_on"] forState:UIControlStateSelected];
    [topView addSubview:self.topSwitchBtn];
    
    UILabel *detailLabel = [FControlTool createLabel:@"开启后 对方加我为好友需要我同意" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:12]];
    detailLabel.frame = CGRectMake(10, topTitleLabel.bottom+7, topView.width-72, 12);
    [topView addSubview:detailLabel];
    
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(15, topView.bottom+10, kScreenWidth-30, 164+49+15);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"添加我为好友的方式" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    titleLabel.frame = CGRectMake(10, 20, topView.width-72, 14);
    [bgView addSubview:titleLabel];
    
    [self.view addSubview:self.tableView];
    
    self.dataList = @[@[@"手机号",@"二维码",@"ID",@"名片"]];//@[@"是否开启被添加好友功能",@"是否开启加入群聊功能"]
    
    self.tableView.frame = CGRectMake(15, topView.bottom+59, kScreenWidth-30, kScreenHeight - (topView.bottom+59));
    [self.tableView reloadData];
    
    [self requestData];
}

- (void)requestData{
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] getRequestFromServer:@"/home/securityPrivacy" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.model = [FAccountSafeModel modelWithDictionary:response[@"data"]];
            [SVProgressHUD dismiss];
            [weak_self.tableView reloadData];
            [weak_self.topSwitchBtn setSelected:self.model.check];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)topSwitchBtnAction{
    NSDictionary *params = @{@"check":@(!self.topSwitchBtn.selected)};
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/changeSecurityPrivacy" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [self.topSwitchBtn setSelected:!self.topSwitchBtn.selected];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - SWSecurityPrivacyCellDelegate
- (void)switchHandleAction:(SWSecurityPrivacyCell *)cell{
    NSDictionary *params = nil;
    if ([cell.titleLabel.text isEqualToString:@"添加我时需验证"]) {
        params = @{@"check":@(!cell.switchBtn.selected)};
    }else if ([cell.titleLabel.text isEqualToString:@"手机号"]) {
        params = @{@"phoneAdd":@(!cell.switchBtn.selected)};
    }else if ([cell.titleLabel.text isEqualToString:@"ID"]) {
        params = @{@"idAdd":@(!cell.switchBtn.selected)};
    }else if ([cell.titleLabel.text isEqualToString:@"名片"]) {
        params = @{@"cardAdd":@(!cell.switchBtn.selected)};
    }else if ([cell.titleLabel.text isEqualToString:@"二维码"]) {
        params = @{@"qrAdd":@(!cell.switchBtn.selected)};
    }else if ([cell.titleLabel.text isEqualToString:@"是否开启被添加好友功能"]) {
        params = @{@"addState":@(!cell.switchBtn.selected)};
    }else if ([cell.titleLabel.text isEqualToString:@"是否开启加入群聊功能"]) {
        params = @{@"addGroupState":@(!cell.switchBtn.selected)};
    }
    
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/changeSecurityPrivacy" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [cell.switchBtn setSelected:!cell.switchBtn.selected];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList[section] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell radius:5 color:UIColor.whiteColor indexPath:indexPath tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWSecurityPrivacyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWSecurityPrivacyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.titleLabel.text = [self.dataList[indexPath.section] objectAtIndex:indexPath.row];
    cell.arrowImgView.hidden = YES;
    cell.switchBtn.hidden = NO;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.switchBtn setSelected:self.model.phoneAdd];
        }else if (indexPath.row == 1) {
            [cell.switchBtn setSelected:self.model.qrAdd];
        }else if (indexPath.row == 2) {
            [cell.switchBtn setSelected:self.model.idAdd];
        }else if (indexPath.row == 3) {
            [cell.switchBtn setSelected:self.model.cardAdd];
        }
    }else{
        if (indexPath.row == 0) {
            [cell.switchBtn setSelected:self.model.addState];
        }else if (indexPath.row == 1) {
            [cell.switchBtn setSelected:self.model.addGroupState];
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth-30, 164) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        
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
