//
//  SWGroupMemberInfoViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/27.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    GroupClickMemberTypeHost,
    GroupClickMemberTypeHostFriend,
    GroupClickMemberTypeNormal,
    GroupClickMemberTypeNormalFriend,
} GroupClickMemberType;

@protocol SWGroupMemberInfoViewControllerDelegate <NSObject>

- (void)reloadGroupMember;

@end

@interface SWGroupMemberInfoViewController : FBaseViewController
@property(nonatomic, weak) id<SWGroupMemberInfoViewControllerDelegate> delegate;
@property(nonatomic, assign) GroupClickMemberType type;
@property(nonatomic, strong) FGroupUserInfoModel *userInfoModel;
@property(nonatomic, strong) FGroupModel *groupModel;
@end

NS_ASSUME_NONNULL_END
