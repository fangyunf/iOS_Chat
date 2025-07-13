//
//  PSystomNotiViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/20.
//

#import "PSystomNotiViewController.h"
#import "PSystomNotiCell.h"
@interface PSystomNotiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataList;
@end

@implementation PSystomNotiViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统公告";
    self.view.backgroundColor = RGBColor(0xf2f2f2);
    self.dataList = [[NSMutableArray alloc] init];
    
    [self.tableView reloadData];
    
    [self requestData];
}

- (void)requestData{
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] getRequestFromServer:@"/customer/noticeList" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            for (NSDictionary *data in response[@"data"]) {
                PSystomNotiModel *model = [PSystomNotiModel modelWithDictionary:data];
                CGSize size = [model.content sizeForFont:[UIFont fontWithSize:13] size:CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
                model.contentHeight = size.height;
                [self.dataList addObject:model];
            }
            kUserDefaultSetObjectForKey(@(self.dataList.count), SYSNOTINUM);
            [weak_self.tableView reloadData];
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
    PSystomNotiModel *model = [self.dataList objectAtIndex:indexPath.row];
    return 158+40+(model.contentHeight > 90?(model.contentHeight-90):0);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    PSystomNotiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PSystomNotiCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBColor(0xf2f2f2);
        
    }
    [cell refreshCellWithData:[self.dataList objectAtIndex:indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight+10, kScreenWidth, kScreenHeight-kTopHeight-10) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(0xf2f2f2);
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
