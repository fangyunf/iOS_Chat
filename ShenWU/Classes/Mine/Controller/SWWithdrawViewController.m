//
//  SWWithdrawViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/29.
//

#import "SWWithdrawViewController.h"
#import "FBankCardModel.h"
#import "SWBindZfbViewController.h"
#import "SWBankCardViewController.h"
#import "SWNewRechargeValueCell.h"
@interface SWWithdrawViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UILabel *balanceLabel;
@property(nonatomic, strong) UITextField *moneyTextField;
@property(nonatomic, assign) double balance;
@property(nonatomic, strong) UIButton *methodBtn;
@property(nonatomic, strong) FBankCardModel *aliModel;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, assign) NSInteger methodType;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, assign) NSInteger selectIndex;

@end

@implementation SWWithdrawViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestBalance];
    [self requestZFBData:2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现";
    self.navTopView.hidden = YES;
    
    self.dataList = [NSMutableArray arrayWithObjects:@"100",@"300",@"400",@"500",@"800",@"1000",@"2000",@"3000", nil];
    
    self.view.backgroundColor = RGBColor(0xF5F7FA);
    
    UIImageView *topBgView = [[UIImageView alloc] init];
    topBgView.frame = CGRectMake(0, 0, kScreenWidth, 275*kScale);
    topBgView.image = [UIImage imageNamed:@"bg_wallet_top"];
    [self.view addSubview:topBgView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(16, kTopHeight + 70, kScreenWidth-32, 387);
    [contentView rounded:8];
    [self.view addSubview:contentView];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = contentView.bounds;
    gl.startPoint = CGPointMake(0.98, 0);
    gl.endPoint = CGPointMake(0.54, 0.58);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.43].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    gl.cornerRadius = 8;
    [contentView.layer insertSublayer:gl atIndex:0];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.frame = contentView.bounds;
    [contentView addSubview:visualView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"请选择提现金额" textColor:[UIColor blackColor] font:[UIFont boldFontWithSize:16]];
    titleLabel.frame = CGRectMake(17, 20, contentView.width - 34, 18);
    [contentView addSubview:titleLabel];
    
    UIView *moneyView = [[UIView alloc] init];
    moneyView.frame = CGRectMake(17, 52, contentView.width-34, 48);
    moneyView.backgroundColor = RGBAlphaColor(0x8F55FF, 0.04);
    [moneyView rounded:8 width:1 color:RGBColor(0x8F55FF)];
    [contentView addSubview:moneyView];
    

    UILabel *unitLabel = [FControlTool createLabel:@"￥" textColor:RGBColor(0x333333) font:[UIFont fontWithSize:16]];
    unitLabel.frame = CGRectMake(12, 0, 20, 48);
    [moneyView addSubview:unitLabel];
    
    self.moneyTextField = [[UITextField alloc] init];
    self.moneyTextField.frame = CGRectMake(45, 0, moneyView.width - 15 - 45, 48);
    self.moneyTextField.textColor = RGBColor(0x333333);
    self.moneyTextField.placeholder = @"请输入提现金额";
    self.moneyTextField.font = [UIFont fontWithSize:16];
    [moneyView addSubview:self.moneyTextField];
    
    
    self.balanceLabel = [FControlTool createLabel:@"" textColor:RGBAlphaColor(0x081C2C, 0.5) font:[UIFont fontWithSize:14]];
    self.balanceLabel.frame = CGRectMake(17, moneyView.bottom+4, contentView.width - 34, 24);
    [contentView addSubview:self.balanceLabel];
    
    UIButton *allBtn = [FControlTool createButton:@"全部提现" font:[UIFont boldFontWithSize:14] textColor:kMainColor target:self sel:@selector(allBtnAction)];
    allBtn.frame = CGRectMake(contentView.width - 77, moneyView.bottom+4, 60, 24);
    allBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [contentView addSubview:allBtn];
    
    [contentView addSubview:self.collectionView];
    
    UILabel *methodTitleLabel = [FControlTool createLabel:@"提现方式" textColor:RGBColor(0x333333) font:[UIFont fontWithSize:15]];
    methodTitleLabel.frame = CGRectMake(17, self.collectionView.bottom+24, contentView.width - 34, 15);
    [contentView addSubview:methodTitleLabel];
    
    self.methodBtn = [FControlTool createButton:@"支付宝" font:[UIFont fontWithSize:14] textColor:RGBColor(0x333333) target:self sel:@selector(methodBtnAction)];
    self.methodBtn.frame = CGRectMake(17, methodTitleLabel.bottom+20, contentView.width - 34, 25);
    [self.methodBtn setImage:[UIImage imageNamed:@"icn_wallet_zfb"] forState:UIControlStateNormal];
    [self.methodBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    self.methodBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [contentView addSubview:self.methodBtn];
    
    UIButton *payBtn = [FControlTool createCommonButton:@"提现" font:[UIFont boldFontWithSize:16] cornerRadius:8 size:CGSizeMake(kScreenWidth - 32, 56) target:self sel:@selector(payBtnAction)];
    payBtn.frame = CGRectMake(16, contentView.bottom+40, kScreenWidth - 32, 56);
    [self.view addSubview:payBtn];
    
    UILabel *tipLabel = [FControlTool createLabel:@"注：充值时间9点到晚11点，提现时间9点到晚8点 \n到账时间1小时之内" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    tipLabel.frame = CGRectMake(20, kScreenHeight - 100, kScreenWidth - 40, 100);
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
}

- (void)requestBalance{
    @weakify(self)
    [[FUserModel sharedUser] getBalance:^(double balance) {
        weak_self.balance = balance;
        weak_self.balanceLabel.text = [NSString stringWithFormat:@"可用余额 %.2lf",(double)balance];
    }];
}

- (void)methodBtnAction{
    return;
    @weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *zfbAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weak_self.methodBtn setTitle:@"支付宝" forState:UIControlStateNormal];
        [self.methodBtn setImage:[UIImage imageNamed:@"icn_wallet_zfb"] forState:UIControlStateNormal];
        [weak_self.methodBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:6];
        weak_self.methodBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [weak_self requestZFBData:2];
    }];

    UIAlertAction *wxAction = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weak_self.methodBtn setTitle:@"微信" forState:UIControlStateNormal];
        [self.methodBtn setImage:[UIImage imageNamed:@"icn_wallet_wechat"] forState:UIControlStateNormal];
        [weak_self.methodBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:6];
        weak_self.methodBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [weak_self requestZFBData:1];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];

    [alert addAction:zfbAction];
    [alert addAction:wxAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)allBtnAction{
    self.moneyTextField.text = [NSString stringWithFormat:@"%.2lf",self.balance];
}

