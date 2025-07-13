//
//  FUserRelationManager.h
//  Fiesta
//
//  Created by Amy on 2024/6/6.
//

#import <Foundation/Foundation.h>
#import "FFriendModel.h"
#import "FGroupModel.h"
#import "SWGroupMemberInfoViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface FUserRelationManager : NSObject
@property(nonatomic, strong) NSMutableArray<FFriendModel*> *allFriends;
@property(nonatomic, strong) NSMutableDictionary *allFriendDict;
@property(nonatomic, strong) NSArray *blackList;
@property(nonatomic, strong) NSMutableArray<FGroupModel*> *allGroups;
@property(nonatomic, strong) NSMutableDictionary *allGroupsDict;
/// 是否发生改变，用于通讯录监听变化
@property (nonatomic, assign) BOOL isChange;
+ (instancetype)sharedManager;
- (void)reloadAllFriendsData:( void (^ _Nullable )(BOOL success))block;
- (void)reloadAllGroupsData:(void (^ _Nullable )(BOOL success))block;
- (void)clickGroupMember:(FGroupUserInfoModel*)userInfoModel group:(FGroupModel*)group delegate:(id<SWGroupMemberInfoViewControllerDelegate>)delegate;
- (void)updateFriendRemark:(NSString*)userId remark:(NSString*)remark;
- (void)jumpToUserCardInfo:(NSString*)memberCode;
@end

NS_ASSUME_NONNULL_END
