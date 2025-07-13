//
//  SWMineViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/19.
//

#import "SWMineViewController.h"
#import "SWMineHeaderView.h"
#import <PhotosUI/PhotosUI.h>
#import "SWQRcodeViewController.h"
#import "SWEidtInfoViewController.h"
#import "SWMyWalletViewController.h"
#import "SWCountermarkViewController.h"
#import "TKPasswordSettingViewController.h"
#import "SWMineCell.h"
#import "SWSwitchAccountViewController.h"
#import "SWMySettingViewController.h"
#import "TKVipCenterViewController.h"
#import "IRQRCodeView.h"
#import "SWPayPasswordViewController.h"
@interface SWMineViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PHPickerViewControllerDelegate>
@property(nonatomic, strong) SWMineHeaderView *headerView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;

@property(nonatomic, strong) NSMutableArray *linkUrls;
@property(nonatomic, strong) NSString *iosUrl;
@property(nonatomic, strong) NSString *androidUrl;

@property(nonatomic, strong) UIButton *androidBtn;
@property(nonatomic, strong) UIButton *iosBtn;
@end

@implementation SWMineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self requestData];
    [self.headerView refreshView];
    [self requestBalance];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTopView.hidden = YES;
    
    self.view.backgroundColor = RGBColor(0xF5F7FA);
    
    UIImageView *topBgImgView = [FControlTool createImageView];
    topBgImgView.frame = CGRectMake(0, 0, kScreenWidth, 267*kScale);
    topBgImgView.image = [UIImage imageNamed:@"bg_common_top"];
    [self.view addSubview:topBgImgView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"我的" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:24]];
    titleLabel.frame = CGRectMake(16, kStatusHeight+7, kScreenWidth - 28, 30);
    [self.view addSubview:titleLabel];
    
    UIButton *qrcodeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_qrcode"] target:self sel:@selector(showQrcode)];
    qrcodeBtn.frame = CGRectMake(kScreenWidth - 49, kStatusHeight+6, 33, 32);
    [self.view addSubview:qrcodeBtn];
    
//    UIButton *editBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_mine_edit"] target:self sel:@selector(rightBtnAction)];
//    editBtn.frame = CGRectMake(kScreenWidth - 61, kStatusHeight, 44, 44);
//    editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [self.view addSubview:editBtn];
    
    
    
//    UIButton *editBtn = [FControlTool createButton:@"编辑" font:[UIFont fontWithSize:16] textColor:kMainColor target:self sel:@selector(rightBtnAction)];
//    editBtn.frame = CGRectMake(kScreenWidth - 61, kStatusHeight, 50, 44);
//    editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [self.view addSubview:editBtn];
    
//    UIButton *editBtn = [FControlTool createButtonWithBackImage:[UIImage imageNamed:@"icn_mine_info"] target:self sel:@selector(rightBtnAction)];
//    editBtn.frame = CGRectMake(kScreenWidth - 28 - 15, kStatusHeight+8, 28, 28);
//    editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [self.view addSubview:editBtn];
    
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = self.view.bounds;
//    gl.startPoint = CGPointMake(0.5, 0);
//    gl.endPoint = CGPointMake(0.5, 0.15);
//    gl.colors = @[(__bridge id)[UIColor colorWithRed:205/255.0 green:223/255.0 blue:251/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:240/255.0 green:243/255.0 blue:248/255.0 alpha:1].CGColor];
//    gl.locations = @[@(0), @(1.0f)];
//    [self.view.layer insertSublayer:gl atIndex:0];
    
    self.headerView = [[SWMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-32, 118)];
    self.tableView.tableHeaderView = self.headerView;
    
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightBtnAction)];
    [self.headerView addGestureRecognizer:headerTap];
    
