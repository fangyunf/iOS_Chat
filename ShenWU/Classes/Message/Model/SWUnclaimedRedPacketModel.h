//
//  SWUnclaimedRedPacketModel.h
//  ShenWU
//
//  Created by Amy on 2025/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWUnclaimedRedPacketModel : NSObject
@property(nonatomic, strong) NSString *redPacketId;
@property(nonatomic, assign) NSInteger amount;
@property(nonatomic, assign) NSInteger backAmount;
@property(nonatomic, strong) NSString *appointUserId;
@property(nonatomic, strong) NSString *createTime;
@property(nonatomic, strong) NSString *groupId;
@property(nonatomic, assign) NSInteger num;
@property(nonatomic, assign) NSInteger packetType;
@property(nonatomic, strong) NSString *sendUserId;
@property(nonatomic, strong) NSString *shardingDate;
@property(nonatomic, strong) NSString *skinUrl;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *traceId;
@property(nonatomic, assign) NSInteger type;//type == 21 专属 || type == 22 个人 || type == 23 群 || type == 28 转账
@end

NS_ASSUME_NONNULL_END
