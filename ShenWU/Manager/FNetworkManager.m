//
//  FNetworkManager.m
//  Fiesta
//
//  Created by Amy on 2024/6/5.
//

#import "FNetworkManager.h"
#import "SVProgressHUD.h"
#import "SWRealNameViewController.h"



@interface FNetworkManager ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation FNetworkManager
+ (instancetype)sharedManager{
    static FNetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        _manager.requestSerializer.timeoutInterval = 60;
        [_manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
        [_manager.requestSerializer setValue:@"Mobile" forHTTPHeaderField:@"user-agent"];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *token = kUserDefaultObjectForKey(UserToken);
        if (token && token.length != 0) {
            [_manager.requestSerializer setValue:kUserDefaultObjectForKey(UserToken) forHTTPHeaderField:@"Authorization"];
        }
        NSString *phone = [FUserModel sharedUser].phone;
        if (phone && phone.length != 0) {
            [_manager.requestSerializer setValue:phone forHTTPHeaderField:@"phone"];
        }
    }
    return self;
}

- (NSString *)netAesKey {
    /// 修改这个的时候，需要全局搜索一下
    return NetAesKey;
}

#pragma mark network request

- (NSURLSessionDataTask *) getRequestFromServer:(NSString *)url parameters:(id)parameters resultClass:(Class)resultClass success:(void (^)(id object))success failure:(void (^)(NSError *error, _Nullable id object))failure {
    NSString *token = kUserDefaultObjectForKey(UserToken);
    if (token && token.length != 0) {
        [_manager.requestSerializer setValue:kUserDefaultObjectForKey(UserToken) forHTTPHeaderField:@"Authorization"];
    }
    NSString *phone = [FUserModel sharedUser].phone;
    if (phone && phone.length != 0) {
        [_manager.requestSerializer setValue:phone forHTTPHeaderField:@"phone"];
    }
    NSString *requestUrl = [self handleRequestUrl:url];
    return [_manager GET:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        __unused NSDictionary *data = responseObject[@"data"];
        [self handleNetworkResult:responseObject resultClass:resultClass success:success failure:failure];
        NSLog(@"\n\n-------------------------####################-------------------------\n\nRequestURL:%@\n-------------------------\nPostParams:%@\n-------------------------\nResponseString:%@\n-------------------------==========end===========-------------------------\n\n",task.currentRequest.URL,parameters,data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hanleHttpError:task];
        !failure ? : failure(error, nil);
        NSLog(@"\n\n-------------------------####################-------------------------\n\nRequestURL:%@\n-------------------------\nPostParams:%@\n-------------------------\nError:%@\n-------------------------==========end===========-------------------------\n\n",task.currentRequest.URL,parameters,error.description);
    }];
}

- (void) getRequestFromServer:(NSString *)url parameters:(id)parameters success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failur {
    NSString *requestUrl = [self handleRequestUrl:url];
    NSLog(@"getUrl:%@", requestUrl);
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:requestUrl parameters:parameters error:nil];
    request.timeoutInterval= 60;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mobile" forHTTPHeaderField:@"user-agent"];
    NSString *token = kUserDefaultObjectForKey(UserToken);
    if (token && token.length != 0) {
        [request setValue:kUserDefaultObjectForKey(UserToken) forHTTPHeaderField:@"Authorization"];
    }
    NSString *phone = [FUserModel sharedUser].phone;
    if (phone && phone.length != 0) {
        [request setValue:phone forHTTPHeaderField:@"phone"];
    }
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
    manager.responseSerializer = responseSerializer;
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response,id responseObject,NSError *error) {
        if(responseObject!=nil && !error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingAllowFragments
                                                           error:nil];
            NSMutableDictionary *response = [FDataTool nullDicToDic:dict];
            if (response[@"data"] && [response[@"data"] length] != 0) {
                NSString *str = [AESUtil aesDecrypt:response[@"data"] AndKey:NetAesKey];
                id data = [FDataTool dictionaryWithJsonString:str];
                response[@"data"] = data;
                if ([response[@"code"] integerValue] == 200 && [response[@"msg"] isEqualToString:@"操作成功"]) {
                    response[@"msg"] = @"";
                }
            }
            /// 当返回的code为406时，表示在其他地方登录了，需要退出重新登录
            if ([response[@"code"] integerValue] == 406) {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:nil];
            }else {
                success(response);
            }
            NSLog(@"\n\n-------------------------####################-------------------------\n\nRequestURL:%@\n-------------------------\nPostParams:%@\n-------------------------\nResponseString:%@\n-------------------------==========end===========-------------------------\n\n",request.URL,parameters,response);
        }
        if (failur && error) {
            failur(error);
            NSLog(@"\n\n-------------------------####################-------------------------\n\nRequestURL:%@\n-------------------------\nPostParams:%@\n-------------------------\nError:%@\n-------------------------==========end===========-------------------------\n\n",request.URL,parameters,error.description);
        }
        
    }]resume];
}

