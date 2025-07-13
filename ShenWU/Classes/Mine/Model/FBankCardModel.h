//
//  FBankCardModel.h
//  Fiesta
//
//  Created by Amy on 2024/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBankCardModel : NSObject
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *bankCardNo;
@property(nonatomic, strong) NSString *certNo;
@property(nonatomic, strong) NSString *bankName;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString *cardId;

@property(nonatomic, strong) NSString *orderCode;
@property(nonatomic, strong) NSString *tokenNo;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *zfb;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *usdt;
@end

NS_ASSUME_NONNULL_END
