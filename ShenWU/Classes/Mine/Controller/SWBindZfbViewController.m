//
//  SWBindZfbViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/1.
//

#import "SWBindZfbViewController.h"
#import "SWPasswordInputCell.h"
#import <PhotosUI/PhotosUI.h>

@interface SWBindZfbViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PHPickerViewControllerDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, strong) UIButton *addBtn;
@property(nonatomic, strong) UIImage *qrCodeImage;
@property(nonatomic, strong) NSString *qrCodeUrl;
@end

@implementation SWBindZfbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (self.isWx) {
        self.title = @"绑定微信";
        
        self.dataList = @[@{@"title":@"微信实名",@"placeholder":@"请输入微信实名"},
                          @{@"title":@"微信账号",@"placeholder":@"请输入微信账号"}];
    }else{
        self.title = @"绑定支付宝";
        
        self.dataList = @[@{@"title":@"支付宝实名",@"placeholder":@"请输入支付宝实名"},
                          @{@"title":@"支付宝账号",@"placeholder":@"请输入支付宝账号"}];
    }
    
    
    [self.tableView reloadData];
    
    [self initFooterView];
    
    UIButton *sureBtn = [FControlTool createButton:@"确定" font:[UIFont boldFontWithSize:18] textColor:UIColor.whiteColor target:self sel:@selector(sureBtnAction)];
    sureBtn.frame = CGRectMake(60, kScreenHeight - 104, kScreenWidth - 120, 52);
    sureBtn.backgroundColor = kMainColor;
    sureBtn.layer.cornerRadius = 26;
    sureBtn.layer.masksToBounds = YES;
    [self.view addSubview:sureBtn];
    
    if (self.model) {
        self.qrCodeUrl = self.model.usdt;
    }
}