- (void)payBtnAction{
    if (self.moneyTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入提现金额"];
        return;
    }
    if ([self.moneyTextField.text doubleValue] < 100) {
        [SVProgressHUD showErrorWithStatus:@"提现金额100起"];
        return;
    }
    if(self.aliModel.name.length > 0 && self.aliModel.usdt.length > 0 && self.aliModel.phone.length > 0){
        @weakify(self)
        [FPayPasswordView showPayPrice:[NSString stringWithFormat:@"%.2lf",[self.moneyTextField.text doubleValue]] success:^(NSString * _Nonnull password) {
            [weak_self requestWithdraw:password];
        }];
    }else{
        SWBindZfbViewController *vc = [[SWBindZfbViewController alloc] init];
        if (self.methodType == 2) {
            vc.isWx = NO;
        }else{
            vc.isWx = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)requestWithdraw:(NSString*)password{
    @weakify(self)
    [SVProgressHUD show];
    NSDictionary *params = @{@"payPassword":password,@"zfbNo":self.aliModel.phone,@"name":self.aliModel.name,@"amount":@([self.moneyTextField.text doubleValue]*100),@"zfbUrl":self.aliModel.usdt,@"type":@"2",@"userUsdtId":self.aliModel.cardId};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/withdraw/withdrawDeposit" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [weak_self requestBalance];
            [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)requestZFBData:(NSInteger)type{
    if (self.isLoading) {
        return;
    }
    self.methodType = type;
    self.aliModel = nil;
    self.isLoading = YES;
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/bindCard/userZFB" parameters:@{@"type":@(type)} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            NSArray *list = response[@"data"];
            FBankCardModel *model = [FBankCardModel modelWithDictionary:list.lastObject];
            weak_self.aliModel.name = model.name;
            weak_self.aliModel.usdt = model.usdt;
            weak_self.aliModel.phone = model.phone;
            weak_self.aliModel.cardId = model.cardId;
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        weak_self.isLoading = NO;
    } failure:^(NSError * _Nonnull error) {
        weak_self.isLoading = NO;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWNewRechargeValueCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SWNewRechargeValueCell class]) forIndexPath:indexPath];
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    if (self.selectIndex == indexPath.row) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex == indexPath.row) {
        return;
    }
    SWNewRechargeValueCell *cell = (SWNewRechargeValueCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0]];
    cell.isSelected = NO;
    
    SWNewRechargeValueCell *selectCell = (SWNewRechargeValueCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    selectCell.isSelected = YES;
    
    self.selectIndex = indexPath.row;
    
    self.moneyTextField.text = [self.dataList objectAtIndex:indexPath.row];
}


- (FBankCardModel *)aliModel {
    if (!_aliModel) {
        _aliModel = [[FBankCardModel alloc] init];
        _aliModel.certNo = @"";
        _aliModel.cardId = @"zfb";
        _aliModel.bankName = @"支付宝";
    }
    return _aliModel;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(66, 56);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, 147, kScreenWidth-64, 128) collectionViewLayout:layout];
        [_collectionView registerClass:[SWNewRechargeValueCell class] forCellWithReuseIdentifier:NSStringFromClass([SWNewRechargeValueCell class])];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
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
