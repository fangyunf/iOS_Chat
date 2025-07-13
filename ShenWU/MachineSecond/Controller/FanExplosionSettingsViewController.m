//
//  FanExplosionSettingsViewController.m
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import "FanExplosionSettingsViewController.h"
#import "FControlTool.h"
#import "FanExplosionSettingsCell.h"
#import <YYKit/YYKit.h>

@interface FanExplosionSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *savedGroupData;

@end

@implementation FanExplosionSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
    [self loadSavedGroupData];
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
    [self.tableView registerClass:[FanExplosionSettingsCell class] forCellReuseIdentifier:@"FanExplosionSettingsCell"];
    
    [self.view addSubview:self.tableView];
}

- (void)loadData {
    self.dataSource = [NSMutableArray arrayWithArray:@[
        @{@"title": @"普通人群爆粉", @"type": @"explosionMode", @"placeholder": @"本地爆粉|区人群爆粉", @"value": @"本地爆粉|区人群爆粉", @"mode": @"normal"},
        @{@"title": @"精准人群爆粉", @"type": @"explosionMode", @"placeholder": @"精准人群区爆粉", @"value": @"精准人群区爆粉", @"mode": @"precise"},
        @{@"title": @"自选人群爆粉", @"type": @"explosionMode", @"placeholder": @"自选人群区爆粉", @"value": @"自选人群区爆粉", @"mode": @"custom"},
        @{@"title": @"添加精准人群", @"type": @"switch", @"value": @(NO)},
        @{@"title": @"爆粉说明", @"type": @"description", @"value": @"1 普通人群-点一下群里的爆保存当前爆粉数据\n2 精准人群-打开开关后自动保存所有群友包的爆粉数据\n3 如果需要大小号切换-请先用大号添加好数据后：一直接切换账号写到小号在爆粉区进行爆粉\n4 平台限制，每60秒添加1个好友"}
    ]];
}

