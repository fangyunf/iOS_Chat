//
//  SWEidtInfoViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/21.
//

#import "SWEidtInfoViewController.h"
#import <PhotosUI/PhotosUI.h>
#import "SWEditNameView.h"
#import "TKEditInfoView.h"
@interface SWEidtInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,PHPickerViewControllerDelegate>
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *idLabel;
@property(nonatomic, strong) UIImage *avatarImg;
@property(nonatomic, strong) NSString *avatarUrl;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) TKEditInfoView *nameEditView;
@property(nonatomic, strong) TKEditInfoView *idEditView;
@property(nonatomic, strong) TKEditInfoView *phoneEditView;
@end

@implementation SWEidtInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的资料";
    
    self.avatarUrl = [FUserModel sharedUser].headerIcon;
    self.userName = [FUserModel sharedUser].nickName;
    
    self.view.backgroundColor = RGBColor(0xF2F2F2);
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(15, 100+kStatusHeight, kScreenWidth - 30, 117);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    self.avatarImgView = [[UIImageView alloc] init];
    self.avatarImgView.frame = CGRectMake((kScreenWidth - 80)/2, 100+kStatusHeight-32, 80, 80);
    [self.avatarImgView rounded:8];
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImgView.userInteractionEnabled = YES;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[FUserModel sharedUser].headerIcon] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    [self.view addSubview:self.avatarImgView];
    
    UIButton *uploadAvatarBtn = [FControlTool createButton:@"上传头像" font:[UIFont boldFontWithSize:15] textColor:RGBColor(0x666666) target:self sel:@selector(uploadAvatarBtnAction)];
    uploadAvatarBtn.frame = CGRectMake(bgView.width - 69, 41, 61, 62);
    [uploadAvatarBtn setImage:[UIImage imageNamed:@"icn_info_camre"] forState:UIControlStateNormal];
    [uploadAvatarBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:8];
    [bgView addSubview:uploadAvatarBtn];

    
    self.nameLabel = [FControlTool createLabel:[FUserModel sharedUser].nickName textColor:UIColor.blackColor font:[UIFont boldFontWithSize:18]];
    self.nameLabel.frame = CGRectMake(16, 56, bgView.width - 116, 21);
    [bgView addSubview:self.nameLabel];
    
    self.idLabel = [FControlTool createLabel:[NSString stringWithFormat:@"ID:%@",[FUserModel sharedUser].memberCode] textColor:RGBColor(0x666666) font:[UIFont fontWithSize:12]];
    self.idLabel.frame = CGRectMake(16, self.nameLabel.bottom+5, bgView.width - 116, 15);
    self.idLabel.layer.masksToBounds = YES;
    [bgView addSubview:self.idLabel];
    
    self.nameEditView = [[TKEditInfoView alloc] initWithFrame:CGRectMake(0, bgView.bottom+31, kScreenWidth, 103)];
    self.nameEditView.titleLabel.text = @"我的昵称";
    self.nameEditView.tipLabel.text = @"昵称7天内只能修改一次";
    self.nameEditView.contentLabel.text = self.userName;
    self.nameEditView.detailLabel.hidden = YES;
    [self.view addSubview:self.nameEditView];
    
//    self.idEditView = [[TKEditInfoView alloc] initWithFrame:CGRectMake(0, self.nameEditView.bottom+34, kScreenWidth, 103)];
//    self.idEditView.titleLabel.text = @"我的ID";
//    self.idEditView.tipLabel.text = @"暂不可在此修改";
//    self.idEditView.contentLabel.text = [FUserModel sharedUser].memberCode;
//    self.idEditView.detailLabel.hidden = YES;
//    self.idEditView.arrowImgView.hidden = YES;
//    [self.view addSubview:self.idEditView];
//    
//    self.phoneEditView = [[TKEditInfoView alloc] initWithFrame:CGRectMake(0, self.idEditView.bottom+34, kScreenWidth, 103)];
//    self.phoneEditView.titleLabel.text = @"我的手机号";
//    self.phoneEditView.tipLabel.text = @"暂不可在此修改";
//    self.phoneEditView.contentLabel.text = [FUserModel sharedUser].phone;
//    self.phoneEditView.detailLabel.hidden = YES;
//    self.phoneEditView.arrowImgView.hidden = YES;
//    [self.view addSubview:self.phoneEditView];
    
    UITapGestureRecognizer *editNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editNameBtnAction)];
    [self.nameEditView addGestureRecognizer:editNameTap];
    
    [self refreshView];
}

- (void)refreshView{
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    
    self.nameLabel.text = self.userName;
    
}

- (void)editNameBtnAction{
    SWEditNameView *view = [[SWEditNameView alloc] initWithFrame:self.view.bounds];
    view.titleLabel.text = @"修改昵称";
    [[FControlTool keyWindow] addSubview:view];
    [view show];
    @weakify(self)
    view.saveName = ^(NSString * _Nonnull name) {
        weak_self.userName = name;
        [weak_self refreshView];
        [weak_self requestChangeName];
    };
}

- (void)requestChangeName{
    NSDictionary *params = @{@"name":self.userName};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/changeInfo" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [FUserModel sharedUser].headerIcon = weak_self.avatarUrl;
            [FUserModel sharedUser].nickName = weak_self.userName;
            [[FUserModel sharedUser] saveUserInfo];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)uploadAvatarBtnAction{
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
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.delegate = weak_self;
        vc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weak_self presentViewController:vc animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];

    [alert addAction:galleryAction];
    [alert addAction:cameraAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sureBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
//    NSDictionary *params = @{@"avatar":self.avatarUrl,@"name":self.userName};
//    @weakify(self)
//    [SVProgressHUD show];
//    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/changeInfo" parameters:params success:^(NSDictionary * _Nonnull response) {
//        if ([response[@"code"] integerValue] == 200) {
//            [FUserModel sharedUser].headerIcon = weak_self.avatarUrl;
//            [FUserModel sharedUser].nickName = weak_self.userName;
//            [[FUserModel sharedUser] saveUserInfo];
//            [SVProgressHUD dismiss];
//            [weak_self.navigationController popViewControllerAnimated:YES];
//        }else{
//            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
//        }
//        
//    } failure:^(NSError * _Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//    }];
}

#pragma mark - PHPickerViewControllerDelegate
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)){
    PHPickerResult *result = results.firstObject;
    if (result) {
        @weakify(self);
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:[UIImage class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weak_self.avatarImg = object;
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
    
    self.avatarImg = image;
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
            self.avatarUrl = response[@"data"][@"url"];
            [self refreshView];
            [self requestChangeAvatar];
        }else {
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)requestChangeAvatar{
    NSDictionary *params = @{@"avatar":self.avatarUrl};
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/changeInfo" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [FUserModel sharedUser].headerIcon = weak_self.avatarUrl;
            [FUserModel sharedUser].nickName = weak_self.userName;
            [[FUserModel sharedUser] saveUserInfo];
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