- (void )postRequestFromServer:(NSString *)url parameters:(id)parameters success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failur {
    NSDictionary *dict = [self handleParams:parameters];
    NSData *body = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *requestUrl = [self handleRequestUrl:url];
    NSLog(@"postUrl:%@", requestUrl);
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requestUrl parameters:nil error:nil];
    request.timeoutInterval= 60;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mobile" forHTTPHeaderField:@"user-agent"];
    NSString *token = kUserDefaultObjectForKey(UserToken);
    NSLog(@"token ==== :%@",token);
    if (token && token.length != 0) {
        [request setValue:kUserDefaultObjectForKey(UserToken) forHTTPHeaderField:@"Authorization"];
    }
    NSString *phone = [FUserModel sharedUser].phone;
    NSLog(@"phone ==== :%@",phone);
    if (phone && phone.length != 0) {
        [request setValue:phone forHTTPHeaderField:@"phone"];
    }
    [request setHTTPBody:body];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
    manager.responseSerializer = responseSerializer;
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response,id responseObject,NSError *error) {
        if(responseObject!=nil && !error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
            NSMutableDictionary *response = [FDataTool nullDicToDic:dict];
            if (response[@"data"] && [response[@"data"] length] != 0) {
                NSString *str = [AESUtil aesDecrypt:response[@"data"] AndKey:NetAesKey];
                id data = [FDataTool dictionaryWithJsonString:str];
                response[@"data"] = data;
                if ([response[@"code"] integerValue] == 200 && [response[@"msg"] isEqualToString:@"操作成功"]) {
                    response[@"msg"] = @"";
                }
            }
            /// 当返回的code为406时，表示在其他地方登录了，需要退出重新登录
            if ([response[@"code"] integerValue] == 406) {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:nil];
            }else if ([response[@"code"] integerValue] == 777) {
                [SVProgressHUD dismiss];
                SWRealNameViewController *vc = [[SWRealNameViewController alloc] init];
                [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
            }else {
                if ([response[@"code"] integerValue] != 200) {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
                success(response);
            }
            NSLog(@"\n\n-------------------------####################-------------------------\n\nRequestURL:%@\n-------------------------\nPostParams:%@\n-------------------------\nResponseString:%@\n-------------------------==========end===========-------------------------\n\n",request.URL,parameters,response);
        }
        if (failur && error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            failur(error);
            NSLog(@"\n\n-------------------------####################-------------------------\n\nRequestURL:%@\n-------------------------\nPostParams:%@\n-------------------------\nError:%@\n-------------------------==========end===========-------------------------\n\n",request.URL,parameters,error.description);
        }
    }]resume];
}

- (void )uploadImgFromServer:(NSString *)url image:(UIImage*)image parameters:(id)parameters  progress:(nullable void (^)(NSProgress * _Nonnull progress))progress success:(void(^)(NSDictionary *response))success failure:(void(^)(NSError *error))failur {
    NSDictionary *dict = [self handleParams:parameters];
    NSString *requestUrl = [self handleRequestUrl:url];
    NSLog(@"postUrl:%@", requestUrl);
    [_manager POST:requestUrl parameters:dict headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [FControlTool compressImage:image toByte:1024*200];
        [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"pic_%ld.jpg", (NSInteger)[[NSDate date] timeIntervalSince1970]] mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject!=nil) {
            NSMutableDictionary *response = [FDataTool nullDicToDic:responseObject];
            if (response[@"data"] && [response[@"data"] length] != 0) {
                NSString *str = [AESUtil aesDecrypt:response[@"data"] AndKey:NetAesKey];
                id data = [FDataTool dictionaryWithJsonString:str];
                response[@"data"] = data;
                if ([response[@"code"] integerValue] == 200 && [response[@"msg"] isEqualToString:@"操作成功"]) {
                    response[@"msg"] = @"";
                }
            }
            /// 当返回的code为406时，表示在其他地方登录了，需要退出重新登录
            if ([response[@"code"] integerValue] == 406) {
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:nil];
            }else if ([response[@"code"] integerValue] == 777) {
                [SVProgressHUD dismiss];
                SWRealNameViewController *vc = [[SWRealNameViewController alloc] init];
                [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
            }else {
                if ([response[@"code"] integerValue] != 200) {
                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
                }
                success(response);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failur && error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            failur(error);
        }
    }];
    