//    self.dataList =@[@[@{@"title":@"上传头像",@"imageName":@"icn_info_camre"}],
//                     @[@{@"title":@"资产权益",@"imageName":@"icn_mine_wallet"},
//                       @{@"title":@"会员中心",@"imageName":@"icn_mine_vip"},
//                       @{@"title":@"我的副号",@"imageName":@"icn_mine_countermark"},
//                       @{@"title":@"账号管理",@"imageName":@"icn_mine_account_manager"},
//                       @{@"title":@"密码管理",@"imageName":@"icn_mine_password"},
//                       @{@"title":@"通用设置",@"imageName":@"icn_mine_setting"},
//                       @{@"title":@"官网地址",@"imageName":@"icn_mine_download"}],
////                     @[@{@"title":@"退出登录",@"imageName":@"icn_mine_logout"}]
//    ];
    self.dataList = @[@[@{@"title":@"我的钱包",@"imageName":@"icn_mine_wallet"},
                        @{@"title":@"账号管理",@"imageName":@"icn_mine_account_manager"},
                        @{@"title":@"官网地址",@"imageName":@"icn_mine_download"},
                        @{@"title":@"支付密码",@"imageName":@"icn_mine_password"}],
                      @[@{@"title":@"设置",@"imageName":@"icn_mine_setting"}]
    ];
    self.linkUrls = [NSMutableArray array];
    
    [self.tableView reloadData];
    
    [self requestDownloadData];
    
//    UIView *footerView = [[UIView alloc] init];
//    footerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
//    
//    UIButton *logoutBtn = [FControlTool createButton:@"退出登录" font:[UIFont fontWithSize:16] textColor:RGBColor(0x081C2C) target:self sel:@selector(logoutBtnAction)];
//    logoutBtn.frame = CGRectMake(0, 24, kScreenWidth - 32, 48);
//    logoutBtn.backgroundColor = UIColor.whiteColor;
//    [logoutBtn rounded:8];
//    [footerView addSubview:logoutBtn];
//    
//    self.tableView.tableFooterView = footerView;
}

- (void)requestBalance{
    @weakify(self)
    [[FUserModel sharedUser] getBalance:^(double balance) {
        weak_self.headerView.balanceLabel.text = [NSString stringWithFormat:@"¥%.2lf",(double)balance];
    }];
}

- (void)showVipBuyAlertWithPrice:(NSString*)price{
    @weakify(self)
    TKPaySucceseAlertView *view = [[TKPaySucceseAlertView alloc] initWithFrame:self.view.bounds bgImgStr:@"bg_comom_alert" title:[NSString stringWithFormat:@"即将支付%@元获得会员权益",price] des:@"成为会员后砸蛋中奖几率翻倍，更有机会获得彩蛋" btnStr:@"确定"];
    view.clickOnSureBtn = ^{
        
        [FPayPasswordView showPayPrice:@"88" success:^(NSString * _Nonnull password) {
            [weak_self requestBuy:password];
        }];
    };
    [[FControlTool keyWindow] addSubview:view];
}

