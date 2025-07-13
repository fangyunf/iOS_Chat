//
//  FGroupModel.h
//  Fiesta
//
//  Created by Amy on 2024/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FGroupUserInfoModel : NSObject
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, assign) BOOL forbidState;
@property(nonatomic, strong) NSString *inviteMemberCode;
@property(nonatomic, strong) NSString *inviteName;
@property(nonatomic, strong) NSString *memberCode;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) NSInteger rankState;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *userGroupName;
@property(nonatomic, strong) NSString *remark;
@property(nonatomic, assign) NSInteger grade;
@property(nonatomic, assign) BOOL isSelected;
@end

@interface FGroupModel : NSObject
@property(nonatomic, strong) NSString *groupId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *head;
@property(nonatomic, strong) NSString *announcement;
@property(nonatomic, assign) NSInteger noDisturbingState;
@property(nonatomic, assign) NSInteger topState;
@property(nonatomic, assign) NSInteger rankState;
@property(nonatomic, strong) NSString *userGroupName;
@property(nonatomic, assign) BOOL inviteState;
@property(nonatomic, assign) BOOL addFriendsState;
@property(nonatomic, assign) BOOL shutupState;
@property(nonatomic, assign) BOOL nonCollectionState;
@property(nonatomic, strong) NSArray<FGroupUserInfoModel*> *members;
@end

NS_ASSUME_NONNULL_END
