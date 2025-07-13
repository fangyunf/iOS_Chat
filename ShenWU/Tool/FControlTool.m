//
//  FControlTool.m
//  Fiesta
//
//  Created by Amy on 2024/5/23.
//

#import "FControlTool.h"
#import "SWMineViewController.h"
#import "SWMessageViewController.h"
#import "SWFriendViewController.h"
#import "SWFriendMessageViewController.h"
#import <CYLTabBarController/CYLTabBarController.h>
#import "UIImage+Extension.h"
#import "TKAddressBookViewController.h"
#import "SWShopViewController.h"
@implementation FControlTool
+ (UIButton *)createButton:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color target:(id)target sel:(SEL)sel {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createButton:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)createButtonWithImage:(UIImage *)image target:(id)target sel:(SEL)sel {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createButtonWithBackImage:(UIImage *)image target:(id)target sel:(SEL)sel {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createCommonButtonWithText:(NSString *)text target:(id)target sel:(SEL)sel {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = kMainColor;
    button.titleLabel.font = [UIFont boldFontWithSize:16];
    button.layer.cornerRadius = 22;
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createCommonButton:(NSString *)title font:(UIFont *)font cornerRadius:(CGFloat)cornerRadius size:(CGSize)size target:(id)target sel:(SEL)sel {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = font;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage getCommonGradienImage:CGSizeMake(size.width * 2, size.height * 2) cornerRadius:cornerRadius] forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)createBackImageButtonWithTarget:(id)target sel:(SEL)sel {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UILabel *)createLabel:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment lineNum:(NSInteger)lineNum {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = alignment;
    label.numberOfLines = lineNum;
    return label;
}

+ (UILabel *)createLabel:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font {
    return [FControlTool createLabel:text textColor:textColor font:font alignment:NSTextAlignmentLeft lineNum:1];
}

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame withImage:(nullable UIImage * )image {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    if (image) {
        imageView.image = image;
    }
    return imageView;
}

+ (UIImageView *)createImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    return imageView;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UINavigationController *)getCurrentDisplayNavigationController
{
    UIViewController *lastController = [self getCurrentVC];
    if (lastController) {
        return lastController.navigationController;
    }
    return nil;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
          currentVC = rootVC;
    }

    return currentVC;
}

+ (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

+ (NSArray *)tabViewControllers{
//    SWFriendMessageViewController *friendMsgVC = [[SWFriendMessageViewController alloc]init];
//    FNavViewController *friendMsgNav = [[FNavViewController alloc]initWithRootViewController:friendMsgVC];
    
    SWMessageViewController *groupMsgVC = [[SWMessageViewController alloc]init];
    FNavViewController *groupMsgNav = [[FNavViewController alloc]initWithRootViewController:groupMsgVC];

    TKAddressBookViewController *friendVC = [[TKAddressBookViewController alloc]init];
    FNavViewController *friendNav = [[FNavViewController alloc]initWithRootViewController:friendVC];
    
//    SWShopViewController *shopVC = [[SWShopViewController alloc]init];
//    FNavViewController *shopNav = [[FNavViewController alloc]initWithRootViewController:shopVC];

    SWMineViewController *mineVC = [[SWMineViewController alloc]init];
    FNavViewController *mineNav = [[FNavViewController alloc]initWithRootViewController:mineVC];

    return @[groupMsgNav,friendNav,mineNav];
    
}

+ (NSArray *)tabBarItemsAttributes{
    
    NSDictionary *tabBarItemsAttributes1 = @{
          CYLTabBarItemTitle: @"对话",
          CYLTabBarItemImage: @"icn_tab_message",
          CYLTabBarItemSelectedImage: @"icn_tab_message_sel",
      };
//    NSDictionary *tabBarItemsAttributes2 = @{
//          CYLTabBarItemTitle: @"群聊",
//          CYLTabBarItemImage: @"icn_tab_group",
//          CYLTabBarItemSelectedImage: @"icn_tab_group_sel",
//      };
    NSDictionary *tabBarItemsAttributes3 = @{
          CYLTabBarItemTitle: @"联系人",
          CYLTabBarItemImage: @"icn_tab_friend",
          CYLTabBarItemSelectedImage: @"icn_tab_friend_sel",
      };
//    NSDictionary *tabBarItemsAttributes4 = @{
//          CYLTabBarItemTitle: @"商城",
//          CYLTabBarItemImage: @"icn_tab_shop",
//          CYLTabBarItemSelectedImage: @"icn_tab_shop_sel",
//      };
    NSDictionary *tabBarItemsAttributes5 = @{
          CYLTabBarItemTitle: @"我的",
          CYLTabBarItemImage: @"icn_tab_mine",
          CYLTabBarItemSelectedImage: @"icn_tab_mine_sel",
      };
    return @[tabBarItemsAttributes1,tabBarItemsAttributes3,tabBarItemsAttributes5];
    
}


+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // 先进行尺寸压缩
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    
    UIImage *resultImage = image;
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        
        // 每次尺寸减少的比例
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // 再进行质量压缩
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return data;
}

@end
