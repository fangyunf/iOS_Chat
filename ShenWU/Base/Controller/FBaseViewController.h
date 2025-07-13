//
//  FBaseViewController.h
//  Fiesta
//
//  Created by Amy on 2024/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBaseViewController : UIViewController
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, strong) UIImageView *navTopView;
- (void)setWhiteNavBack;
- (void)keyboardHide:(id _Nullable)sender;
- (void)removeKeyHideTap;
- (UIBarButtonItem *)getRightBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)selector;
- (UIBarButtonItem *)getRightBarButtonItem:(NSString *)imgstr target:(id)target action:(SEL)selector;
- (UIBarButtonItem *)getLeftBarButtonItem:(NSString *)imgstr target:(id)target action:(SEL)selector;
@end

NS_ASSUME_NONNULL_END
