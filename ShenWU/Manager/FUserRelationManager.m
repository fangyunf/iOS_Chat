//
//  FUserRelationManager.m
//  Fiesta
//
//  Created by Amy on 2024/6/6.
//

#import "FUserRelationManager.h"
#import "SWFriendInfoViewController.h"
#import "SWAddFriendViewController.h"
@implementation FUserRelationManager
+ (instancetype)sharedManager{
    static FUserRelationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (void)reloadAllFriendsData:(void (^)(BOOL success))block {
    self.blackList = [[NIMSDK sharedSDK].userManager myBlackList];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/friendList" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                [self.allFriends removeAllObjects];
                [self.allFriendDict removeAllObjects];
                for (NSDictionary *data in response[@"data"]) {
                    FFriendModel *model = [FFriendModel modelWithDictionary:data];
                    if (![[NIMSDK sharedSDK].userManager isUserInBlackList:model.userId]) {
                        if (![model.userId isEqualToString:[FMessageManager sharedManager].serviceUserId]) {
                            [self.allFriends addObject:model];
                        }
                    }
//                    NSLog(@"model.memberCode == :%@",model.memberCode);
                    [self.allFriendDict setValue:model forKey:model.userId];
                }
            }
            if (block) {
                block(YES);
            }
            self.isChange = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:FRefreshFriendList object:nil];
        }else {
            if (block) {
                block(NO);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (block) {
            block(NO);
        }
    }];
}

- (void)reloadAllGroupsData:(void (^)(BOOL success))block {
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/userGroups" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                [self.allGroups removeAllObjects];
                [self.allGroupsDict removeAllObjects];
                for (NSDictionary *data in response[@"data"]) {
                    FGroupModel *model = [FGroupModel modelWithDictionary:data];
                    [self.allGroups addObject:model];
                    [self.allGroupsDict setValue:model forKey:model.groupId];
                }
            }
            if (block) {
                block(YES);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:FRefreshFriendList object:nil];
        }else {
            if (block) {
                block(NO);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if (block) {
            block(NO);
        }
    }];
}

- (void)updateFriendRemark:(NSString*)userId remark:(NSString*)remark{
    for (FFriendModel *model in self.allFriends) {
        if ([model.userId isEqualToString:userId]) {
            model.remark = remark;
            break;
        }
    }
}

- (void)clickGroupMember:(FGroupUserInfoModel*)userInfoModel group:(FGroupModel*)group delegate:(id<SWGroupMemberInfoViewControllerDelegate>)delegate{
    GroupClickMemberType clickType = GroupClickMemberTypeNormalFriend;
    BOOL isFriend = NO;
    for (FFriendModel *model in self.allFriends) {
        if ([model.userId isEqualToString:userInfoModel.userId]) {
            isFriend = YES;
            userInfoModel.remark = model.remark;
            break;
        }
    }
    if ((group.rankState == 1 || group.rankState == 2) && isFriend) {
        clickType = GroupClickMemberTypeHostFriend;
    }else if ((group.rankState == 1 || group.rankState == 2) && !isFriend) {
        clickType = GroupClickMemberTypeHost;
    }else if(isFriend){
        clickType = GroupClickMemberTypeNormalFriend;
    }else{
        clickType = GroupClickMemberTypeNormal;
    }
    
    SWGroupMemberInfoViewController *vc = [[SWGroupMemberInfoViewController alloc] init];
    vc.type = clickType;
    vc.groupModel = group;
    vc.userInfoModel = userInfoModel;
    vc.delegate = delegate;
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)jumpToUserCardInfo:(NSString*)memberCode {
    NSDictionary *params = @{@"phoneAndCode":memberCode,@"type":@0};
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/search" parameters:params success:^(NSDictionary * _Nonnull response) {
        NSLog(@"response == :%@",response);
        if ([response[@"code"] integerValue] == 200) {
            NSDictionary *dict = response[@"data"];
            FFriendModel *model = [FFriendModel modelWithDictionary:dict];
            if ([[NIMSDK sharedSDK].userManager isMyFriend:model.userId]) {
                SWFriendInfoViewController *vc = [[SWFriendInfoViewController alloc] init];
                vc.user = model;
                [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
            }else{
                SWAddFriendViewController *vc = [[SWAddFriendViewController alloc] init];
                vc.model = model;
                [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
            }
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - lazy loading
- (NSMutableArray<FFriendModel *> *)allFriends {
    if (!_allFriends) {
        _allFriends = [[NSMutableArray alloc] initWithCapacity:999];
    }
    return _allFriends;
}

- (NSMutableDictionary *)allFriendDict{
    if (!_allFriendDict) {
        _allFriendDict = [[NSMutableDictionary alloc] init];
    }
    return _allFriendDict;
}

- (NSMutableArray<FGroupModel *> *)allGroups{
    if (!_allGroups) {
        _allGroups = [[NSMutableArray alloc] initWithCapacity:999];
    }
    return _allGroups;
}

- (NSDictionary *)allGroupsDict{
    if (!_allGroupsDict) {
        _allGroupsDict = [[NSMutableDictionary alloc] init];
    }
    return _allGroupsDict;
}

@end
