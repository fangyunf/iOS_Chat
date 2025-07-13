//
//  SWAddressManageViewController.m
//  ShenWU
//
//  Created by Amy on 2024/11/8.
//

#import "SWAddressManageViewController.h"
#import "SWAddressManageCell.h"
#import "ShenWU-Swift.h"
@interface SWAddressManageViewController ()<UITableViewDelegate,UITableViewDataSource,SWAddressManageCellDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) NSMutableArray *dataModelList;
@end

@implementation SWAddressManageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.dataList removeAllObjects];
    [self.dataModelList removeAllObjects];
    if (kUserDefaultObjectForKey(@"kAddress")) {
        [self.dataList addObjectsFromArray:kUserDefaultObjectForKey(@"kAddress")];
    }
    
    for (NSDictionary *data in self.dataList) {
        SWAddressModel *model = [SWAddressModel modelWithDictionary:data];
        [self.dataModelList addObject:model];
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    
    self.dataList = [[NSMutableArray alloc] init];
    self.dataModelList = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = RGBColor(0xF0F0F0);
    
    [self.view addSubview:self.tableView];
    
    UIButton *addBtn = [FControlTool createButton:@"新增地址" font:[UIFont boldFontWithSize:15] textColor:UIColor.whiteColor target:self sel:@selector(addBtnAction)];
    addBtn.frame = CGRectMake(37, kScreenHeight - 70 - kBottomSafeHeight, kScreenWidth - 74, 60);
    [addBtn rounded:25];
    addBtn.backgroundColor = RGBColor(0xB09964);
    [self.view addSubview:addBtn];
}

- (void)addBtnAction{
    MWAddAddressViewController *vc = [[MWAddAddressViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SWAddressManageCellDelegate
- (void)editAddress:(SWAddressManageCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MWAddAddressViewController *vc = [[MWAddAddressViewController alloc] init];
    vc.isEdit = YES;
    vc.editData = [self.dataList objectAtIndex:indexPath.row];
    vc.editIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteAddress:(SWAddressManageCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.dataList removeObjectAtIndex:indexPath.row];
    [self.dataModelList removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    
    kUserDefaultSetObjectForKey(self.dataList, @"kAddress");
}

- (void)defaultAddress:(SWAddressManageCell *)cell{
    [self.dataList removeAllObjects];
    for (SWAddressModel *model in self.dataModelList) {
        model.isDefault = NO;
        [self.dataList addObject:model.modelToJSONObject];
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    SWAddressModel *model = [self.dataModelList objectAtIndex:indexPath.row];
    model.isDefault = YES;
    
    [self.dataList replaceObjectAtIndex:indexPath.row withObject:model.modelToJSONObject];
    
    [self.tableView reloadData];
    
    kUserDefaultSetObjectForKey(self.dataList, @"kAddress");
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataModelList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWAddressManageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWAddressManageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBColor(0xF0F0F0);
        cell.delegate = self;
    }
    [cell refreshCellWithData:self.dataModelList[indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock) {
        self.selectBlock(self.dataModelList[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(0xF0F0F0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 134)];
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
