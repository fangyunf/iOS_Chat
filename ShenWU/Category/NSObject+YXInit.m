//
//  NSObject+YXInit.m
//  ZLScaffoldDemo
//
//  Created by mostar on 2022/11/2.
//

#import "NSObject+YXInit.h"

@implementation NSObject (YXInit)

+ (instancetype)YXInitWithBlock:(void (^)(id _Nonnull))initBlock {
    id x = [[self alloc] init];
    if (initBlock) {
        initBlock(x);
    }
    return x;
}

@end
