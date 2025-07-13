//
//  SWSelectUserViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/24.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SelectFriendTypeCommon,
    SelectFriendTypeRedPacket,
    SelectFriendTypeGroupAdd,
    SelectFriendTypeGroupDelete,
    SelectFriendTypeProhibit,
} SelectFriendType;

@protocol SWSelectUserViewControllerDelegate <NSObject>
@optional
- (void)reloadGroupMember;

- (void)selectUser:(FGroupUserInfoModel*)model;

@end

@interface SWSelectUserViewController : FBaseViewController
@property(nonatomic, weak) id<SWSelectUserViewControllerDelegate> delegate;
@property(nonatomic, assign) SelectFriendType type;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) FFriendModel *userModel;
@property(nonatomic, strong) FGroupModel *groupModel;
@property(nonatomic, strong) NSArray *selectData;
@end

NS_ASSUME_NONNULL_END
