//
//  TKPasswordSettingViewController.m
//  ShenWU
//
//  Created by Amy on 2024/8/1.
//

#import "TKPasswordSettingViewController.h"
#import "FForgotPasswordViewController.h"
#import "SWPayPasswordViewController.h"
#import "SWMySettingCell.h"
#import "TKAccountDeleteViewController.h"
@interface TKPasswordSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@end

@implementation TKPasswordSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"密码设置";
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    bgImgView.image = [UIImage imageNamed:@"bg_mine"];
    bgImgView.backgroundColor = RGBColor(0xffffff);
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.layer.masksToBounds = YES;
    [self.view addSubview:bgImgView];
     
    self.dataList = @[@{@"title":@"设置登录密码",@"imageName":@"icn_setting_login"},@{@"title":@"设置支付密码",@"imageName":@"icn_setting_pay"}];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWMySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWMySettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    NSDictionary *dict = self.dataList[indexPath.row];
    cell.titleLabel.text = dict[@"title"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        FForgotPasswordViewController *vc = [[FForgotPasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        SWPayPasswordViewController *vc = [[SWPayPasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        TKAccountDeleteViewController *vc = [[TKAccountDeleteViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight+14, kScreenWidth, kScreenHeight-kTopHeight-14) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
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
