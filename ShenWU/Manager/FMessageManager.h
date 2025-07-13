//
//  FMessageManager.h
//  Fiesta
//
//  Created by Amy on 2024/6/3.
//

#import <Foundation/Foundation.h>
#import "FFriendModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FMessageManager : NSObject
@property(nonatomic, assign) NSInteger groupNum;
@property(nonatomic, assign) NSInteger friendNum;
@property(nonatomic, assign) NSInteger sysNotiNum;
@property(nonatomic, strong) NSString *serviceUserId;
@property(nonatomic, strong) NSString *aideNewsUserId;
@property(nonatomic, assign) BOOL aideNewsIsUnread;

@property(nonatomic, assign) CGFloat progress;
@property(nonatomic, assign) CGFloat totalProgress;
+ (instancetype)sharedManager;
- (void)initData;
- (void)requestApplyListNum;
- (void)refreshUnRead;
- (void)getAideNewsAccount;
- (void)getServiceAccount;
- (void)smashingEgg;
- (void)sendTipMessage:(NSString*)content sessionId:(NSString*)sessionId type:(NSInteger)type;
- (void)sendUserCardWithSessionId:(NSString*)sessionId model:(FFriendModel*)model type:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
