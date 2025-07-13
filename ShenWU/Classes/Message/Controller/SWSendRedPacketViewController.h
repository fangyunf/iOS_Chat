//
//  SWSendRedPacketViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/28.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RedPacketTypePerson,
    RedPacketTypeZhuazhang,
    RedPacketTypeSingle,
    RedPacketTypeLucky,
} RedPacketType;

@interface SWSendRedPacketViewController : FBaseViewController
@property(nonatomic, assign) RedPacketType redType;
@property(nonatomic, strong) FFriendModel *model;
@property(nonatomic, strong) FGroupModel *groupModel;
- (void)selectUser:(FGroupUserInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