- (void)showQrcode{
    SWQRcodeViewController *vc = [[SWQRcodeViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//    IRQRCodeView *view = [[IRQRCodeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [[FControlTool keyWindow] addSubview:view];
}

- (void)rightBtnAction{
    SWEidtInfoViewController *vc = [[SWEidtInfoViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)logoutBtnAction{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:sure];
    [alertVc addAction:cancel];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)requestBuy:(NSString *)password{
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/gmHuiYuan" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            [weak_self showVipPaySuccess];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)showVipPaySuccess{
    [FUserModel sharedUser].hy = YES;
    TKPaySucceseAlertView *view = [[TKPaySucceseAlertView alloc] initWithFrame:self.view.bounds bgImgStr:@"bg_pay_sucess" title:@"恭喜你！购买会员成功" des:@"" btnStr:@"确定"];
    view.clickOnSureBtn = ^{

    };
    [[FControlTool keyWindow] addSubview:view];
}

- (void)requestDownloadData{
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:@"/customer/about" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"linkUrl"]]) {
                [weak_self.linkUrls addObjectsFromArray:response[@"data"][@"linkUrl"]];
                for (NSDictionary *dic in weak_self.linkUrls) {
                    if (![FDataTool isNull:dic[@"appType"]] && [dic[@"appType"] isEqualToString:@"IOS"]) {
                        weak_self.iosUrl = dic[@"downloadUrl"];
                    }
                    if (![FDataTool isNull:dic[@"appType"]] && [dic[@"appType"] isEqualToString:@"ANDROID"]) {
                        weak_self.androidUrl = dic[@"downloadUrl"];
                    }
                }
            }
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)requestData{
    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/getUserByToken" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            NSDictionary *dict = response[@"data"];
            NSDictionary *userDict = [FDataTool nullDicToDic:dict];
            [[FUserModel sharedUser] saveUserInfoWithPhone:userDict[@"phoneNo"] NickName:userDict[@"username"] ImToken:userDict[@"imToken"] UserID:userDict[@"userId"] memberCode:userDict[@"memberCode"] AndUserToken:userDict[@"token"] avator:userDict[@"avatar"] AndVipLevel:userDict[@"grade"] AndAuthentication:userDict[@"verified"]];
            [FUserModel sharedUser].signatureStr = userDict[@"introduce"];
            [FUserModel sharedUser].memberCode = [NSString stringWithFormat:@"%@", userDict[@"memberCode"]];
            [FUserModel sharedUser].backImage = userDict[@"backImage"];
            [FUserModel sharedUser].allDisturb = [userDict[@"allDisturb"] boolValue];
            [FUserModel sharedUser].sound = [userDict[@"sound"] boolValue];
            [FUserModel sharedUser].shake = [userDict[@"shake"] boolValue];
            [FUserModel sharedUser].usdtStr = userDict[@"usdt"];
            [FUserModel sharedUser].busUsdtStr = userDict[@"busUsdt"];
            [FUserModel sharedUser].huiLvStr = userDict[@"huiLv"];
            
            [self.headerView refreshView];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)androidBtnAction{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.androidUrl];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (void)iosBtnAction{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.iosUrl];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList[section] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenWidth - 32, 24);
    return view;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell radius:11 color:UIColor.whiteColor indexPath:indexPath tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWMineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWMineCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    cell.icnImgView.image = [UIImage imageNamed:self.dataList[indexPath.section][indexPath.row][@"imageName"]];
    cell.titleLabel.text = self.dataList[indexPath.section][indexPath.row][@"title"];
    if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"上传头像"]) {
        cell.titleLabel.textColor = RGBColor(0x081C2C);
    }else{
        cell.titleLabel.textColor = RGBColor(0x081C2C);
    }
    if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"官网地址"]) {
        cell.arrowImgView.hidden = YES;
        if (!self.androidBtn) {
            self.androidBtn = [FControlTool createButton:@"android复制" font:[UIFont fontWithSize:14] textColor:kMainColor target:self sel:@selector(androidBtnAction)];
            self.androidBtn.frame = CGRectMake(kScreenWidth-32 - 97, 0, 81, 48);
            [cell.contentView addSubview:self.androidBtn];
            
            self.iosBtn = [FControlTool createButton:@"iOS复制" font:[UIFont fontWithSize:14] textColor:kMainColor target:self sel:@selector(iosBtnAction)];
            self.iosBtn.frame = CGRectMake(self.androidBtn.left - 73, 0, 53, 48);
            [cell.contentView addSubview:self.iosBtn];
        }
    }else{
        cell.arrowImgView.hidden = NO;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"上传头像"]) {
        [self uploadAvatar];
    }else if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"我的钱包"]) {
        SWMyWalletViewController *vc = [[SWMyWalletViewController alloc] init];
        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"账号管理"]) {
        SWSwitchAccountViewController *vc = [[SWSwitchAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"密码管理"]) {
        TKPasswordSettingViewController *vc = [[TKPasswordSettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"支付密码"]) {
        SWPayPasswordViewController *vc = [[SWPayPasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"设置"]) {
        SWMySettingViewController *vc = [[SWMySettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"购买靓号"]) {
        TKVipCenterViewController *vc = [[TKVipCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"我的副号"]) {
        SWCountermarkViewController *vc = [[SWCountermarkViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"官网地址"]) {
        
    }else if ([self.dataList[indexPath.section][indexPath.row][@"title"] isEqualToString:@"退出登录"]) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:sure];
        [alertVc addAction:cancel];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
//    if (indexPath.section == 0) {
//        NSInteger index = indexPath.row;
//        if(index == 0){
//            SWMyWalletViewController *vc = [[SWMyWalletViewController alloc] init];
//            [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//        }else if (index == 1){
//            SWSecurityPrivacyViewController *vc = [[SWSecurityPrivacyViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if (index == 2){
//            SWSwitchAccountViewController *vc = [[SWSwitchAccountViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if (index == 3){
//            SWMySettingViewController *vc = [[SWMySettingViewController alloc] init];
//            [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
////            TKMessageSettingViewController *vc = [[TKMessageSettingViewController alloc] init];
////            [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//        }else if (index == 4){
//            SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.type = NIMSessionTypeP2P;
//            vc.sessionId = [FMessageManager sharedManager].serviceUserId;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if (index == 5){
//    //        [SVProgressHUD showInfoWithStatus:@"敬请期待，等待开放"];
//            TKVipCenterViewController *vc = [[TKVipCenterViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//    //        [SVProgressHUD show];
//    //        @weakify(self)
//    //        [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/huiYuanJia" parameters:[NSDictionary new] success:^(NSDictionary * _Nonnull response) {
//    //            if ([response[@"code"] integerValue] == 200) {
//    //                [SVProgressHUD dismiss];
//    //                if (![FDataTool isNull:response] && ![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"price"]]) {
//    //                    NSInteger price = [response[@"data"][@"price"] integerValue];
//    //                    NSString *priceStr = [NSString stringWithFormat:@"%ld",price/100];
//    //                    [weak_self showVipBuyAlertWithPrice:priceStr];
//    //                }
//    //            }else{
//    //                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
//    //            }
//    //        } failure:^(NSError * _Nonnull error) {
//    //            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//    //        }];
//        }else if (index == 6){
//    //        [SVProgressHUD showInfoWithStatus:@"敬请期待，等待开放"];
//            [SVProgressHUD show];
//            @weakify(self)
//            [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/huiYuanJia" parameters:[NSDictionary new] success:^(NSDictionary * _Nonnull response) {
//                if ([response[@"code"] integerValue] == 200) {
//                    [SVProgressHUD dismiss];
//                    if (![FDataTool isNull:response] && ![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"price"]]) {
//                        NSInteger price = [response[@"data"][@"price"] integerValue];
//                        NSString *priceStr = [NSString stringWithFormat:@"%ld",price/100];
//                        [weak_self showVipBuyAlertWithPrice:priceStr];
//                    }
//                }else{
//                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
//                }
//            } failure:^(NSError * _Nonnull error) {
//                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//            }];
//        }
//    }else{
//        NSInteger index = indexPath.row;
////        if(index == 0){
////            TKPasswordSettingViewController *vc = [[TKPasswordSettingViewController alloc] init];
////            [self.navigationController pushViewController:vc animated:YES];
////        }else
//        if(index == 0){
//            [self requestDownloadData];
//        }else if(index == 1){
//            FDownloadShareViewController *vc = [[FDownloadShareViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if(index == 2){
//            SWChangeChatBgViewController *vc = [[SWChangeChatBgViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
}

- (void)uploadAvatar{
    if (@available(iOS 14, *)) {
        PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
        config.selectionLimit = 1;
        config.filter = [PHPickerFilter imagesFilter];
        config.preferredAssetRepresentationMode = PHPickerConfigurationAssetRepresentationModeCurrent;
        PHPickerViewController *vc = [[PHPickerViewController alloc] initWithConfiguration:config];
        vc.delegate = self;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.delegate = self;
        vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - PHPickerViewControllerDelegate
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)){
    PHPickerResult *result = results.firstObject;
    if (result) {
        @weakify(self);
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:[UIImage class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weak_self uploadImage:object];
                    [picker dismissViewControllerAnimated:YES completion:nil];
                });
            } else {
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }else{
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self uploadImage:image];
}

- (void)uploadImage:(UIImage*)image{
    @weakify(self);
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] uploadImgFromServer:@"/customer/upload" image:image parameters:@{@"file":[NSString stringWithFormat:@"pic_%ld.jpg", (NSInteger)[[NSDate date] timeIntervalSince1970]]} progress:^(NSProgress * progress) {
        NSLog(@"%lld_%lld",progress.completedUnitCount,progress.totalUnitCount);
    } success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            @strongify(self);
            [self requestChangeAvatar:response[@"data"][@"url"]];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)requestChangeAvatar:(NSString*)avatarUrl{
    NSDictionary *params = @{@"avatar":avatarUrl};
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/changeInfo" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [FUserModel sharedUser].headerIcon = avatarUrl;
            [[FUserModel sharedUser] saveUserInfo];
            [weak_self.headerView refreshView];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, kTopHeight+20, kScreenWidth-32, kScreenHeight - kTabBarHeight - kTopHeight-20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 30);
        _tableView.separatorColor = RGBColor(0xEAEEF2);
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
        [self.view addSubview:_tableView];
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
