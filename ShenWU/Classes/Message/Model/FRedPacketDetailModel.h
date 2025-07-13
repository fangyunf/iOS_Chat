//
//  FRedPacketDetailModel.h
//  Fiesta
//
//  Created by Amy on 2024/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FRedPacketUserModel : NSObject
@property(nonatomic, assign) NSInteger amount;
@property(nonatomic, assign) BOOL isFirstGood;
@property(nonatomic, assign) NSInteger level;
@property(nonatomic, assign) NSInteger reciveAmount;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *remark;
@property(nonatomic, strong) NSString *reciveTime;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString *redpacketId;
@property(nonatomic, strong) NSString *detailId;
@property(nonatomic, strong) NSString *createTime;
@end

@interface FRedPacketDetailModel : NSObject
@property(nonatomic, strong) NSString *redPacketId;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, assign) NSInteger sendAmount;
@property(nonatomic, assign) NSInteger totalNum;
@property(nonatomic, assign) NSInteger reciveAmount;
@property(nonatomic, strong) NSString *lootAll;
@property(nonatomic, strong) NSString *sendAvatar;
@property(nonatomic, strong) NSString *sendName;
@property(nonatomic, strong) NSArray<FRedPacketUserModel*> *vos;
@property(nonatomic, assign) NSInteger sendLevel;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) NSInteger redpacketType;
@property(nonatomic, strong) NSString *groupId;
@property(nonatomic, strong) NSString *sendId;
@property(nonatomic, strong) NSString *sendTime;
@end

NS_ASSUME_NONNULL_END
