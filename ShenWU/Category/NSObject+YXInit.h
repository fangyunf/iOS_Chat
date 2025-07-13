//
//  NSObject+YXInit.h
//  ZLScaffoldDemo
//
//  Created by mostar on 2022/11/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YXInit)

/// 通用初始化方法
/// - Parameter initBlock: 初始化block
/// UILabel *label = [UILabel YXInitWithBlock:^(UILabel * _Nonnull x) {
/// 将 id 强转为自己的类名 * 
+ (instancetype)YXInitWithBlock:(void(^)(id x))initBlock;

@end

NS_ASSUME_NONNULL_END
