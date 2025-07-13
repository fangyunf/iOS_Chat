//
//  UIFont+Extension.h
//  Assistant
//
//  Created by Amy on 2023/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Extension)
+ (instancetype)semiBoldFontWithSize:(CGFloat)size;

+ (instancetype)boldFontWithSize:(CGFloat)size;

+ (instancetype)fontWithSize:(CGFloat)size;

+ (instancetype)regularFontWithSize:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
