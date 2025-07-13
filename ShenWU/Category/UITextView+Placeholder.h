
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double UITextView_PlaceholderVersionNumber;
FOUNDATION_EXPORT const unsigned char UITextView_PlaceholderVersionString[];

NS_ASSUME_NONNULL_BEGIN
@interface UITextView (Placeholder)

@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

- (void)updateTextWithLimitNum:(NSInteger)limitNumber;
- (void)updateTextWithLimitNum:(NSInteger)limitNumber alertStr:(nullable NSString *)alertStr;

@end
NS_ASSUME_NONNULL_END
