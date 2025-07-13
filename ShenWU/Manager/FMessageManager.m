//
//  FMessageManager.m
//  Fiesta
//
//  Created by Amy on 2024/6/3.
//

#import "FMessageManager.h"
#import <AVFoundation/AVFoundation.h>
#import "ShenWU-Swift.h"
@interface FMessageManager ()< NIMSystemNotificationManagerDelegate, NIMConversationManagerDelegate, NIMChatManagerDelegate, NIMUserManagerDelegate, NIMTeamManagerDelegate, NIMLoginManagerDelegate>
@property(nonatomic, assign) BOOL isPlayingSound;
@end

@implementation FMessageManager
+ (instancetype)sharedManager{
    static FMessageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (void)initData{
    self.totalProgress = 10000.0;
    self.aideNewsUserId = [FUserModel sharedUser].userID;
    [[[NIMSDK sharedSDK] chatManager] addDelegate:self];
    [[[NIMSDK sharedSDK] userManager] addDelegate:self];
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
    [[[NIMSDK sharedSDK] conversationManager] addDelegate:self];
    [[[NIMSDK sharedSDK] teamManager] addDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [[[NIMSDK sharedSDK] mediaManager] setNeedProximityMonitor:YES];
    

}

- (void)dealloc {
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
    [[NIMSDK sharedSDK].teamManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshUnRead{
    [[NSNotificationCenter defaultCenter] postNotificationName:FRefreshUnReadCount object:nil];

    NIMSession *sysSession = [NIMSession session:[FUserModel sharedUser].userID type:NIMSessionTypeP2P];
    NIMRecentSession *sysRecent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:sysSession];
    
    NSArray *muteUserList = [[NIMSDK sharedSDK].userManager myMuteUserList];
    NSArray *teamList = [[NIMSDK sharedSDK].teamManager allMyTeams];
    
    NSInteger userUnreadNum = [[NIMSDK sharedSDK].conversationManager unreadCountOfType:NIMSessionTypeP2P]+self.groupNum+self.sysNotiNum;
    NSInteger teamUnreadNum = [[NIMSDK sharedSDK].conversationManager unreadCountOfType:NIMSessionTypeTeam]+sysRecent.unreadCount;
    for (NIMUser *user in muteUserList) {
        NIMSession *userSession = [NIMSession session:user.userId type:NIMSessionTypeP2P];
        NIMRecentSession *userRecent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:userSession];
        userUnreadNum -= userRecent.unreadCount;
    }
    
    for (NIMTeam *team in teamList) {
        if (team.notifyStateForNewMsg == NIMTeamNotifyStateNone) {
            NIMSession *teamSession = [NIMSession session:team.teamId type:NIMSessionTypeTeam];
            NIMRecentSession *teamRecent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:teamSession];
            teamUnreadNum -= teamRecent.unreadCount;
        }
    }
    
    [[self cyl_tabBarController].tabBar.items[0] cyl_showBadgeValue:[FDataTool getUnreadCount:userUnreadNum+teamUnreadNum] animationType:CYLBadgeAnimationTypeNone];
    
    [[self cyl_tabBarController].tabBar.items[1] cyl_showBadgeValue:[FDataTool getUnreadCount:self.friendNum] animationType:CYLBadgeAnimationTypeNone];
}


- (void)requestApplyListNum{
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/applyListNum" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            NSDictionary *dict = response[@"data"];
            weak_self.groupNum = [[dict objectForKey:@"groupApplyNum"] integerValue];
            weak_self.friendNum = [[dict objectForKey:@"friendApplyNum"] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak_self refreshUnRead];
            });
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)smashingEgg{
    NSInteger count = 1;
    if([FUserModel sharedUser].hy){
        count = 2;
    }
    if ([FMessageManager sharedManager].progress/[FMessageManager sharedManager].totalProgress*100 > 40 && [FMessageManager sharedManager].progress/[FMessageManager sharedManager].totalProgress*100 < 80) {
        count = count*0.1;
    }else if([FMessageManager sharedManager].progress/[FMessageManager sharedManager].totalProgress*100 > 80 && [FMessageManager sharedManager].progress/[FMessageManager sharedManager].totalProgress*100 < 90) {
        count = count*0.01;
    }else if([FMessageManager sharedManager].progress/[FMessageManager sharedManager].totalProgress*100 > 90 && [FMessageManager sharedManager].progress/[FMessageManager sharedManager].totalProgress*100 < 98) {
        count = count*0.001;
    }
    [FMessageManager sharedManager].progress = [FMessageManager sharedManager].progress+count;
}

