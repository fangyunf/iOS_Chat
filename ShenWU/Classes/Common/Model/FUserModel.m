//
//  FUserModel.m
//  Fiesta
//
//  Created by Amy on 2024/6/6.
//

#import "FUserModel.h"

@interface FUserModel ()

@property (nonatomic, strong) NSMutableArray *localUserArr;

@end

@implementation FUserModel

#pragma mark - 单例
static FUserModel *sharedManager;
+ (instancetype)sharedUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[FUserModel alloc] init];
    });
    return sharedManager;
}

#pragma mark - Method
- (void)saveUserInfoWithPhone:(NSString *)phone NickName:(NSString *)username ImToken:(NSString *)imToken UserID:(NSString *)userID memberCode:(NSString *)memberCode AndUserToken:(NSString *)token avator:(NSString *)avator AndVipLevel:(NSString *)vipLevel AndAuthentication:(NSString *)authentication {
    self.phone = phone;
    self.nickName = username;
    self.imToken = imToken;
    self.memberCode = [NSString stringWithFormat:@"%@", memberCode];
    self.userID = [NSString stringWithFormat:@"%ld", [userID integerValue]];
    self.token = token;
    self.headerIcon = avator;
    self.levelType = [vipLevel intValue];
    kUserDefaultSetObjectForKey(token, UserToken);
    for (FNormalUserModel *model in self.localUserArr) {
        if ([model.userID isEqualToString:self.userID]) {
            NSLog(@"已有账号");
            [self.localUserArr removeObject:model];
            break;
        }
    }
    FNormalUserModel *normalModel = [self copy];
    [self.localUserArr addObject:normalModel];
    [NSKeyedArchiver archiveRootObject:self.localUserArr toFile:[self localUserArrayFile]];
}

- (void)saveUserInfo{
    for (FNormalUserModel *model in self.localUserArr) {
        if ([model.userID isEqualToString:self.userID]) {
            NSLog(@"已有账号");
            [self.localUserArr removeObject:model];
            break;
        }
    }
    FNormalUserModel *normalModel = [self copy];
    [self.localUserArr addObject:normalModel];
    [NSKeyedArchiver archiveRootObject:self.localUserArr toFile:[self localUserArrayFile]];
}

- (NSArray *)getLocalSaveUserArray {
    return self.localUserArr;
}

- (void)deletedLocalAccount {
    FNormalUserModel *normalModel;
    for (FNormalUserModel *model in self.localUserArr) {
        if ([self.userID isEqualToString:model.userID]) {
            normalModel = model;
            break;
        }
    }
    if (normalModel) {
        [self.localUserArr removeObject:normalModel];
    }
    [NSKeyedArchiver archiveRootObject:self.localUserArr toFile:[self localUserArrayFile]];
}

- (void)deletedLocalAccountOnUser:(FNormalUserModel *)model {
    FNormalUserModel *normalModel;
    for (FNormalUserModel *localModel in self.localUserArr) {
        if ([model.userID isEqualToString:localModel.userID]) {
            normalModel = localModel;
            break;
        }
    }
    if (normalModel) {
        [self.localUserArr removeObject:normalModel];
    }
    [NSKeyedArchiver archiveRootObject:self.localUserArr toFile:[self localUserArrayFile]];
}

- (void)getBalance:(void(^)(double balance))success{
    @weakify(self)
    [[FNetworkManager sharedManager] getRequestFromServer:@"/home/balance" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.balance = [response[@"data"][@"balance"] integerValue]/100.0;
            if (success) {
                success(weak_self.balance);
            }
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Private Action
- (NSString *)localUserArrayFile {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES).firstObject stringByAppendingString:@"/user.plist"];
}

#pragma mark - lazy loading
- (NSMutableArray *)localUserArr {
    if (!_localUserArr) {
        _localUserArr = [NSKeyedUnarchiver unarchiveObjectWithFile:[self localUserArrayFile]];
        if (!_localUserArr) {
            _localUserArr = [[NSMutableArray alloc] init];
        }
    }
    return _localUserArr;
}

@end


@implementation FNormalUserModel

static NSString *normalAesKey = @"UUTalkUserModelKEY";

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSString *phone = [AESUtil aesEncrypt:self.phone AndKey:normalAesKey];
    NSString *userID = [AESUtil aesEncrypt:self.userID AndKey:normalAesKey];
    NSString *imToken = [AESUtil aesEncrypt:self.imToken AndKey:normalAesKey];
    NSString *token = [AESUtil aesEncrypt:self.token AndKey:normalAesKey];
    [aCoder encodeObject:phone forKey:@"phone"];
    [aCoder encodeObject:self.headerIcon forKey:@"headerIcon"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:userID forKey:@"userID"];
    [aCoder encodeObject:imToken forKey:@"imToken"];
    [aCoder encodeObject:token forKey:@"token"];
    [aCoder encodeObject:@(self.levelType) forKey:@"levelType"];
    [aCoder encodeObject:self.memberCode forKey:@"memberCode"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        NSString *phone = [aDecoder decodeObjectForKey:@"phone"];
        NSString *userID = [aDecoder decodeObjectForKey:@"userID"];
        NSString *imToken = [aDecoder decodeObjectForKey:@"imToken"];
        NSString *token = [aDecoder decodeObjectForKey:@"token"];
        
        self.phone = [AESUtil aesDecrypt:phone AndKey:normalAesKey];
        self.headerIcon = [aDecoder decodeObjectForKey:@"headerIcon"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.userID = [AESUtil aesDecrypt:userID AndKey:normalAesKey];
        self.imToken = [AESUtil aesDecrypt:imToken AndKey:normalAesKey];
        self.token = [AESUtil aesDecrypt:token AndKey:normalAesKey];
        self.levelType = [[aDecoder decodeObjectForKey:@"levelType"] integerValue];
        self.memberCode = [aDecoder decodeObjectForKey:@"memberCode"];
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    FNormalUserModel *model = [[FNormalUserModel allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:value forKey:propertyName];
        }
    }
    free(properties);
    return model;
}

@end

