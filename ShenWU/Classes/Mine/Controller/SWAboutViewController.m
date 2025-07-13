//
//  SWAboutViewController.m
//  ShenWU
//
//  Created by Amy on 2025/2/10.
//

#import "SWAboutViewController.h"

@interface SWAboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *linkUrls;
@property(nonatomic, strong) NSString *iosUrl;
@property(nonatomic, strong) NSString *androidUrl;
@end

@implementation SWAboutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    
    self.linkUrls = [[NSMutableArray alloc] init];
    
//    [self requestData];
    self.iosUrl = @"https://testflight.apple.com/join/SNpRmSS6";
    self.androidUrl = @"http://sxa.sixeight.cn/fanyu.apk";
    [self.view addSubview:self.tableView];
}

- (void)requestData{
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/customer/about" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"linkUrl"]]) {
                [weak_self.linkUrls addObjectsFromArray:response[@"data"][@"linkUrl"]];
                for (NSDictionary *dic in weak_self.linkUrls) {
                    if (![FDataTool isNull:dic[@"appType"]] && [dic[@"appType"] isEqualToString:@"IOS"]) {
                        weak_self.iosUrl = dic[@"downloadUrl"];
                    }
                    if (![FDataTool isNull:dic[@"appType"]] && [dic[@"appType"] isEqualToString:@"ANDROID"]) {
                        weak_self.androidUrl = dic[@"downloadUrl"];
                    }
                }
            }
            [SVProgressHUD dismiss];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)androidBtnAction{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.androidUrl];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (void)iosBtnAction{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.iosUrl];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.font = [UIFont semiBoldFontWithSize:16];
    cell.textLabel.textColor = UIColor.blackColor;
    cell.detailTextLabel.font = [UIFont boldFontWithSize:12];
    cell.detailTextLabel.textColor = RGBColor(0x999999);
    if (indexPath.row == 0) {
        cell.textLabel.text = @"官网地址";
        cell.detailTextLabel.text = @"";
        
        UIButton *androidBtn = [FControlTool createButton:@"android复制" font:[UIFont boldFontWithSize:12] textColor:kMainColor target:self sel:@selector(androidBtnAction)];
        androidBtn.frame = CGRectMake(kScreenWidth - 83, 0, 68, 50);
        [cell.contentView addSubview:androidBtn];
        
        UIButton *iosBtn = [FControlTool createButton:@"iOS复制" font:[UIFont boldFontWithSize:12] textColor:kMainColor target:self sel:@selector(iosBtnAction)];
        iosBtn.frame = CGRectMake(androidBtn.left - 65, 0, 45, 50);
        [cell.contentView addSubview:iosBtn];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"版本号";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",AppVersion];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = RGBColor(0xE6E6E6);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 18, 0, 18);
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
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
