//
//  FLaunchViewController.m
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

#import "FLaunchViewController.h"
//#import "FVersionUpdateTipView.h"
@interface FLaunchViewController ()

@end

@implementation FLaunchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = self.view.bounds;
    imageView.image = [UIImage imageNamed:@"launch"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
//    [self checkVersionUpdate];
//    [self loadIndexInfo];
    [kAppDelegate automaticallyLogin];
}

- (void)loadIndexInfo {
    [[FNetworkManager sharedManager] postRequestFromServer:@"/customer/indexTwo" parameters:@{@"version":@"1"} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [FIndexModel shareModel].uSwitch = [response[@"data"][@"uSwith"] isEqualToString:@"1"];
            [FIndexModel shareModel].officialUrl = response[@"data"][@"guanWang"];
            [FIndexModel shareModel].yszcUrl = response[@"data"][@"yszc"];
            [FIndexModel shareModel].fwxyUrl = response[@"data"][@"fwxy"];
            [FIndexModel shareModel].aboutUsStr = response[@"data"][@"jianJie"];
            [FIndexModel shareModel].downloadUrl = response[@"data"][@"downloadUrl"];
            [FIndexModel shareModel].keyword = response[@"data"][@"keyword"];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)checkVersionUpdate {
    @weakify(self)
    [[FNetworkManager sharedManager] getRequestFromServer:@"/customer/versionCkeck" parameters:@{@"type":@"IOS", @"version":AppBuildVersion} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            /// 有更新
            __block NSDictionary *data = response[@"data"];
            if (![FDataTool isNull:data]) {
                NSInteger type = [data[@"type"] integerValue];
                if (type == 1) {
                    /// 这里指做强制更新的控件
                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"upMsg"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data[@"downloadUrl"]] options:@{} completionHandler:^(BOOL success) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                exit(0);
                            });
                        }];
                    }];
                    [alertVc addAction:sureAction];
                    [self presentViewController:alertVc animated:YES completion:nil];
                }else {
                    [kAppDelegate automaticallyLogin];
                }
            }else{
                [kAppDelegate automaticallyLogin];
            }
        }else {
            [kAppDelegate automaticallyLogin];
        }
    } failure:^(NSError * _Nonnull error) {
        [kAppDelegate automaticallyLogin];
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