- (void)getAideNewsAccount {
//    @weakify(self)
//    [[FNetworkManager sharedManager] postRequestFromServer:@"/aideNews/systemAppUser" parameters:@{} success:^(NSDictionary * _Nonnull response) {
//        if ([response[@"code"] integerValue] == 200) {
//            weak_self.aideNewsUserId = response[@"data"];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        
//    }];
}

- (void)getServiceAccount {
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:@"/customer/systemAppUser" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.serviceUserId = response[@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"serviceUserId" object:nil];
            [[FUserRelationManager sharedManager] reloadAllFriendsData:^(BOOL success) {
                [weak_self addCustonSevirce:weak_self.serviceUserId];
            }];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NIMSession *session = [NIMSession session:weak_self.serviceUserId type:NIMSessionTypeP2P];
//                [[NIMSDK sharedSDK].conversationManager addEmptyRecentSessionBySession:session];
//                [[FUserRelationManager sharedManager] reloadAllFriendsData:nil];
//            });
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)addCustonSevirce:(NSString*)userId{
    if (![FDataTool isNull:[FUserRelationManager sharedManager].allFriendDict[userId]]) {
        return;
    }
    if([userId isEqualToString:[FMessageManager sharedManager].serviceUserId]){
        [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/searchByUserIdF" parameters:@{@"userId":userId} success:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue] == 200) {
                FFriendModel *model = [FFriendModel modelWithDictionary:response[@"data"]];
                NSDictionary *params = @{@"memberCode":model.memberCode,@"remark":@"客服",@"msg":@""};
                [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/addFriends" parameters:params success:^(NSDictionary * _Nonnull response) {
                    if ([response[@"code"] integerValue] == 200) {
                        
                    }else{
                        
                    }
                    
                } failure:^(NSError * _Nonnull error) {
                    
                }];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}


- (void)sendTipMessage:(NSString*)content sessionId:(NSString*)sessionId type:(NSInteger)type{
    NIMSession *session  = nil;
    if (type == 1) {
        session  = [NIMSession session:sessionId type:NIMSessionTypeP2P];
    }else{
        session  = [NIMSession session:sessionId type:NIMSessionTypeTeam];
    }
    // 获得文件附件对象
    NIMTipObject *object = [[NIMTipObject alloc] init];
    // 构造出具体消息并注入附件
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = object;
    message.text = content;
    // 错误反馈对象
    NSError *error = nil;
    // 发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
}

- (void)sendUserCardWithSessionId:(NSString*)sessionId model:(FFriendModel*)model type:(NSInteger)type{
    NIMSession *session  = nil;
    if (type == 1) {
        session  = [NIMSession session:sessionId type:NIMSessionTypeP2P];
    }else{
        session  = [NIMSession session:sessionId type:NIMSessionTypeTeam];
    }

    // 构造自定义消息附件
    NIMCustomObject *object = [[NIMCustomObject alloc] init];
    FUserCardMessageModel *attachment = [[FUserCardMessageModel alloc] init];
    attachment.customType = 10086;
    attachment.avatar = model.avatar;
    attachment.memberCode = model.memberCode;
    attachment.name = model.name;
    object.attachment = attachment;

    // 构造出具体消息并注入附件
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = object;

    // 错误反馈对象
    NSError *error = nil;

    // 发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
}

#pragma mark - NIMLoginManagerDelegate
- (void)onKickout:(NIMLoginKickoutResult *)result {
    [SVProgressHUD showErrorWithStatus:@"您的账号在其他地方登陆"];
    [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:nil];
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification {
    /// 收到自定义通知回掉，后期可能有用
    NSString *json = notification.content;
    NSLog(@"json == :%@",json);
    NSDictionary *dict = [FDataTool dictionaryWithJsonString:json];
    NSLog(@"onReceiveCustomSystemNotification == :%@",dict);
    if ([dict[@"type"] integerValue] == 1) {
        /// 群申请数量
        self.groupNum = [dict[@"num"] integerValue];
        [self refreshUnRead];
    }else if ([dict[@"type"] integerValue] == 6) {
        /// 好友申请数量
        self.friendNum = [dict[@"num"] integerValue];
        [self refreshUnRead];
    }else if ([dict[@"type"] integerValue] == 2) {
        /// 删除好友通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UUTalkDeletedFriendsNotificationName" object:nil userInfo:dict];
        /// 删除好友通知
//        NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%@", dict[@"userId"]] type:NIMSessionTypeP2P];
//        NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
//        // 异步接口，删除某个会话 & 设置
//        NIMDeleteRecentSessionOption *option = [[NIMDeleteRecentSessionOption alloc] init];
//        // 是否删除漫游信息
//        option.isDeleteRoamMessage = YES;
//        // 删除某个最近会话 回调
//        NIMRemoveRemoteSessionBlock block = ^(NSError * __nullable error)
//        {
//            if (error == nil){
//                // 删除某个最近会话 成功
//                [[NSNotificationCenter defaultCenter] postNotificationName:FRefreshFriendList object:nil];
//            }else{
//                // 删除某个最近会话 失败
//                NSLog(@"[NSError with: %@] ", error);
//            }
//        };
//        // 删除某个最近会话
//        [[[NIMSDK sharedSDK] conversationManager] deleteRecentSession:recent
//                                                               option:option
//                                                           completion:block];
        [[FUserRelationManager sharedManager] reloadAllFriendsData:nil];
    }else if ([dict[@"type"] integerValue] == 15) {
        /// 添加好友
        [[FUserRelationManager sharedManager] reloadAllFriendsData:nil];
    }else if ([dict[@"type"] integerValue] == 16) {
        /// 滚屏
        NSLog(@"%@", dict);
        [[NSNotificationCenter defaultCenter] postNotificationName:FTopInfoChange object:nil userInfo:dict];
    }else if ([dict[@"type"] integerValue] == 7 || [dict[@"type"] integerValue] == 8 || [dict[@"type"] integerValue] == 9 || [dict[@"type"] integerValue] == 10 || [dict[@"type"] integerValue] == 11) {
        /// 群聊发生改变
        [[FUserRelationManager sharedManager] reloadAllGroupsData:nil];
    }else if ([dict[@"type"] integerValue] == 107) {
        NSString *content = dict[@"msg"];
//         FNotiAlertView *view = [[FNotiAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) content:content];
//         [[FControlTool keyWindow] addSubview:view];
    }else if ([dict[@"type"] integerValue] == 7788) {
        self.aideNewsIsUnread = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:FAideNewsIsUnread object:nil userInfo:dict];
    }else if ([dict[@"type"] integerValue] == 525) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CrackOpenEgg object:dict];
    }else if ([dict[@"type"] integerValue] == 526) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GiveOutEggs object:nil];
    }else if ([dict[@"type"] integerValue] == 18) {
        NSString *content = dict[@"msg"];
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshBalance object:nil];
        [SVProgressHUD showInfoWithStatus:content];
    }else if ([dict[@"type"] integerValue] == 19) {
        NSLog(@"用户禁用通知");
        NSString *content = dict[@"msg"];
        [SVProgressHUD showInfoWithStatus:content];
        [[NSNotificationCenter defaultCenter] postNotificationName:FLoginOut object:nil];
    }
}

- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification {
    /// 收到系统消息回掉，后期可能有用
}

- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount {
    [self refreshUnRead];
}

#pragma mark - NIMConversationManagerDelegate
- (void)didUpdateUnreadCountDic:(NSDictionary *)unreadCountDic {
    [self refreshUnRead];
}

- (void)onMarkMessageReadCompleteInSession:(NIMSession *)session error:(nullable NSError *)error {
    [self refreshUnRead];
}

#pragma mark - NIMChatManagerDelegate
/// 收到消息回掉
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
//    BOOL isNotification = [FUserModel sharedUser].allDisturb;
//    if (isNotification) {
        /// 判断该消息是否在免打扰里面，如果是，则没有通知
        BOOL need = NO;
        for (NIMMessage *message in messages) {
            NSString *sessionId = message.session.sessionId;
            if (message.session.sessionType == NIMSessionTypeP2P) {
                need = [[NIMSDK sharedSDK].userManager notifyForNewMsg:sessionId];
            }else if (message.session.sessionType == NIMSessionTypeTeam) {
                NIMTeamNotifyState notifyState = [[[NIMSDK sharedSDK] teamManager] notifyStateForNewMsg:sessionId];
                if (notifyState == NIMTeamNotifyStateAll) {
                    need = YES;
                }
            }
            if (need) {
                break;
            }
        }
        if (!need) {
            return;
        }
        
        BOOL sound = ![FUserModel sharedUser].sound;
        BOOL shake = ![FUserModel sharedUser].shake;
        if(self.isPlayingSound == false && sound){
            self.isPlayingSound = true;
            // 创建一个新的系统声音标识符
            SystemSoundID customSoundID = 0;
            // 音频文件的 URL
            NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"msg" withExtension:@"wav"];
            // 创建系统声音标识符
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &customSoundID);
            // 播放自定义声音
            AudioServicesPlaySystemSoundWithCompletion(customSoundID, ^{
                self.isPlayingSound = false;
            });
        }
        if (shake) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
