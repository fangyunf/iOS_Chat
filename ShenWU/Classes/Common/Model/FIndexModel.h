//
//  FIndexModel.h
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *webBaseUrl = @"http://yyx.qnygcm.xyz/dist/build/h5/index.html#/";

@interface FIndexModel : NSObject
+ (instancetype)shareModel;

/// 显示U币
@property (nonatomic, assign) BOOL uSwitch;

/// 官网地址
@property (nonatomic, strong) NSString *officialUrl;

/// 隐私政策路径
@property (nonatomic, strong) NSString *yszcUrl;

/// 服务协议路径
@property (nonatomic, strong) NSString *fwxyUrl;

/// 关于我们
@property (nonatomic, strong) NSString *aboutUsStr;

/// 下载地址
@property (nonatomic, strong) NSString *downloadUrl;

/// 查询关键字
@property (nonatomic, strong) NSArray<NSString *> *keyword;
@end

NS_ASSUME_NONNULL_END