- (void)loadSavedGroupData {
    // Load saved group data from UserDefaults
    NSArray *saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"FanExplosionGroupData"];
    if (saved) {
        self.savedGroupData = [saved mutableCopy];
    } else {
        self.savedGroupData = [NSMutableArray array];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FanExplosionSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FanExplosionSettingsCell" forIndexPath:indexPath];
    NSDictionary *data = self.dataSource[indexPath.row];
    [cell configureWithData:data];
    
    __weak typeof(self) weakSelf = self;
    cell.valueChangedBlock = ^(id value) {
        [weakSelf updateDataAtIndex:indexPath.row withValue:value];
    };
    
    cell.explosionModeSelectedBlock = ^(NSString *mode) {
        [weakSelf handleExplosionModeSelection:mode atIndex:indexPath.row];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.dataSource[indexPath.row];
    NSString *type = data[@"type"];
    
    if ([type isEqualToString:@"description"]) {
        return 140;
    } else if ([type isEqualToString:@"explosionMode"]) {
        return 100;
    }
    return 80;
}

- (void)updateDataAtIndex:(NSInteger)index withValue:(id)value {
    NSMutableDictionary *data = [self.dataSource[index] mutableCopy];
    data[@"value"] = value;
    self.dataSource[index] = data;
    
    [self validateAndSaveData];
}

- (void)handleExplosionModeSelection:(NSString *)mode atIndex:(NSInteger)index {
    NSDictionary *data = self.dataSource[index];
    NSString *modeType = data[@"mode"];
    
    if ([modeType isEqualToString:@"normal"]) {
        [self handleNormalGroupExplosion];
    } else if ([modeType isEqualToString:@"precise"]) {
        [self handlePreciseGroupExplosion];
    } else if ([modeType isEqualToString:@"custom"]) {
        [self handleCustomGroupExplosion];
    }
}

- (void)handleNormalGroupExplosion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"普通人群爆粉" 
                                                                   message:@"点击确定将保存当前群的爆粉数据" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" 
                                              style:UIAlertActionStyleCancel 
                                            handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" 
                                              style:UIAlertActionStyleDefault 
                                            handler:^(UIAlertAction * _Nonnull action) {
        [self saveCurrentGroupData:@"normal"];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handlePreciseGroupExplosion {
    // Check if precise mode is enabled
    BOOL preciseEnabled = NO;
    for (NSDictionary *data in self.dataSource) {
        if ([data[@"title"] isEqualToString:@"添加精准人群"]) {
            preciseEnabled = [data[@"value"] boolValue];
            break;
        }
    }
    
    if (!preciseEnabled) {
        [self showErrorMessage:@"请先开启\"添加精准人群\"开关"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"精准人群爆粉" 
                                                                   message:@"将自动保存所有群友的爆粉数据，这可能需要一些时间" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" 
                                              style:UIAlertActionStyleCancel 
                                            handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"开始" 
                                              style:UIAlertActionStyleDefault 
                                            handler:^(UIAlertAction * _Nonnull action) {
        [self startPreciseGroupDataCollection];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleCustomGroupExplosion {
    [self showCustomGroupSelectionInterface];
}

- (void)saveCurrentGroupData:(NSString *)type {
    // Simulate saving current group data
    NSDictionary *groupData = @{
        @"type": type,
        @"timestamp": @([[NSDate date] timeIntervalSince1970]),
        @"groupId": [self generateGroupId],
        @"memberCount": @([self simulateGroupMemberCount]),
        @"status": @"saved"
    };
    
    [self.savedGroupData addObject:groupData];
    [self saveGroupDataToPersistence];
    
    [self showSuccessMessage:[NSString stringWithFormat:@"%@群数据保存成功", [self getGroupTypeDisplayName:type]]];
}

- (void)startPreciseGroupDataCollection {
    // Show progress indicator
    UIAlertController *progressAlert = [UIAlertController alertControllerWithTitle:@"正在收集数据" 
                                                                           message:@"请稍候..." 
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:progressAlert animated:YES completion:nil];
    
    // Simulate data collection process
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [progressAlert dismissViewControllerAnimated:YES completion:^{
            [self saveCurrentGroupData:@"precise"];
        }];
    });
}

- (void)showCustomGroupSelectionInterface {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自选人群爆粉" 
                                                                   message:@"请选择要进行爆粉的群组" 
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Add saved groups as options
    for (NSDictionary *groupData in self.savedGroupData) {
        NSString *groupType = [self getGroupTypeDisplayName:groupData[@"type"]];
        NSString *groupId = groupData[@"groupId"];
        NSString *title = [NSString stringWithFormat:@"%@ - %@", groupType, groupId];
        
        [alert addAction:[UIAlertAction actionWithTitle:title 
                                                  style:UIAlertActionStyleDefault 
                                                handler:^(UIAlertAction * _Nonnull action) {
            [self executeCustomGroupExplosion:groupData];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" 
                                              style:UIAlertActionStyleCancel 
                                            handler:nil]];
    
    // For iPad compatibility
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 1, 1);
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)executeCustomGroupExplosion:(NSDictionary *)groupData {
    NSString *groupType = [self getGroupTypeDisplayName:groupData[@"type"]];
    NSString *message = [NSString stringWithFormat:@"开始对%@群进行爆粉操作", groupType];
    
    UIAlertController *confirmAlert = [UIAlertController alertControllerWithTitle:@"确认爆粉" 
                                                                          message:message 
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    [confirmAlert addAction:[UIAlertAction actionWithTitle:@"取消" 
                                                     style:UIAlertActionStyleCancel 
                                                   handler:nil]];
    
    [confirmAlert addAction:[UIAlertAction actionWithTitle:@"开始爆粉" 
                                                     style:UIAlertActionStyleDefault 
                                                   handler:^(UIAlertAction * _Nonnull action) {
        [self startExplosionProcess:groupData];
    }]];
    
    [self presentViewController:confirmAlert animated:YES completion:nil];
}

- (void)startExplosionProcess:(NSDictionary *)groupData {
    // Show progress with timer
    UIAlertController *progressAlert = [UIAlertController alertControllerWithTitle:@"爆粉进行中" 
                                                                           message:@"正在添加好友，请稍候...\n注意：每60秒添加1个好友" 
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:progressAlert animated:YES completion:nil];
    
    // Simulate explosion process with 60-second intervals
    __block NSInteger friendCount = 0;
    NSInteger totalFriends = [groupData[@"memberCount"] integerValue];
    
    NSTimer *explosionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        friendCount++;
        
        NSString *message = [NSString stringWithFormat:@"正在添加好友，请稍候...\n进度：%ld/%ld\n注意：每60秒添加1个好友", (long)friendCount, (long)totalFriends];
        progressAlert.message = message;
        
        if (friendCount >= totalFriends || friendCount >= 10) { // Limit for demo
            [timer invalidate];
            [progressAlert dismissViewControllerAnimated:YES completion:^{
                [self showSuccessMessage:[NSString stringWithFormat:@"爆粉完成！成功添加 %ld 个好友", (long)friendCount]];
            }];
        }
    }];
    
    // Add cancel button to stop the process
    [progressAlert addAction:[UIAlertAction actionWithTitle:@"停止" 
                                                      style:UIAlertActionStyleDestructive 
                                                    handler:^(UIAlertAction * _Nonnull action) {
        [explosionTimer invalidate];
        [self showErrorMessage:@"爆粉过程已停止"];
    }]];
}

#pragma mark - Helper Methods

- (NSString *)generateGroupId {
    return [NSString stringWithFormat:@"GROUP_%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

- (NSInteger)simulateGroupMemberCount {
    return arc4random_uniform(50) + 10; // Random between 10-60
}

- (NSString *)getGroupTypeDisplayName:(NSString *)type {
    if ([type isEqualToString:@"normal"]) {
        return @"普通人群";
    } else if ([type isEqualToString:@"precise"]) {
        return @"精准人群";
    } else if ([type isEqualToString:@"custom"]) {
        return @"自选人群";
    }
    return @"未知类型";
}

- (void)saveGroupDataToPersistence {
    [[NSUserDefaults standardUserDefaults] setObject:self.savedGroupData forKey:@"FanExplosionGroupData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)validateAndSaveData {
    // Validate fan explosion settings
    BOOL preciseEnabled = NO;
    for (NSDictionary *data in self.dataSource) {
        if ([data[@"title"] isEqualToString:@"添加精准人群"]) {
            preciseEnabled = [data[@"value"] boolValue];
            break;
        }
    }
    
    // Save settings to UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:self.dataSource forKey:@"FanExplosionSettings"];
    [[NSUserDefaults standardUserDefaults] setBool:preciseEnabled forKey:@"FanExplosionPreciseEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Fan Explosion Settings saved successfully");
}

- (void)showErrorMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" 
                                              style:UIAlertActionStyleDefault 
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showSuccessMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功" 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" 
                                              style:UIAlertActionStyleDefault 
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

@end
