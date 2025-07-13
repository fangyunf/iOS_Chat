//
//  FYSendRedPacketViewController.h
//  ShenWU
//
//  Created by Amy on 2025/2/19.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYSendRedPacketViewController : FBaseViewController
@property(nonatomic, strong) FGroupModel *groupModel;
- (void)selectUser:(FGroupUserInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
