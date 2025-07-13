//
//  FApplyGroupModel.h
//  Fiesta
//
//  Created by Amy on 2024/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FApplyGroupModel : NSObject
@property(nonatomic, strong) NSString *applyId;
@property(nonatomic, strong) NSString *userAvatar;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *userMemberCode;
@property(nonatomic, strong) NSString *groupName;
@property(nonatomic, assign) NSInteger applyState;
@property(nonatomic, strong) NSString *inviteName;
@end

@interface FApplyGroupListModel : NSObject
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, assign) NSInteger pages;
@property(nonatomic, strong) NSArray<FApplyGroupModel*> *data;
@end

NS_ASSUME_NONNULL_END
