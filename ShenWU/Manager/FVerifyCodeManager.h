//
//  FVerifyCodeManager.h
//  Fiesta
//
//  Created by Amy on 2024/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FVerifyCodeManager : NSObject
+ (instancetype)sharedManager;
- (void)getVerifyCodeOnVC:(UIViewController *_Nullable)vc requestUrl:(NSString *)url andPhone:(NSString *)phone success:(void(^)(void))successBlock cancel:(void(^)(void))cancelBlock;
@end

NS_ASSUME_NONNULL_END
