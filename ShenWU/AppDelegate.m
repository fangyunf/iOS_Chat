//
//  AppDelegate.m
//  ShenWU
//
//  Created by Amy on 2024/6/17.
//

#import "AppDelegate.h"
#import "SWLoginViewController.h"
#import "UITabBarItem+CYLBadgeExtention.h"
#import <AliyunFaceAuthFacade/AliyunFaceAuthFacade.h>
#import "FLaunchViewController.h"
#import "FCustomAttachemtDecoder.h"
#import "SWMessageConfigDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <AvoidCrash/AvoidCrash.h>
@interface AppDelegate ()<UITabBarControllerDelegate>
@property (nonatomic, strong) SWMessageConfigDelegate *sdkDelegate;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
    [self initSdk];
    
    NSArray *noneSelClassStrings = @[
                              @"NSNull",
                              @"NSNumber",
                              @"NSString",
                              @"NSDictionary",
                              @"NSArray"
                              ];
    [AvoidCrash setupNoneSelClassStringsArr:noneSelClassStrings];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    // 设置键盘和输入框之间的距离
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:80.0];
    // 当键盘弹起时，点击背景，键盘就会收回
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD setMaximumDismissTimeInterval:1.0];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    
    FLaunchViewController *vc = [[FLaunchViewController alloc] init];
    FNavViewController *nav = [[FNavViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    return YES;
}

- (void)automaticallyLogin {
    NSString *currentToken = kUserDefaultObjectForKey(UserToken);
    if (currentToken && currentToken.length != 0) {
        /// token存在，走自动登录逻辑
        FUserModel *model = nil;
        for (FUserModel *userModel in [[FUserModel sharedUser] getLocalSaveUserArray]) {
            if ([userModel.token isEqualToString:currentToken]) {
                model = userModel;
            }
        }
        [[FUserModel sharedUser] saveUserInfoWithPhone:model.phone NickName:model.nickName ImToken:model.imToken UserID:model.userID memberCode:model.memberCode AndUserToken:model.token avator:model.headerIcon AndVipLevel:[NSString stringWithFormat:@"%ld", model.levelType] AndAuthentication:@"0"];
        [self loginIM:^(BOOL success) {
            if (success) {
                [self initTabBarController];
            }
        }];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self initTabBarController];
//        });
    }else {
        SWLoginViewController *vc = [[SWLoginViewController alloc] init];
        FNavViewController *nav = [[FNavViewController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoguut:) name:FLoginOut object:nil];
}


- (void)initTabBarController{
    self.tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:[FControlTool tabViewControllers] tabBarItemsAttributes:[FControlTool tabBarItemsAttributes]];
    self.tabBarController.delegate = self;
    self.window.rootViewController = self.tabBarController;
    
    [[self cyl_tabBarController] hideTabBarShadowImageView];

    CYLTabBarController *tabBarController = [self cyl_tabBarController];
    tabBarController.tabBar.backgroundColor = RGBColor(0xF5F7FA);
    
    [self cyl_tabBarController].tabBar.unselectedItemTintColor = RGBColor(0x959595);
    [self cyl_tabBarController].tabBar.tintColor = UIColor.blackColor;
    
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];//开启近距离监听事件
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(sensorStateChange:)
//                                                 name:@"UIDeviceProximityStateDidChangeNotification"
//                                               object:nil];//添加一个监听
}

