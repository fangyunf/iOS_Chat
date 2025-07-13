//
//  SettingsContainerViewController.m
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import "SettingsContainerViewController.h"
#import "FControlTool.h"
#import "BasicSettingsViewController.h"
#import "QuickGrabSettingsViewController.h"
#import "PackageSettingsViewController.h"
#import "FanExplosionSettingsViewController.h"
#import "CompensationSettingsViewController.h"
#import <YYKit/YYKit.h>
#import "MachineSecondManager.h"

@interface SettingsContainerViewController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *controllers;
@end

@implementation SettingsContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.controllers = [NSMutableArray array];
    [self.controllers addObject:[[BasicSettingsViewController alloc] init]];
    [self.controllers addObject:[[QuickGrabSettingsViewController alloc] init]];
    [self.controllers addObject:[[PackageSettingsViewController alloc] init]];
    [self.controllers addObject:[[FanExplosionSettingsViewController alloc] init]];
    [self.controllers addObject:[[CompensationSettingsViewController alloc] init]];
    
    [self setupUI];
    [self setupConstraints];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    
    // Navigation bar
    self.cancelButton = [FControlTool createButton:@"取消" 
                                          font:[UIFont systemFontOfSize:16] 
                                     textColor:[UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0] 
                                        target:self 
                                           sel:@selector(cancelAction)];
    
    self.confirmButton = [FControlTool createButton:@"确定" 
                                           font:[UIFont systemFontOfSize:16] 
                                      textColor:[UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0] 
                                         target:self 
                                            sel:@selector(confirmAction)];
    
    self.titleLabel = [FControlTool createLabel:@"郡尚风行" 
                                  textColor:[UIColor blackColor] 
                                       font:[UIFont boldSystemFontOfSize:18] 
                                  alignment:NSTextAlignmentCenter 
                                    lineNum:1];
    
    // Category view
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.titles = @[@"基本设置", @"秒抢设置", @"发包设置", @"爆粉设置", @"赔付设置"];
    self.categoryView.delegate = self;
    self.categoryView.backgroundColor = [UIColor blackColor];
    self.categoryView.titleColor = [UIColor whiteColor];
    self.categoryView.titleSelectedColor = [UIColor whiteColor];
    self.categoryView.titleFont = [UIFont systemFontOfSize:14];
    self.categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:14];
    
    // List container
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.frame = CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - kTopHeight - kTabBarHeight);
    [self.view addSubview:self.listContainerView];
    self.categoryView.listContainer = self.listContainerView;
    
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.categoryView];
    
    
    
}

- (void)setupConstraints {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.cancelButton.frame = CGRectMake(20, 0, 60, 44);
    self.confirmButton.frame = CGRectMake(screenWidth - 80, 0, 60, 44);
    self.titleLabel.frame = CGRectMake(80, 0, screenWidth - 160, 44);
    self.categoryView.frame = CGRectMake(0, 44, screenWidth, 50);
    self.listContainerView.frame = CGRectMake(0, 94, screenWidth, screenHeight - 194);
}

#pragma mark - Actions

- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmAction {
    // Save all settings
    [self saveAllSettings];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAllSettings {
    [[MachineSecondManager sharedManager] getSecondConfig];
}

#pragma mark - JXCategoryListContainerViewDelegate -
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index{
    return self.controllers[index];
    
    
}
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.controllers.count;
}

@end
