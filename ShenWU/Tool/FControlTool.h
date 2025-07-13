//
//  FControlTool.h
//  Fiesta
//
//  Created by Amy on 2024/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FControlTool : NSObject
+ (UIButton *)createButton:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color target:(id)target sel:(SEL)sel;

+ (UIButton *)createButtonWithImage:(UIImage *)image target:(id)target sel:(SEL)sel;

+ (UIButton *)createButtonWithBackImage:(UIImage *)image target:(id)target sel:(SEL)sel;

+ (UILabel *)createLabel:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment lineNum:(NSInteger)lineNum;

+ (UILabel *)createLabel:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame withImage:(nullable UIImage * )image;

+ (UIButton *)createCommonButtonWithText:(NSString *)text target:(id)target sel:(SEL)sel;

+ (UIButton *)createCommonButton:(NSString *)title font:(UIFont *)font cornerRadius:(CGFloat)cornerRadius size:(CGSize)size target:(id)target sel:(SEL)sel;

+ (UIButton *)createButton:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color;

+ (UIImageView *)createImageView;

+ (UIViewController *)getCurrentVC;

+ (UIWindow *)keyWindow;

+ (NSArray *)tabBarItemsAttributes;

+ (NSArray *)tabViewControllers;

+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;
@end

NS_ASSUME_NONNULL_END
