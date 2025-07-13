//
//  SWZfbViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/1.
//

#import "SWZfbViewController.h"
#import "FBankCardModel.h"
#import "SWBindZfbViewController.h"
@interface SWZfbViewController ()
@property(nonatomic, strong) UIView *infoView;
@property(nonatomic, strong) UILabel *zfbLabel;
@property(nonatomic, strong) UIView *emptyView;
@property(nonatomic, strong) FBankCardModel *aliModel;
@end

@implementation SWZfbViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestZFBData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.isWx? @"微信": @"支付宝";
    
    [self initInfoView];
    [self initEmptyView];
    
    
}

- (void)initInfoView{
    self.infoView = [[UIView alloc] init];
    self.infoView.frame = self.view.bounds;
    self.infoView.hidden = YES;
    [self.view addSubview:self.infoView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(15, 30+kTopHeight, kScreenWidth - 30, 51);
    contentView.backgroundColor = RGBColor(0xf2f2f2);
    contentView.layer.cornerRadius = 10;
    contentView.layer.masksToBounds = YES;
    [self.infoView addSubview:contentView];
    
    UILabel *titleLabel = [FControlTool createLabel:self.isWx? @"已绑定微信":@"已绑定支付宝" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    titleLabel.frame = CGRectMake(20, 0, contentView.width - 20, 51);
    [contentView addSubview:titleLabel];
    
    self.zfbLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x999999) font:[UIFont boldFontWithSize:14]];
    self.zfbLabel.frame = CGRectMake(20, 0, contentView.width - 40, 51);
    self.zfbLabel.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:self.zfbLabel];
    
    UIButton *addBtn = [FControlTool createCommonButton:@"重新绑定" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 16, 52) target:self sel:@selector(editBtnAction)];
    addBtn.frame = CGRectMake(16, contentView.bottom+50, kScreenWidth - 32, 52);
    [self.infoView addSubview:addBtn];
}

- (void)initEmptyView{
    self.emptyView = [[UIView alloc] init];
    self.emptyView.frame = self.view.bounds;
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    
    UIImageView *icnImgView = [[UIImageView alloc] init];
    icnImgView.frame = CGRectMake((kScreenWidth - 182)/2, kTopHeight+52, 182, 147);
    icnImgView.image = [UIImage imageNamed:@"icn_usdt_empty"];
    [self.emptyView addSubview:icnImgView];
    
    UILabel *tipLabel = [FControlTool createLabel:self.isWx?@"还没有绑定微信，快去绑定吧~": @"还没有绑定支付宝，快去绑定吧~" textColor:RGBColor(0x333333) font:[UIFont boldFontWithSize:15]];
    tipLabel.frame = CGRectMake(15, icnImgView.bottom+18, kScreenWidth - 30, 18);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.emptyView addSubview:tipLabel];
    
    UIButton *addBtn = [FControlTool createButton:@"去绑定" font:[UIFont boldFontWithSize:18] textColor:UIColor.whiteColor target:self sel:@selector(addBtnAction)];
    addBtn.frame = CGRectMake((kScreenWidth - 82)/2, tipLabel.bottom+24, 82, 35);
    addBtn.backgroundColor = kMainColor;
    addBtn.layer.cornerRadius = 17.5;
    addBtn.layer.masksToBounds = YES;
    [self.emptyView addSubview:addBtn];
}

- (void)addBtnAction{
    SWBindZfbViewController *vc = [[SWBindZfbViewController alloc] init];
    vc.isWx = self.isWx;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editBtnAction{
    SWBindZfbViewController *vc = [[SWBindZfbViewController alloc] init];
    vc.model = self.aliModel;
    vc.isWx = self.isWx;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestZFBData{
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/bindCard/userZFB" parameters:@{@"type":self.isWx? @(1): @(2)} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            NSArray *list = response[@"data"];
            FBankCardModel *model = [FBankCardModel modelWithDictionary:list.lastObject];
            weak_self.aliModel.name = model.name;
            weak_self.aliModel.usdt = model.usdt;
            weak_self.aliModel.phone = model.phone;
            weak_self.aliModel.cardId = model.cardId;
            if (![FDataTool isNull:model.name] && ![FDataTool isNull:model.usdt] && ![FDataTool isNull:model.phone]) {
                weak_self.zfbLabel.text = model.phone;
                weak_self.infoView.hidden = NO;
                weak_self.emptyView.hidden = YES;
            }else{
                weak_self.infoView.hidden = YES;
                weak_self.emptyView.hidden = NO;
            }
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (FBankCardModel *)aliModel {
    if (!_aliModel) {
        _aliModel = [[FBankCardModel alloc] init];
    }
    return _aliModel;
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
