//
//  PackageSettingsViewController.m
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import "PackageSettingsViewController.h"
#import "FControlTool.h"
#import "PackageSettingsCell.h"
#import <YYKit/YYKit.h>

@interface PackageSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PackageSettingsViewController

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
    [self.tableView registerClass:[PackageSettingsCell class] forCellReuseIdentifier:@"PackageSettingsCell"];
    
    [self.view addSubview:self.tableView];
}

- (void)loadData {
    self.dataSource = [NSMutableArray arrayWithArray:@[
        @{@"title": @"自动发包密码", @"type": @"textField", @"placeholder": @"", @"value": @""},
        @{@"title": @"自动发包间隔", @"type": @"textField", @"placeholder": @"输入间隔（默认5秒）", @"value": @""},
        @{@"title": @"输入金额", @"type": @"textField", @"placeholder": @"", @"value": @""},
        @{@"title": @"红包语金额", @"type": @"textField", @"placeholder": @"输入红包语金额", @"value": @""},
        @{@"title": @"红包个数", @"type": @"textField", @"placeholder": @"输入红包个数", @"value": @""},
        @{@"title": @"分隔符", @"type": @"textField", @"placeholder": @"设置分隔符（比如、-）", @"value": @""},
        @{@"title": @"全雷值模式", @"type": @"switch", @"value": @(NO)},
        @{@"title": @"固定雷值", @"type": @"textFieldWithSwitch", @"placeholder": @"输入固定雷值", @"value": @"", @"switchValue": @(NO)},
        @{@"title": @"循环雷值", @"type": @"textFieldWithSwitch", @"placeholder": @"输入雷值，多个用符号/...", @"value": @"", @"switchValue": @(NO)},
        @{@"title": @"随机雷值", @"type": @"segmentWithSwitch", @"options": @[@"单雷", @"双雷", @"三雷", @"四雷", @"五雷"], @"selectedIndex": @(0), @"switchValue": @(NO)},
        @{@"title": @"发包说明", @"type": @"description", @"value": @"1.全雷值模式=不带金额\n2.循环雷值请用/分割：比如567/789/912\n3.设置好后手动发一次红包/然后点群里的发按钮运行"}
    ]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PackageSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PackageSettingsCell" forIndexPath:indexPath];
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
    NSString *type = data[@"type"];
    
    if ([type isEqualToString:@"description"]) {
        return 100;
    } else if ([type isEqualToString:@"segmentWithSwitch"]) {
        return 100;
    }
    return 80;
}

- (void)updateDataAtIndex:(NSInteger)index withValue:(id)value {
    NSMutableDictionary *data = [self.dataSource[index] mutableCopy];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *valueDict = (NSDictionary *)value;
        if (valueDict[@"value"]) {
            data[@"value"] = valueDict[@"value"];
        }
        if (valueDict[@"switchValue"]) {
            data[@"switchValue"] = valueDict[@"switchValue"];
        }
        if (valueDict[@"selectedIndex"]) {
            data[@"selectedIndex"] = valueDict[@"selectedIndex"];
        }
    } else {
        data[@"value"] = value;
    }
    
    self.dataSource[index] = data;
    [self validateAndSaveData];
}

- (void)validateAndSaveData {
    // Implement validation logic
    for (NSDictionary *data in self.dataSource) {
        NSString *type = data[@"type"];
        if ([type isEqualToString:@"textField"] || [type isEqualToString:@"textFieldWithSwitch"]) {
            NSString *value = data[@"value"];
            NSString *title = data[@"title"];
            
            if ([title isEqualToString:@"自动发包间隔"]) {
                if (value.length > 0 && [value integerValue] < 1) {
                    [self showErrorMessage:@"发包间隔不能小于1秒"];
                    return;
                }
            } else if ([title isEqualToString:@"红包个数"]) {
                if (value.length > 0 && ([value integerValue] < 1 || [value integerValue] > 100)) {
                    [self showErrorMessage:@"红包个数必须在1-100之间"];
                    return;
                }
            }
        }
    }
    
    // Save to UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:self.dataSource forKey:@"PackageSettings"];
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