//    }
}

#pragma mark - NIMUserManagerDelegate
- (void)onFriendChanged:(NIMUser *)user {
    NSLog(@"%@", user);
    BOOL isFriend = [[NIMSDK sharedSDK].userManager isMyFriend:user.userId];
    if (isFriend) {
        /// 刷新
        [[FUserRelationManager sharedManager] reloadAllFriendsData:nil];
    }else {
//        /// 删除聊天界面
//        NIMSession *session = [NIMSession session:user.userId type:NIMSessionTypeP2P];
//        NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
//        // 异步接口，删除某个会话 & 设置
//        NIMDeleteRecentSessionOption *option = [[NIMDeleteRecentSessionOption alloc] init];
//        // 是否删除漫游信息
//        option.isDeleteRoamMessage = YES;
//        // 删除某个最近会话 回调
//        NIMRemoveRemoteSessionBlock block = ^(NSError * __nullable error)
//        {
//            if (error == nil){
//                // 删除某个最近会话 成功
//                NSLog(@"[Delete recent session. Session name: %@]", recent.session.sessionId);
//                [[FUserRelationManager sharedManager] reloadAllFriendsData:nil];
//            }else{
//                // 删除某个最近会话 失败
//                NSLog(@"[NSError with: %@] ", error);
//                [[FUserRelationManager sharedManager] reloadAllFriendsData:nil];
//            }
//        };
//        // 删除某个最近会话
//        [[[NIMSDK sharedSDK] conversationManager] deleteRecentSession:recent
//                                                               option:option
//                                                           completion:block];
    }
}

#pragma mark - NIMTeamManagerDelegate
- (void)onTeamAdded:(NIMTeam *)team {
    [[FUserRelationManager sharedManager] reloadAllGroupsData:nil];
}

- (void)onTeamRemoved:(NIMTeam *)team {
    [[FUserRelationManager sharedManager] reloadAllGroupsData:nil];
}

@end