//    NSDictionary *dict = [self handleParams:parameters];
//    NSData *body = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *requestUrl = [self handleRequestUrl:url];
//    NSLog(@"postUrl:%@", requestUrl);
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requestUrl parameters:nil error:nil];
//    request.timeoutInterval= 60;
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"Mobile" forHTTPHeaderField:@"user-agent"];
//    NSString *token = kUserDefaultObjectForKey(UserToken);
//    if (token && token.length != 0) {
//        [request setValue:kUserDefaultObjectForKey(UserToken) forHTTPHeaderField:@"Authorization"];
//    }
//    NSString *phone = [FUserModel sharedUser].phone;
//    if (phone && phone.length != 0) {
//        [request setValue:phone forHTTPHeaderField:@"phone"];
//    }
//    [request setHTTPBody:body];
//    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
//    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
//    manager.responseSerializer = responseSerializer;
//    
//    [manager uploadTaskWithRequest:request fromData:UIImageJPEGRepresentation(image, 1.0) progress:^(NSProgress * _Nonnull uploadProgress) {
//        progress(uploadProgress);
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if(responseObject!=nil && !error) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
//                                                                 options:NSJSONReadingAllowFragments
//                                                                   error:nil];
//            NSMutableDictionary *response = [FDataTool nullDicToDic:dict];
//            if (response[@"data"] && [response[@"data"] length] != 0) {
//                NSString *str = [AESUtil aesDecrypt:response[@"data"] AndKey:NetAesKey];
//                id data = [FDataTool dictionaryWithJsonString:str];
//                response[@"data"] = data;
//                if ([response[@"code"] integerValue] == 200 && [response[@"msg"] isEqualToString:@"操作成功"]) {
//                    response[@"msg"] = @"";
//                }
//            }
//            /// 当返回的code为406时，表示在其他地方登录了，需要退出重新登录
//            if ([response[@"code"] integerValue] == 406) {
//                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
//                [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:nil];
//            }else {
//                if ([response[@"code"] integerValue] != 200) {
//                    [SVProgressHUD showErrorWithStatus:response[@"msg"]];
//                }
//                success(response);
//            }
//            NSLog(@"\n\n-------------------------####################-------------------------\n\nRequestURL:%@\n-------------------------\nPostParams:%@\n-------------------------\nResponseString:%@\n-------------------------==========end===========-------------------------\n\n",request.URL,parameters,response);
//        }
//        if (failur && error) {
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//            failur(error);
//            NSLog(@"\n\n-------------------------####################-------------------------\n\nRequestURL:%@\n-------------------------\nPostParams:%@\n-------------------------\nError:%@\n-------------------------==========end===========-------------------------\n\n",request.URL,parameters,error.description);
//        }
//    }];

}


- (void)cancelCurrentNetworkRequest:(NSURLSessionDataTask *)sessionDataTask {
    if (sessionDataTask.state == NSURLSessionTaskStateRunning) {
        [sessionDataTask cancel];
    }
}

- (NSDictionary *)handleParams:(NSDictionary*)params{
    NSString *jsonStr = [FDataTool convertToJsonData:params];
    NSString *aesStr = [AESUtil aesEncrypt:jsonStr AndKey:NetAesKey];
    NSDictionary *dict = @{@"param":aesStr};
    return dict;
}

- (NSString *)handleRequestUrl:(NSString*)url{
    return [NSString stringWithFormat:@"%@%@",BaseUrl,url];
}

#pragma mark - handle

- (void)handleNetworkResult:(NSDictionary *)responseObj resultClass:(id)resultClass success:(void (^)(id responseObject))success failure:(void (^)(NSError *error, _Nullable id object))failure {
    if (success) {
        NSNumber *codeObj = responseObj[@"code"];
        if (codeObj.intValue == 200) {
            if(![FDataTool isNull:responseObj[@"data"]] && [responseObj[@"data"] isKindOfClass:[NSDictionary class]]){
                NSDictionary *dict = responseObj[@"data"];
                NSMutableDictionary *dictWithMessage = [NSMutableDictionary dictionaryWithDictionary:dict];
                id result = [self handleResultData:dictWithMessage class:resultClass];
                success(result);
            }else{
                success([NSDictionary new]);
            }
            
        }else if (codeObj.intValue == 401) {
            
        } else{
            NSString *message = responseObj[@"msg"];
            if(message.length > 0){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [SVProgressHUD showErrorWithStatus:message];
                });
            }
            NSDictionary *dict = nil;
            if (![FDataTool isNull:responseObj[@"data"]]) {
                dict = responseObj[@"data"];
            }
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
            if(message.length == 0){
                userInfo = @{NSLocalizedDescriptionKey: @""};
            }
            NSError *error = [[NSError alloc] initWithDomain:@"com.request" code:codeObj.integerValue userInfo:userInfo];
            failure(error,dict);
        }
        
    }
}

- (void)hanleHttpError:(NSURLSessionTask *)task{
    NSString *errorStr = @"";
    if(task.error.localizedDescription.length == 0){
        errorStr = @"Network abnormality, please try again later.";
    }else if(task.error.code == -1001){
        errorStr = @"Network connection timed out";
    }else{
        errorStr = task.error.localizedDescription;
    }
//    [SVProgressHUD showErrorWithStatus:errorStr];
    
}

- (id)handleResultData:(NSDictionary *)dict class:(Class)resClass {
    if (resClass == nil || [resClass isKindOfClass:[NSDictionary class]]) {
        return dict;
    }else{
        return [resClass modelWithDictionary:dict];
    }
}


@end


