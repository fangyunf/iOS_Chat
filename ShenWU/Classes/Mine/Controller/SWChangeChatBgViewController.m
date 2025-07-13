//
//  SWChangeChatBgViewController.m
//  ShenWU
//
//  Created by Amy on 2024/10/25.
//

#import "SWChangeChatBgViewController.h"
#import <PhotosUI/PhotosUI.h>

@interface SWChangeChatBgViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,PHPickerViewControllerDelegate>
@property(nonatomic, strong) UIImageView *bgImgView;
@property(nonatomic, strong) UIImage *bgImage;
@property(nonatomic, strong) NSString *bgImageName;
@end

@implementation SWChangeChatBgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更换聊天背景";
    
    self.bgImgView = [FControlTool createImageView];
    self.bgImgView.frame = self.view.bounds;
    self.bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"chat_bg_%u",arc4random()%12+1]];
    [self.view addSubview:self.bgImgView];
    
    UIButton *sureBtn = [FControlTool createButton:@"确定" font:[UIFont boldFontWithSize:18] textColor:UIColor.blackColor target:self sel:@selector(sureBtnAction)];
    sureBtn.frame = CGRectMake((kScreenWidth - 303)/2, kScreenHeight - 274, 303, 63);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"bg_skin_btn"] forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];
    
    UIButton *changeBtn = [FControlTool createButton:@"换一张" font:[UIFont boldFontWithSize:18] textColor:UIColor.blackColor target:self sel:@selector(changeBtnAction)];
    changeBtn.frame = CGRectMake((kScreenWidth - 303)/2, sureBtn.bottom+10, 303, 63);
    [changeBtn setBackgroundImage:[UIImage imageNamed:@"bg_skin_btn"] forState:UIControlStateNormal];
    [self.view addSubview:changeBtn];
    
    UIButton *photoBtn = [FControlTool createButton:@"从相册中上传" font:[UIFont boldFontWithSize:18] textColor:UIColor.blackColor target:self sel:@selector(photoBtnAction)];
    photoBtn.frame = CGRectMake((kScreenWidth - 303)/2, changeBtn.bottom+10, 303, 63);
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"bg_skin_btn"] forState:UIControlStateNormal];
    [self.view addSubview:photoBtn];
}

- (void)sureBtnAction{
    if(self.bgImage){
        self.bgImageName = @"local_chat_skin";
        [FDataTool storeImage:UIImageJPEGRepresentation(self.bgImage, 0.5) withImageName:self.bgImageName];
    }
    kUserDefaultSetObjectForKey(self.bgImageName, @"chatSkinName");
    [SVProgressHUD showSuccessWithStatus:@"设置成功"];
}

- (void)changeBtnAction{
    self.bgImage = nil;
    self.bgImageName = [NSString stringWithFormat:@"chat_bg_%u",arc4random()%12+1];
    self.bgImgView.image = [UIImage imageNamed:self.bgImageName];
}

- (void)photoBtnAction{
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
                    weak_self.bgImage = object;
                    weak_self.bgImgView.image = object;
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
    self.bgImgView.image = image;
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
