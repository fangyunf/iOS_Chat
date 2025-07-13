//
//  DTFSDKConfiguration.h
//  DTFUtility
//
//  Created by 汪澌哲 on 2023/5/22.
//  Copyright © 2023 com.alipay.iphoneclient.zoloz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTFSDKConfiguration : NSObject
@property (nonatomic, strong) NSString *LOG_UPLOAD;
@property (nonatomic, strong) NSString *LOG_DEBUG_UPLOAD;
@property (nonatomic, copy) NSString *forceModelDownload;
@property (nonatomic, copy) NSArray *modelUrlList;
- (instancetype)initWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
