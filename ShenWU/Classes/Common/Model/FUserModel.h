//
//  FUserModel.h
//  Fiesta
//
//  Created by Amy on 2024/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FUserVipLevelType) {
    FUserVipLevelTypeNormal = 0,              /// 普通用户
    FUserVipLevelTypeOne,                     /// 1级用户
    FUserVipLevelTypeTwo,                     /// 2级用户
    FUserVipLevelTypeThree,                   /// 3级用户
    FUserVipLevelTypeFour,                    /// 4级用户
    FUserVipLevelTypeFive,                    /// 5级用户
    FUserVipLevelTypeSix,                     /// 6级用户
    FUserVipLevelTypeSeven,                   /// 7级用户
    FUserVipLevelTypeEight,                   /// 8级用户
    FUserVipLevelTypeNine,                    /// 9级用户
    FUserVipLevelTypeTen,                     /// 10级用户
    FUserVipLevelTypeEleven,                  /// 11级用户
    FUserVipLevelTypeTwelve,                  /// 12级用户
};

@interface FNormalUserModel : NSObject <NSCopying>

/// 手机号
@property (nonatomic, strong) NSString *phone;

/// 头像
@property (nonatomic, strong) NSString *headerIcon;

/// 昵称
@property (nonatomic, strong) NSString *nickName;

/// 用户ID
@property (nonatomic, strong) NSString *userID;

/// im token
@property (nonatomic, strong) NSString *imToken;

/// user token
@property (nonatomic, strong) NSString *token;

/// 用户的展示ID
@property (nonatomic, strong) NSString *memberCode;

/// 用户等级
@property (nonatomic, assign) FUserVipLevelType levelType;

/// 个性签名
@property (nonatomic, strong) NSString *signatureStr;

@property (nonatomic, assign) double balance;

@property (nonatomic, assign) BOOL hy;

@property (nonatomic, strong) NSString *verified;

@end

@interface FUserModel : FNormalUserModel
/// 正在使用的单例
+ (instancetype)sharedUser;

/// 聊天背景图片
@property (nonatomic, strong) NSString *backImage;

/// 全部声音通知 总开关 0 开 1 关
@property (nonatomic, assign) BOOL allDisturb;

/// 声音 0 开 1关
@property (nonatomic, assign) BOOL  sound;

/// 震动 0 开 1关
@property (nonatomic, assign) BOOL shake;

/// 用户是否已经使命认证
@property (nonatomic, assign) BOOL authentication;

/// 本人usdt地址
@property (nonatomic, strong) NSString *usdtStr;

/// 商户usdt地址
@property (nonatomic, strong) NSString *busUsdtStr;

/// 汇率
@property (nonatomic, strong) NSString *huiLvStr;

/// 获取本地储存的用户数组
- (NSArray *)getLocalSaveUserArray;

- (void)saveUserInfoWithPhone:(NSString *)phone NickName:(NSString *)username ImToken:(NSString *)imToken UserID:(NSString *)userID memberCode:(NSString *)memberCode AndUserToken:(NSString *)token avator:(NSString *)avator AndVipLevel:(NSString *)vipLevel AndAuthentication:(NSString *)authentication;

/// 删除本地信息
- (void)deletedLocalAccount;

- (void)deletedLocalAccountOnUser:(FNormalUserModel *)model;

- (void)saveUserInfo;

- (void)getBalance:(void(^)(double balance))success;
@end

NS_ASSUME_NONNULL_END
