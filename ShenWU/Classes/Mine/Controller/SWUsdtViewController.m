//
//  SWUsdtViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/29.
//

#import "SWUsdtViewController.h"

@interface SWUsdtViewController ()
@property(nonatomic, strong) UIView *usdtView;
@property(nonatomic, strong) UIView *emptyView;
@property(nonatomic, strong) NSString *usdtAddress;
@end

@implementation SWUsdtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"usdt地址";
    
    [self requestData];
}

- (void)initUsdtView{
    self.usdtView = [[UIView alloc] init];
    self.usdtView.frame = self.view.bounds;
    [self.view addSubview:self.usdtView];
}

- (void)initEmptyView{
    self.emptyView = [[UIView alloc] init];
    self.emptyView.frame = self.view.bounds;
    [self.view addSubview:self.emptyView];
    
    UIImageView *icnImgView = [[UIImageView alloc] init];
    icnImgView.frame = CGRectMake((kScreenWidth - 182)/2, kTopHeight+52, 182, 147);
    icnImgView.image = [UIImage imageNamed:@"icn_usdt_empty"];
    [self.emptyView addSubview:icnImgView];
    
    UILabel *tipLabel = [FControlTool createLabel:@"还没有usdt地址，快去添加吧~" textColor:RGBColor(0x333333) font:[UIFont boldFontWithSize:15]];
    tipLabel.frame = CGRectMake(15, icnImgView.bottom+18, kScreenWidth - 30, 18);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.emptyView addSubview:tipLabel];
    
    UIButton *addBtn = [FControlTool createButton:@"添加" font:[UIFont boldFontWithSize:18] textColor:UIColor.whiteColor target:self sel:@selector(addBtnAction)];
    addBtn.frame = CGRectMake((kScreenWidth - 82)/2, tipLabel.bottom+24, 82, 35);
    addBtn.backgroundColor = kMainColor;
    addBtn.layer.cornerRadius = 17.5;
    addBtn.layer.masksToBounds = YES;
    [self.emptyView addSubview:addBtn];
}

- (void)addBtnAction{
    
}

- (void)requestData{
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/bindCard/userUsdt" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.usdtAddress = response[@"data"][@"usdt"];
            if ([FDataTool isNull:weak_self.usdtAddress]) {
                [weak_self initEmptyView];
            }else{
                [weak_self initUsdtView];
            }
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
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
