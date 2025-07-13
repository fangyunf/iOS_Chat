//
//  AppDelegate.h
//  ShenWU
//
//  Created by Amy on 2024/6/17.
//

#import <UIKit/UIKit.h>
#import "CYLTabBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isIMLogin;
@property (strong, nonatomic) CYLTabBarController *tabBarController;
- (void)loginIM:(void (^ _Nullable )(BOOL success))block;
- (void)initTabBarController;
- (void)automaticallyLogin;

@end

