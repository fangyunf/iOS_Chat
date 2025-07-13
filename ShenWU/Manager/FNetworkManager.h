//
//  FNetworkManager.h
//  Fiesta
//
//  Created by Amy on 2024/6/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define NetAesKey @"wesecretpaddingg"
#define BaseUrl @"http://longyu517xink.chengsuyun.com"

@interface FNetworkManager : NSObject
@property (nonatomic, strong, readonly) NSString *netAesKey;
+ (instancetype)sharedManager;
- (NSURLSessionDataTask *) getRequestFromServer:(NSString *)url parameters:(id _Nullable)parameters resultClass:(Class)resultClass success:(void (^)(id object))success failure:(void (^)(NSError *error, _Nullable id object))failure;
- (void) getRequestFromServer:(NSString *)url parameters:(id)parameters success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failur;
- (void )postRequestFromServer:(NSString *)url parameters:(id)parameters success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failur;
- (void)uploadImgFromServer:(NSString *)url image:(UIImage*)image parameters:(id)parameters  progress:(nullable void (^)(NSProgress * _Nonnull progress))progress success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failur;
@end

NS_ASSUME_NONNULL_END
