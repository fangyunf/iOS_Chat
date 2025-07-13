//
//  UIButton+Extension.h
//  Assistant
//
//  Created by Amy on 2023/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    ButtonEdgeInsetsStyleTop,
    ButtonEdgeInsetsStyleLeft,
    ButtonEdgeInsetsStyleBottom,
    ButtonEdgeInsetsStyleRight
};


@interface UIButton (Extension)
- (void)layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;
@end

NS_ASSUME_NONNULL_END
