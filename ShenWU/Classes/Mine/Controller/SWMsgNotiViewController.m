//
//  SWMsgNotiViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/23.
//

#import "SWMsgNotiViewController.h"
#import "SWSecurityPrivacyCell.h"
@interface SWMsgNotiViewController ()<UITableViewDelegate,UITableViewDataSource,SWSecurityPrivacyCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@end

@implementation SWMsgNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新消息通知";
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(15, kTopHeight+14, kScreenWidth-30, 285);
    bgView.backgroundColor = RGBColor(0xF2F2F2);
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    self.dataList = @[@"新消息通知",@"声音",@"震动"];
    
    [self.tableView reloadData];
    
    [self requestData];
}

- (void)requestData{
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] getRequestFromServer:@"/home/selectSoundSwith" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            FUserModel *model = [FUserModel modelWithDictionary:response[@"data"]];
            [FUserModel sharedUser].allDisturb = model.allDisturb;
            [FUserModel sharedUser].sound = model.sound;
            [FUserModel sharedUser].shake = model.shake;
            [SVProgressHUD dismiss];
            [weak_self.tableView reloadData];
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
    if ([cell.titleLabel.text isEqualToString:@"消息通知"]) {
        if (cell.switchBtn.selected) {
            params = @{@"allDisturb":@(0)};
        }else{
            params = @{@"allDisturb":@(1)};
        }
    }else if ([cell.titleLabel.text isEqualToString:@"消息声音"]) {
        if (cell.switchBtn.selected) {
            params = @{@"sound":@(1)};
        }else{
            params = @{@"sound":@(0)};
        }
        
    }else if ([cell.titleLabel.text isEqualToString:@"消息震动"]) {
        if (cell.switchBtn.selected) {
            params = @{@"shake":@(1)};
        }else{
            params = @{@"shake":@(0)};
        }
    }
    
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/soundSwitch" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [cell.switchBtn setSelected:!cell.switchBtn.selected];
            if (params[@"sound"]) {
                [FUserModel sharedUser].sound = ![FUserModel sharedUser].sound;
            }
            if (params[@"shake"]) {
                [FUserModel sharedUser].shake = ![FUserModel sharedUser].shake;
            }
            if (params[@"allDisturb"]) {
                [cell.switchBtn setSelected:YES];
                [FUserModel sharedUser].allDisturb = YES;
            }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 61;
    }
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWSecurityPrivacyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWSecurityPrivacyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBColor(0xf2f2f2);
        cell.delegate = self;
    }
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.row];
    cell.arrowImgView.hidden = YES;
    cell.switchBtn.hidden = NO;
    if (indexPath.row == 0) {
        cell.detailLabel.hidden = NO;
        cell.titleLabel.frame = CGRectMake(12, 14, kScreenWidth-72, 15);
        cell.detailLabel.frame = CGRectMake(12, 34, kScreenWidth-72, 13);
        cell.detailLabel.text = @"关闭后，手机将不接收消息通知";
        cell.detailLabel.textAlignment = NSTextAlignmentLeft;
        cell.switchBtn.frame = CGRectMake(kScreenWidth - 30 - 55, 14, 40, 19);
        [cell.switchBtn setSelected:[FUserModel sharedUser].allDisturb];
    }else {
        if (indexPath.row == 0) {
            [cell.switchBtn setSelected:[FUserModel sharedUser].sound];
        }else{
            [cell.switchBtn setSelected:[FUserModel sharedUser].shake];
        }
        cell.detailLabel.hidden = YES;
        cell.titleLabel.frame = CGRectMake(12, 0, kScreenWidth-72, 44);
        cell.switchBtn.frame = CGRectMake(kScreenWidth - 30 - 55, 12.5, 40, 19);
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != self.dataList.count-1) {
        
    }
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, kTopHeight+29, kScreenWidth-30, 255) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(0xf2f2f2);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
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
