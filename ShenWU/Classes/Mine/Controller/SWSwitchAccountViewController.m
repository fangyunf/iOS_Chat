//
//  SWSwitchAccountViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/23.
//

#import "SWSwitchAccountViewController.h"
#import "FSwitchAccountCell.h"
#import "TKAccountDeleteViewController.h"
@interface SWSwitchAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataList;
@end

@implementation SWSwitchAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账号管理";
    
    self.dataList = [NSMutableArray arrayWithArray:[FUserModel sharedUser].getLocalSaveUserArray];
    
    [self.tableView reloadData];
    
//    UIButton *logoutBtn = [FControlTool createButton:@"注销账号" font:[UIFont boldFontWithSize:18] textColor:UIColor.blackColor target:self sel:@selector(logoutBtnAction)];
//    logoutBtn.frame = CGRectMake((kScreenWidth - 300)/2, kScreenHeight - 90 - kBottomSafeHeight, 300, 60);
//    logoutBtn.backgroundColor = RGBColor(0xF2F2F2);
//    logoutBtn.layer.cornerRadius = 30;
//    logoutBtn.layer.masksToBounds = YES;
//    [self.view addSubview:logoutBtn];
}

- (void)logoutBtnAction{
    TKAccountDeleteViewController *vc = [[TKAccountDeleteViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count+1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    FSwitchAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FSwitchAccountCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    cell.tag = indexPath.row;
    cell.titleLabel.hidden = YES;
    cell.deleteBtn.hidden = YES;
    cell.tagLabel.hidden = YES;
    cell.nameLabel.hidden = NO;
    cell.idLabel.hidden = NO;
    if (self.dataList.count == indexPath.row) {
        cell.nameLabel.hidden = YES;
        cell.idLabel.hidden = YES;
        cell.avatarImgView.image = [UIImage imageNamed:@"icn_add_acount"];
        cell.titleLabel.hidden = NO;
        cell.bgView.backgroundColor = [UIColor whiteColor];
    }else{
        cell.bgView.backgroundColor = RGBColor(0xf6f6f6);
        FNormalUserModel *normalModel = [self.dataList objectAtIndex:indexPath.row];
        cell.nameLabel.text = normalModel.nickName;
        if (![FDataTool isNull:normalModel.headerIcon]) {
            [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:normalModel.headerIcon] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
        }else{
            [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
        }
        
        cell.idLabel.text = [NSString stringWithFormat:@"ID:%@",normalModel.memberCode];
        if ([normalModel.userID isEqualToString:[FUserModel sharedUser].userID]) {
            cell.tagLabel.hidden = NO;
        }else{
            cell.deleteBtn.hidden = NO;
        }
    }
    @weakify(self)
    cell.deleteBlock = ^(NSInteger index) {
        FNormalUserModel *model = [weak_self.dataList objectAtIndex:index];
        [[FUserModel sharedUser] deletedLocalAccountOnUser:model];
        [weak_self.dataList removeObjectAtIndex:index];
        [weak_self.tableView reloadData];
    };
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataList.count == indexPath.row) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加账号需要退出当前账号，是否确认退出" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }else{
        __block FUserModel *userModel = [FUserModel sharedUser].getLocalSaveUserArray[indexPath.row];
        if ([userModel.userID isEqualToString:[FUserModel sharedUser].userID]) {
            return;
        }
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示：" message:@"是否切换账号？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:@{@"token":userModel.token,@"phone":userModel.phone}];
            [FUserModel sharedUser].phone = userModel.phone;
            kUserDefaultSetObjectForKey(userModel.token, UserToken);
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:sure];
        [alertVc addAction:cancel];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
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
