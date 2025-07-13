//
//  UIView+Extension.h
//  Assistant
//
//  Created by Amy on 2023/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)

- (void)rounded:(CGFloat)cornerRadius;


- (void)rounded:(CGFloat)cornerRadius
          width:(CGFloat)borderWidth
          color:( UIColor * _Nullable )borderColor;

- (void)round:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner;

- (void)setRoundedCorner:(CGFloat)radii;

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
