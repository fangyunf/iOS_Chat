//
//  SWRechargeViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/29.
//

#import "SWRechargeViewController.h"
#import "PRechargeQrcodeView.h"
#import "SWNewRechargeValueCell.h"
#import <AlipaySDK/AlipaySDK.h>
@interface SWRechargeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UILabel *balanceLabel;
@property(nonatomic, strong) UITextField *moneyTextField;
@property(nonatomic, strong) NSArray *moneyList;
@property(nonatomic, strong) UIButton *methodBtn;
@property(nonatomic, assign) NSInteger selectIndex;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, assign) NSString *rechargeMethod;
@end

@implementation SWRechargeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
    self.navigationController.navigationBar.titleTextAttributes = attribute;
    
    [self requestBalance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    
    self.navTopView.hidden = YES;
    
    self.dataList = [NSMutableArray arrayWithObjects:@"100",@"300",@"400",@"500",@"800",@"1000",@"2000",@"3000", nil];
    
    self.view.backgroundColor = RGBColor(0xF5F7FA);
    
    UIImageView *topBgView = [[UIImageView alloc] init];
    topBgView.frame = CGRectMake(0, 0, kScreenWidth, 275*kScale);
    topBgView.image = [UIImage imageNamed:@"bg_wallet_top"];
    [self.view addSubview:topBgView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(16, kTopHeight + 70, kScreenWidth-32, 357);
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
    
    UILabel *titleLabel = [FControlTool createLabel:@"请选择充值金额" textColor:[UIColor blackColor] font:[UIFont boldFontWithSize:16]];
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
    
    [contentView addSubview:self.collectionView];
    
    UILabel *methodTitleLabel = [FControlTool createLabel:@"充值方式" textColor:RGBColor(0x333333) font:[UIFont fontWithSize:15]];
    methodTitleLabel.frame = CGRectMake(17, self.collectionView.bottom+24, contentView.width - 34, 15);
    [contentView addSubview:methodTitleLabel];
    
    self.methodBtn = [FControlTool createButton:@"支付宝" font:[UIFont fontWithSize:14] textColor:RGBColor(0x333333) target:self sel:@selector(methodBtnAction)];
    self.methodBtn.frame = CGRectMake(17, methodTitleLabel.bottom+20, contentView.width - 34, 25);
    [self.methodBtn setImage:[UIImage imageNamed:@"icn_wallet_zfb"] forState:UIControlStateNormal];
    [self.methodBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    self.methodBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [contentView addSubview:self.methodBtn];
    
    UIButton *payBtn = [FControlTool createCommonButton:@"充值" font:[UIFont boldFontWithSize:16] cornerRadius:8 size:CGSizeMake(kScreenWidth - 32, 56) target:self sel:@selector(payBtnAction)];
    payBtn.frame = CGRectMake(16, contentView.bottom+40, kScreenWidth - 32, 56);
    [self.view addSubview:payBtn];
    
    UILabel *tipLabel = [FControlTool createLabel:@"注：充值时间9点到晚11点，提现时间9点到晚8点 \n到账时间1小时之内" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    tipLabel.frame = CGRectMake(20, kScreenHeight - 100, kScreenWidth - 40, 100);
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    
    self.rechargeMethod = @"alipay";
}

- (void)requestBalance{
    @weakify(self)
    [[FUserModel sharedUser] getBalance:^(double balance) {
        weak_self.balanceLabel.text = [NSString stringWithFormat:@"¥%.2lf",(double)balance];
    }];
}

- (void)btnAction:(UIButton*)sender{
    NSInteger index = sender.tag - 100;
    self.selectIndex = index;
    self.moneyTextField.text = [NSString stringWithFormat:@"¥%@",self.moneyList[index]];
}

- (void)methodBtnAction{
    if (!self.isSelect) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *zfbAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.rechargeMethod = @"alipay";
        [self.methodBtn setTitle:@"支付宝" forState:UIControlStateNormal];
        [self.methodBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:6];
    }];
    
    UIAlertAction *wxAction = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.rechargeMethod = @"wxpay";
        [self.methodBtn setTitle:@"微信" forState:UIControlStateNormal];
        [self.methodBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:6];
    }];
    
    UIAlertAction *cartAction = [UIAlertAction actionWithTitle:@"银行卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.rechargeMethod = @"bank";
        [self.methodBtn setTitle:@"银行卡" forState:UIControlStateNormal];
        [self.methodBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:6];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alert addAction:zfbAction];
    [alert addAction:wxAction];
    [alert addAction:cartAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)payBtnAction{
    if (self.selectIndex == -1) {
        [SVProgressHUD showErrorWithStatus:@"请选择充值金额"];
        return;
    }
    NSDictionary *params = @{@"amount":@([self.moneyTextField.text doubleValue]*100),@"type":self.rechargeMethod};
    [[FNetworkManager sharedManager] postRequestFromServer:self.url parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
//            if ([self.rechargeMethod isEqualToString:@"alipay"]) {
//                if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"qrUrl"]]){
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"data"][@"qrUrl"]] options:@{} completionHandler:nil];
//                }else if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"payUrl"]]){
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"data"][@"payUrl"]] options:@{} completionHandler:nil];
//                }
                if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"url"]]){
//                    [[AlipaySDK defaultService] payOrder:response[@"data"][@"url"] fromScheme:@"pyramid" callback:^(NSDictionary *resultDic) {
//                        NSLog(@"resultDic === ：%@", resultDic);
//                    }];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"data"][@"url"]] options:@{} completionHandler:nil];
                }
                
//            }else {
//                if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"payUrl"]]){
//                    [self showQrcodeView:response[@"data"][@"payUrl"]];
//                }else if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"qrUrl"]]){
//                    [self showQrcodeView:response[@"data"][@"qrUrl"]];;
//                }else if(![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"url"]]){
//                    [self showQrcodeView:response[@"data"][@"url"]];;
//                }
//            }
            
            
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];;
}

//- (void)showQrcodeView:(NSString*)payUrl{
//    self.qrcodeView = [[PRechargeQrcodeView alloc] initWithFrame:self.view.bounds];
//    if ([self.rechargeMethod isEqualToString:@"alipay"]) {
//        self.qrcodeView.rechargeTipLabel.text = @"请使用支付宝扫二维码进行充值";
//    }else{
//        self.qrcodeView.rechargeTipLabel.text = @"请使用微信扫二维码进行充值";
//    }
//    [self.qrcodeView.rechargeImgView sd_setImageWithURL:[NSURL URLWithString:payUrl] placeholderImage:nil];
//    [[FControlTool keyWindow] addSubview:self.qrcodeView];
//}

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

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(66, 56);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, 116, kScreenWidth-64, 128) collectionViewLayout:layout];
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
