//
//  BasicSettingsViewController.m
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import "BasicSettingsViewController.h"
#import "FControlTool.h"
#import "BasicSettingsCell.h"
#import <YYKit/YYKit.h>

@interface BasicSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation BasicSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 194) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[BasicSettingsCell class] forCellReuseIdentifier:@"BasicSettingsCell"];
    
    [self.view addSubview:self.tableView];
}

- (void)loadData {
    self.dataSource = [NSMutableArray arrayWithArray:@[
        @{@"title": @"授权码", @"type": @"button", @"placeholder": @"请授权", @"value": @""},
        @{@"title": @"总开关", @"type": @"switch", @"value": @(NO)},
        @{@"title": @"红包提醒", @"type": @"switch", @"value": @(NO)},
        @{@"title": @"后台抢包", @"type": @"switch", @"value": @(NO)},
        @{@"title": @"说明", @"type": @"description", @"value": @"1.注意:本插件只做研究之用，请于下载测试完毕后删除，如有非法使用，后果自负!\n2.任何功能必须在使用时打开总开关\n3.红包提醒打开后有语音播报和文字提醒\n4.后台抢包打开后可后台进行工作"}
    ]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BasicSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicSettingsCell" forIndexPath:indexPath];
    NSDictionary *data = self.dataSource[indexPath.row];
    [cell configureWithData:data];
    
    __weak typeof(self) weakSelf = self;
    cell.valueChangedBlock = ^(id value) {
        [weakSelf updateDataAtIndex:indexPath.row withValue:value];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.dataSource[indexPath.row];
    if ([data[@"type"] isEqualToString:@"description"]) {
        return 120;
    }
    return 80;
}

- (void)updateDataAtIndex:(NSInteger)index withValue:(id)value {
    NSMutableDictionary *data = [self.dataSource[index] mutableCopy];
    data[@"value"] = value;
    self.dataSource[index] = data;
    
    // Validate and save data
    [self validateAndSaveData];
}

- (void)validateAndSaveData {
    // Implement validation logic
    for (NSDictionary *data in self.dataSource) {
        if ([data[@"type"] isEqualToString:@"textField"]) {
            NSString *value = data[@"value"];
            if ([data[@"title"] isEqualToString:@"授权码"] && value.length == 0) {
                [self showErrorMessage:@"授权码不能为空"];
                return;
            }
        }
    }
    
    // Save to UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:self.dataSource forKey:@"BasicSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showErrorMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

@end
