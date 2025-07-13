//
//  AliyunFaaceAuthFacade.h
//  AliyunFaceAuthFacade
//
//  Created by 汪澌哲 on 2022/11/21.
//  Copyright © 2022 DTF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DTFIdentityManager/DTFSdk.h>
#import <DTFIdentityManager/DTFIdentityManager.h>
#import <DTFIdentityManager/DTFConstant.h>

NS_ASSUME_NONNULL_BEGIN

@interface AliyunFaceAuthFacade : NSObject

+ (void)init;

+ (void)initSDK;

/* IPV6的初始化接口 只有你的网络环境强制要求是IPV6的时候，才调用initIPv6。
 */
+ (void)initIPv6;

+ (NSString *)getVersion;

+ (void)preload:(NSDictionary *)param completion:(void (^)(BOOL success))completion;

+ (NSDictionary *)getMetaInfo;

+ (void)verifyWith:(NSString *)zimId
         extParams:(NSDictionary *)params
      onCompletion:(ZIMCallback)callback;

@end

NS_ASSUME_NONNULL_END
