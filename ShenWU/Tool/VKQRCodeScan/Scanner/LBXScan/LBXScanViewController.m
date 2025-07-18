//
//
//  
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "LBXScanViewController.h"
//#import "HXPhotoViewController.h"

@interface LBXScanViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>//<HXPhotoViewControllerDelegate>


//@property (strong, nonatomic) HXPhotoManager *manager;

@end

@implementation LBXScanViewController

//- (HXPhotoManager *)manager{
//    if (!_manager) {
//        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
//        _manager.openCamera = NO;
//        _manager.isSinglePhoto = YES; // 单选,默认多选
//    }
//    return _manager;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self drawScanView];
    
    
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
}

//绘制扫描区域
- (void)drawScanView
{
    if (!_qRScanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.qRScanView = [[LBXScanView alloc]initWithFrame:rect style:_style];
        
        [self.view addSubview:_qRScanView];
    
    }
    
      [_qRScanView startDeviceReadyingWithText:@"相机启动中"];
    
    
}

- (void)reStartDevice
{
    [_scanObj startScan];
}

//启动设备
- (void)startScan
{
    if ( ![LBXScanWrapper isGetCameraPermission] )
    {
        [_qRScanView stopDeviceReadying];
        
        [self showError:@"   请到设置隐私中开启本程序相机权限   "];
        return;
    }
    
  
    
    if (!_scanObj )
    {
        __weak __typeof(self) weakSelf = self;
         // AVMetadataObjectTypeQRCode   AVMetadataObjectTypeEAN13Code
        
        CGRect cropRect = CGRectZero;
        
        if (_isOpenInterestRect) {
            
            cropRect = [LBXScanView getScanRectWithPreView:self.view style:_style];
        }
        
        UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        videoView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:videoView atIndex:0];

        self.scanObj = [[LBXScanWrapper alloc]initWithPreView:videoView
                                              ArrayObjectType:nil
                                                     cropRect:cropRect
                                                      success:^(NSArray<LBXScanResult *> *array){
                                                          [weakSelf scanResultWithArray:array];
                                                      }];
        
        [_scanObj setNeedCaptureImage:_isNeedScanImage];
        
        [self cameraInitOver];
      
    }
    [_scanObj startScan];


    [_qRScanView stopDeviceReadying];
    
    [_qRScanView startScanAnimation];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)cameraInitOver
{
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [_scanObj stopScan];
    [_qRScanView stopScanAnimation];
}



#pragma mark -实现类继承该方法，作出对应处理
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
}





//开关闪光灯
- (void)openOrCloseFlash
{
    [_scanObj openOrCloseFlash];
    
    self.isOpenFlash =!self.isOpenFlash;
    
}


#pragma mark --打开相册并识别图片

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    pickerController.allowsEditing = NO;
    
    [self presentViewController:pickerController animated:YES completion:nil];
    
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    
//    picker.delegate = self;
//   
//    
////    picker.allowsEditing = YES;
//    
//    
//    [self presentViewController:picker animated:YES completion:nil];
    
    
    
    
//    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
//    vc.delegate = self;
//    vc.manager = self.manager;
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

//- (void)photoViewControllerDidNext:(NSArray *)allList Photos:(NSArray *)photos Videos:(NSArray *)videos Original:(BOOL)original{
//    HXPhotoModel *model = photos[0];
//    
//    [HXPhotoTools FetchPhotoForPHAsset:model.asset Size:model.imageSize resizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *image, NSDictionary *info) {
//        if ([info objectForKey:@"idc"]){
//            [VKViewTool alert:@"提示" msg:@"iCloud照片请在系统相册下载后再选择"];
//        } else {
//            __weak __typeof(self) weakSelf = self;
//            [LBXScanWrapper recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
//                
//                [weakSelf scanResultWithArray:array];
//            }];
//        }
//    }];
//}
//
//- (void)photoViewControllerDidCancel{
//    
//}


//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];    
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXScanWrapper recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
        
        [weakSelf scanResultWithArray:array];
    }];
    
   
    
    //系统自带识别方法
    /*
     CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
     NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
     if (features.count >=1)
     {
     CIQRCodeFeature *feature = [features objectAtIndex:0];
     NSString *scanResult = feature.messageString;
     
     NSLog(@"%@",scanResult);
     }
     */
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//子类继承必须实现的提示
- (void)showError:(NSString*)str
{
    
}

@end
