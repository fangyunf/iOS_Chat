//
//  TKMessageSettingViewController.m
//  ShenWU
//
//  Created by Amy on 2024/8/1.
//

#import "TKMessageSettingViewController.h"
#import "SWSecurityPrivacyCell.h"
@interface TKMessageSettingViewController ()<UITableViewDelegate,UITableViewDataSource,SWSecurityPrivacyCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@end

@implementation TKMessageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天设置";
    self.view.backgroundColor = RGBColor(0xf2f2f2);
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.layer.masksToBounds = YES;
    [self.view addSubview:bgImgView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(15, kTopHeight+14, kScreenWidth-30, 213-64);
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    self.dataList = @[@"消息声音",@"消息震动"];
    
    [self.tableView reloadData];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(15, bgView.bottom+15, kScreenWidth-30, 61);
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.layer.cornerRadius = 5;
    footerView.layer.masksToBounds = YES;
    [self.view addSubview:footerView];
    
    UIButton *clearBtn = [FControlTool createButton:@"清除聊天记录" font:[UIFont boldFontWithSize:14] textColor:RGBColor(0x333333) target:self sel:@selector(clearBtnAction)];
    clearBtn.frame = CGRectMake(10, 0, footerView.width-20, 61);
    clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [footerView addSubview:clearBtn];
    
    UIImageView *arrowImgView = [[UIImageView alloc] init];
    arrowImgView.frame = CGRectMake(footerView.width - 33, 20.5, 21, 20);
    arrowImgView.image = [UIImage imageNamed:@"icn_mine_arrow"];
    [footerView addSubview:arrowImgView];
    
    [self requestData];
}

- (void)clearBtnAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"清除聊天记录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
        option.removeTable = YES;
        [[NIMSDK sharedSDK].conversationManager deleteAllMessages:option];
        [[NSNotificationCenter defaultCenter] postNotificationName:FClearMsgRecord object:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
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
    return 61;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWSecurityPrivacyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWSecurityPrivacyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.row];
    cell.arrowImgView.hidden = YES;
    cell.switchBtn.hidden = NO;
    cell.detailLabel.hidden = NO;
    cell.titleLabel.frame = CGRectMake(12, 14, kScreenWidth-72, 15);
    cell.detailLabel.frame = CGRectMake(12, 34, kScreenWidth-72, 13);
    cell.detailLabel.textAlignment = NSTextAlignmentLeft;
    cell.switchBtn.frame = CGRectMake(kScreenWidth - 30 - 55, 14, 40, 19);
    if (indexPath.row == 0) {
        cell.detailLabel.text = @"开启后 有新消息将会收到声音";
        [cell.switchBtn setSelected:![FUserModel sharedUser].sound];
    }else{
        cell.detailLabel.text = @"开启后 有新消息将会收到震动";
        [cell.switchBtn setSelected:![FUserModel sharedUser].shake];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, kTopHeight+29, kScreenWidth-30, 183-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
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
