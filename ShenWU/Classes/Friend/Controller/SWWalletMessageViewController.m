//
//  SWWalletMessageViewController.m
//  ShenWU
//
//  Created by Amy on 2025/2/27.
//

#import "SWWalletMessageViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "SWWalletNotiDetailViewController.h"
#import "SWLittleHelperViewController.h"
@interface SWWalletMessageViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property(nonatomic, strong) SWWalletNotiDetailViewController *rechargeVc;
@property(nonatomic, strong) SWWalletNotiDetailViewController *tixianVc;
@property(nonatomic, strong) SWLittleHelperViewController *helpVc;
@end

@implementation SWWalletMessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"钱包通知";
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, 42)];
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    self.categoryView.titleLabelVerticalOffset = -5; //标题向上偏移
    self.categoryView.titles = @[@"充值", @"提现", @"小助手"];
    self.categoryView.titleColor = RGBColor(0x999999);           //默认文字颜色
    self.categoryView.titleSelectedColor = UIColor.blackColor;   //文字选择颜色
    self.categoryView.backgroundColor = [UIColor clearColor];
    self.categoryView.titleFont = [UIFont boldFontWithSize:18];
    self.categoryView.titleSelectedFont = [UIFont boldFontWithSize:18];
    self.categoryView.titleColorGradientEnabled = YES;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = kMainColor;
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    lineView.verticalMargin = 5; //默认底部，越大越向上偏移
    lineView.indicatorHeight = 4; //指示器高度
    lineView.indicatorCornerRadius = 2; //是否倒圆角
    lineView.indicatorWidth = 40; //指示器宽度
    lineView.scrollStyle = JXCategoryIndicatorScrollStyleSameAsUserScroll; //指示器滚动样式
    self.categoryView.indicators = @[lineView];
    
    self.listContainerView.frame = CGRectMake(0, self.categoryView.bottom+10, kScreenWidth, kScreenHeight - (self.categoryView.bottom+10));
    [self.view addSubview:self.listContainerView];
    self.categoryView.listContainer = self.listContainerView;
}

//子控制器数组
- (NSArray<__kindof UIViewController *> *)controllers{
    if (!self.rechargeVc) {
        self.rechargeVc = [[SWWalletNotiDetailViewController alloc] init];
        self.rechargeVc.isRecharge = YES;
        
        self.tixianVc = [[SWWalletNotiDetailViewController alloc] init];
        self.tixianVc.isRecharge = NO;
        
        self.helpVc = [[SWLittleHelperViewController alloc] init];
        
    }
    return @[
        self.rechargeVc,
        self.tixianVc,
        self.helpVc,
    ];
}


#pragma mark - JXCategoryViewDelegate -

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
}


#pragma mark - JXCategoryListContainerViewDelegate -
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index{
    if (index == 2) {
        __kindof SWLittleHelperViewController *vc  = self.controllers[index];
        return vc;
    }else{
        __kindof SWWalletNotiDetailViewController *vc  = self.controllers[index];
        return vc;
    }
    
}
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.controllers.count;
}

-(JXCategoryListContainerView *)listContainerView{
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listContainerView.scrollView.scrollEnabled = YES;
    }
    return _listContainerView;
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
