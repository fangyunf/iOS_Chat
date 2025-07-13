//
//  AESUtil.h
//  UUTalk
//
//  Created by 0000 on 2023/5/22.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN

/// AES工具
@interface AESUtil : NSObject

/// aes加密
/// - Parameters:
///   - sourceStr: 加密字符串
///   - key: 加密钥匙
+ (NSString *)aesEncrypt:(NSString *)sourceStr AndKey:(NSString *)key;
 

/// aes解密
/// - Parameters:
///   - secretStr: 解密字符串
///   - key: 加密钥匙
+ (NSString *)aesDecrypt:(NSString *)secretStr AndKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
