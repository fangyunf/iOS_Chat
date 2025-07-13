//
//  POtherPhoneModel.h
//  ShenWU
//
//  Created by Amy on 2024/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface POtherPhoneModel : NSObject
@property(nonatomic, strong) NSString *amount;
@property(nonatomic, strong) NSString *createTime;
@property(nonatomic, strong) NSString *phoneFix;
@property(nonatomic, assign) NSInteger userId;
@property(nonatomic, strong) NSString *phoneId;
@end

NS_ASSUME_NONNULL_END
