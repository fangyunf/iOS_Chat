//
//  SWGroupMemberViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/27.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    GroupMemberTypeLook,
    GroupMemberTypeSelectHost,
    GroupMemberTypeSelectManage,
} GroupMemberType;

@interface SWGroupMemberViewController : FBaseViewController
@property(nonatomic, assign) GroupMemberType type;
@property(nonatomic, strong) FGroupModel *model;
@property (nonatomic, copy) void (^reloadBlock)(void);
@end

NS_ASSUME_NONNULL_END
