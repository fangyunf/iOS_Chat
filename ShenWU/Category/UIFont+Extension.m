//
//  UIFont+Extension.m
//  Assistant
//
//  Created by Amy on 2023/10/12.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)
+ (instancetype)semiBoldFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}

+ (instancetype)boldFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}

+ (instancetype)fontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (instancetype)regularFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}
@end