- (void)initFooterView{
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(16, 0, kScreenWidth - 32, 0.5);
    lineView.backgroundColor = RGBColor(0xF2F2F2);
    [footerView addSubview:lineView];
    
    self.addBtn = [FControlTool createButton:@"" font:[UIFont fontWithSize:16] textColor:UIColor.blackColor target:self sel:@selector(addBtnAction)];
    self.addBtn.frame = CGRectMake((kScreenWidth - 200)/2, 24, 200, 26);
    self.addBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.addBtn setImage:[UIImage imageNamed:@"icn_card_add"] forState:UIControlStateNormal];
    [self.addBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (200 - 26)/2, 0, (200 - 26)/2)];
    [footerView addSubview:self.addBtn];
    
    [self.addBtn sd_setImageWithURL:[NSURL URLWithString:self.model.usdt] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icn_card_add"]];
    
    UILabel *titleLabel = [FControlTool createLabel:self.isWx? @"上传微信收款码":@"上传支付宝收款码" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
    titleLabel.frame = CGRectMake(16, self.addBtn.bottom+8, kScreenWidth - 32, 20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    
    UILabel *tipLabel = [FControlTool createLabel:@"请勿上传截图的收款码，请在二维码收款界面，点击保存收款码，上传图片 点击上传" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
    tipLabel.frame = CGRectMake(16, titleLabel.bottom+6, kScreenWidth - 32, 50);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    [footerView addSubview:tipLabel];
    
    NSString *warningStr = @"提示：绑定的支付宝账号实名和注册账户的实名必须要一致，否则提现不到账，自行负责";
    if (self.isWx) {
        warningStr = @"提示：绑定的微信账号实名和注册账户的实名必须要一致，否则提现不到账，自行负责";
    }
    
    UILabel *warnLabel = [FControlTool createLabel:warningStr textColor:UIColor.redColor font:[UIFont boldFontWithSize:15]];
    warnLabel.frame = CGRectMake(16, tipLabel.bottom+10, kScreenWidth - 32, 50);
    warnLabel.numberOfLines = 0;
    [footerView addSubview:warnLabel];
    
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBtnAction)];
    [footerView addGestureRecognizer:addTap];
    
    self.tableView.tableFooterView = footerView;
}

- (void)sureBtnAction{
    NSString *name = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).inputView.inputTextField.text;
    NSString *cardNo = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).inputView.inputTextField.text;
    if (name.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.isWx? @"请输入微信实名":@"请输入支付宝实名"];
        return;
    }
    if (cardNo.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.isWx? @"请输入微信账号":@"请输入支付宝账号"];
        return;
    }
    if (self.qrCodeUrl.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传收款码"];
        return;
    }
    @weakify(self)
    NSDictionary *data = @{@"userId":[FUserModel sharedUser].userID,@"phone":cardNo,@"name":name,@"usdt":self.qrCodeUrl,@"type":self.isWx?@(1):@(2)};
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:data];
    if (self.model) {
        params[@"id"] = self.model.cardId;
    }
    [[FNetworkManager sharedManager] postRequestFromServer:@"/bindCard/createUptadeZFB" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [weak_self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)addBtnAction{
    @weakify(self)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (@available(iOS 14, *)) {
                PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
                config.selectionLimit = 1;
                config.filter = [PHPickerFilter imagesFilter];
                config.preferredAssetRepresentationMode = PHPickerConfigurationAssetRepresentationModeCurrent;
                PHPickerViewController *vc = [[PHPickerViewController alloc] initWithConfiguration:config];
                vc.delegate = weak_self;
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [weak_self presentViewController:vc animated:YES completion:nil];
            } else {
                UIImagePickerController *vc = [[UIImagePickerController alloc] init];
                vc.delegate = weak_self;
                vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [weak_self presentViewController:vc animated:YES completion:nil];
            }
        });
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];

    [alert addAction:galleryAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//- (void)requestWithdraw:(NSString*)password{
//    @weakify(self)
//    [SVProgressHUD show];
//    NSString *name = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).inputView.inputTextField.text;
//    NSString *cardNo = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).inputView.inputTextField.text;
//    NSString *nickName = ((SWPasswordInputCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).inputView.inputTextField.text;
//    NSDictionary *params = @{@"payPassword":password,@"zfbNo":cardNo,@"name":name,@"amount":@(self.money),@"zfbUrl":self.qrCodeUrl,@"type":@"2"};
//    [[FNetworkManager sharedManager] postRequestFromServer:@"/withdraw/withdrawDeposit" parameters:params success:^(NSDictionary * _Nonnull response) {
//        if ([response[@"code"] integerValue] == 200) {
//            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
//            [weak_self.navigationController popViewControllerAnimated:YES];
//        }else {
//            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//    }];
//}

#pragma mark - PHPickerViewControllerDelegate
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)){
    PHPickerResult *result = results.firstObject;
    if (result) {
        @weakify(self);
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:[UIImage class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weak_self.qrCodeImage = object;
                    [SVProgressHUD show];
                    [[FNetworkManager sharedManager] uploadImgFromServer:@"/customer/upload" image:weak_self.qrCodeImage parameters:@{@"file":[NSString stringWithFormat:@"pic_%ld.jpg", (NSInteger)[[NSDate date] timeIntervalSince1970]]} progress:^(NSProgress * progress) {
                        NSLog(@"%lld_%lld",progress.completedUnitCount,progress.totalUnitCount);
                    } success:^(NSDictionary * _Nonnull response) {
                        if ([response[@"code"] integerValue] == 200) {
                            @strongify(self);
                            self.qrCodeUrl = response[@"data"][@"url"];
                            [self.addBtn setImage:self.qrCodeImage forState:UIControlStateNormal];
                            [SVProgressHUD dismiss];
                        }else {
                            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                        }
                    } failure:^(NSError * _Nonnull error) {
                        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                    }];
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
    
    self.qrCodeImage = image;
    @weakify(self);
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] uploadImgFromServer:@"/customer/upload" image:image parameters:@{@"file":[NSString stringWithFormat:@"pic_%ld.jpg", (NSInteger)[[NSDate date] timeIntervalSince1970]]} progress:^(NSProgress * progress) {
        NSLog(@"%lld_%lld",progress.completedUnitCount,progress.totalUnitCount);
    } success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            @strongify(self);
            self.qrCodeUrl = response[@"data"][@"url"];
            [self.addBtn setImage:self.qrCodeImage forState:UIControlStateNormal];
            [SVProgressHUD dismiss];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 12;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(0, 0, kScreenWidth, 12);
//    view.backgroundColor = RGBColor(0xF6F6F6);
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    SWPasswordInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SWPasswordInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.inputView.titleLabel.text = self.dataList[indexPath.row][@"title"];
    [cell.inputView setPlaceholder:self.dataList[indexPath.row][@"placeholder"]];
    if ([cell.inputView.titleLabel.text isEqualToString:@"支付宝实名"] || [cell.inputView.titleLabel.text isEqualToString:@"微信实名"]) {
        cell.inputView.inputTextField.text = self.model.name;
    }else if ([cell.inputView.titleLabel.text isEqualToString:@"支付宝账号"] || [cell.inputView.titleLabel.text isEqualToString:@"微信账号"]) {
        cell.inputView.inputTextField.text = self.model.phone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(0xF6F6F6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = RGBColor(0xF2F2F2);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
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