//-(void)sensorStateChange:(NSNotificationCenter *)notification;
//{
//    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
//    if ([[UIDevice currentDevice] proximityState] == YES)
//    {
//        [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceReceiver];
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    }else{
//        [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    }
//}

- (void)initSdk{
    self.sdkDelegate = [[SWMessageConfigDelegate alloc] init];
    [[NIMSDKConfig sharedConfig] setDelegate:self.sdkDelegate];
    // 初始化NIMSDK
    NIMSDKOption *option = [NIMSDKOption optionWithAppKey:IMKey];
    option.apnsCername = @"";
    option.pkCername = @"";
    [[IMKitClient instance] setupCoreKitIM:option];
    
    [NIMCustomObject registerCustomDecoder:[[FCustomAttachemtDecoder alloc] init]];
    
    [AliyunFaceAuthFacade initSDK];
    
    [[NIMSDK sharedSDK].mediaManager setNeedProximityMonitor:YES];
    [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
    [NIMSDKConfig sharedConfig].shouldSyncUnreadCount = YES;
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self registerRouter];
}

- (void)registerRouter {
    [ContactRouter register];
    [ChatRouter register];
    [TeamRouter register];
    [ConversationRouter register];
    
}

- (void)loginIM:( void (^ _Nullable )(BOOL success))block {
    @weakify(self);
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/getUserByToken" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        @strongify(self);
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
            [FUserModel sharedUser].hy = [userDict[@"hy"] boolValue];
            [FUserModel sharedUser].usdtStr = userDict[@"usdt"];
            [FUserModel sharedUser].busUsdtStr = userDict[@"busUsdt"];
            [FUserModel sharedUser].huiLvStr = userDict[@"huiLv"];
            kUserDefaultSetObjectForKey([FUserModel sharedUser].userID, @"CurrentUserId");
            [[[NIMSDK sharedSDK] loginManager] login:[FUserModel sharedUser].userID token:[FUserModel sharedUser].imToken authType:NIMSDKAuthTypeDefault loginExt:@"" completion:^(NSError *error)
             {
                self.isIMLogin = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:FIMLoginSuccess object:nil];
                if (!error) {
                    [NEAtMessageManager setupInstance];
                    [[FUserRelationManager sharedManager] reloadAllFriendsData:nil];
                    [[FUserRelationManager sharedManager] reloadAllGroupsData:nil];
                    [[FMessageManager sharedManager] initData];
                    [[FMessageManager sharedManager] requestApplyListNum];
                    [[FMessageManager sharedManager] getServiceAccount];
                    [[FMessageManager sharedManager] getAideNewsAccount];
                    [SVProgressHUD dismiss];
                }else{
                    kUserDefaultSetObjectForKey(@"", UserToken);
                    [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];
                    [self userLoguut:nil];
                }
                block(YES);
                NSLog(@"error === :%@",error);
             }];
        }else {
            block(NO);
            kUserDefaultSetObjectForKey(@"", UserToken);
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            @strongify(self);
            [self userLoguut:nil];
        }
    } failure:^(NSError * _Nonnull error) {
        block(NO);
        kUserDefaultSetObjectForKey(@"", UserToken);
        [SVProgressHUD dismiss];
        @strongify(self);
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [self userLoguut:nil];
    }];
}

- (void)userLoguut:(NSNotification *)notifica{
    NSDictionary *dict = notifica.object;
    __block NSString *token = @"";
    __block NSString *phone = @"";
    if (dict.count > 0) {
        token = dict[@"token"];
        phone = dict[@"phone"];
        NSLog(@"token  == :%@",token);
        NSLog(@"phone  == :%@",[FUserModel sharedUser].phone);
    }
    [[IMKitClient instance] logout:^(NSError * err) {
        kUserDefaultSetObjectForKey(@"", UserToken);
        dispatch_async(dispatch_get_main_queue(), ^{
            SWLoginViewController *vc = [[SWLoginViewController alloc] init];
            FNavViewController *nav = [[FNavViewController alloc] initWithRootViewController:vc];
            self.window.rootViewController = nav;
            if (token.length > 0) {
                [SVProgressHUD show];
            }
        });
        if (token.length > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                kUserDefaultSetObjectForKey(token, UserToken);
                [FUserModel sharedUser].phone = phone;
                [kAppDelegate automaticallyLogin];
            });
        }
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FRefreshRechargeResult object:nil];
    });
    
}

- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"%@",note.userInfo);
}

@end
