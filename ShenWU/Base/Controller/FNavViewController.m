//
//  FNavViewController.m
//  Fiesta
//
//  Created by Amy on 2024/5/23.
//

#import "FNavViewController.h"

@interface FNavViewController ()<UINavigationControllerDelegate>

@end

@implementation FNavViewController

+ (void)initialize
{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = UIColor.clearColor;
    self.navigationBar.tintColor = UIColor.whiteColor;
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setShadowImage:[UIImage new]];
    self.interactivePopGestureRecognizer.delegate = (id)self;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_top"] forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
    self.navigationBar.titleTextAttributes = attribute;
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([[self childViewControllers] count]) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"icn_nav_back"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 30, 44);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        UIBarButtonItem *barBut = [[UIBarButtonItem alloc] initWithCustomView:button];
        viewController.navigationItem.leftBarButtonItem = barBut;
    }

    [super pushViewController:viewController animated:animated];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popViewController" object:nil];
    return [super popViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.navigationController.viewControllers.count == 1) {
        NSLog(@"class == :%@",[viewController class]);
    }
    
}

- (void)backButtonAction {
    [self popViewControllerAnimated:YES];
}

@end
