//
//  SWMessageDetaillViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWMessageDetaillViewController.h"
#import "ShenWU-Swift.h"
#import "SWGroupInfoViewController.h"
#import "SWFriendInfoViewController.h"
#import "SWSendRedPacketViewController.h"
#import "SWAnnouncementScrollView.h"
#import "FMyCollectViewController.h"
#import "SWSelectUserViewController.h"
#import "TKSmashingEggshellView.h"
#import "TKEggListModel.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "FYSendRedPacketViewController.h"
#import "SWAddFriendViewController.h"
@interface SWMessageDetaillViewController ()<FMessageP2PDelegate,FMessageTeamDelegate,SWGroupMemberInfoViewControllerDelegate>
@property(nonatomic, strong) FMessageP2PViewController *p2pChatVc;
@property(nonatomic, strong) FMessageTeamViewController *teamChatVc;
@property(nonatomic, strong) FFriendModel *model;
@property(nonatomic, strong) SWAnnouncementScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *groupMembers;
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) BOOL isRequesting;
@property(nonatomic, strong) TKSmashingEggshellView *eggShellView;
@property(nonatomic, strong) NSArray *eggList;
@end


@implementation SWMessageDetaillViewController

- (void)dealloc{
    NSLog(@"FMessageDetailViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.p2pChatVc.delegate = nil;
    [self.p2pChatVc removeFromParentViewController];
    self.p2pChatVc = nil;
    self.teamChatVc.delegate = nil;
    [self.teamChatVc removeFromParentViewController];
    self.teamChatVc = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    if (self.type != NIMSessionTypeP2P) {
        if (self.groupModel) {
            [self.teamChatVc setGroupMessageNameWithName:[NSString stringWithFormat:@"%@(%ld)",self.groupModel.name,self.groupMembers.count]];
        }
        [self.teamChatVc setMemberListWithList:self.groupMembers];
    }else if([[FMessageManager sharedManager].serviceUserId isEqualToString:self.sessionId]){
        @weakify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak_self.p2pChatVc setChatTitleWithName:@"客服"];
            weak_self.p2pChatVc.title = @"客服";
        });
    }else if([[FMessageManager sharedManager].aideNewsUserId isEqualToString:self.sessionId]){
        @weakify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak_self.p2pChatVc setChatTitleWithName:@"钱包消息"];
            weak_self.p2pChatVc.title = @"钱包消息";
        });
    }
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[FMessageManager sharedManager] refreshUnRead];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.navigationController.viewControllers.count == 1) {
        NSLog(@"viewDidDisappear");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTopView.hidden = YES;
    [self setWhiteNavBack];
    
    UIImage *bgImage = [UIImage imageNamed:@"bg_chat"];
//    if (kUserDefaultObjectForKey(@"chatSkinName")) {
//        NSString *chatSkinName = kUserDefaultObjectForKey(@"chatSkinName");
//        if ([chatSkinName containsString:@"local"]) {
//            bgImage = [UIImage imageWithData:[FDataTool getImageWithImageName:chatSkinName]];
//        }else{
//            bgImage = [UIImage imageNamed:chatSkinName];
//        }
//    }
    
    if (self.type == NIMSessionTypeP2P) {
        [self initP2PData];
        self.p2pChatVc = [[FMessageP2PViewController alloc] initWithSession:self.sessionId];
        self.p2pChatVc.delegate = self;
        [self addChildViewController:self.p2pChatVc];
        [self.view addSubview:self.p2pChatVc.view];
        if (bgImage) {
            [self.p2pChatVc setBgImage:bgImage];
        }
    }else{
        [self initGroupData];
        self.teamChatVc = [[FMessageTeamViewController alloc] initWithSession:self.sessionId];
        self.teamChatVc.delegate = self;
        [self addChildViewController:self.teamChatVc];
        [self.view addSubview:self.teamChatVc.view];
        
        self.scrollView = [[SWAnnouncementScrollView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, 30)];
        self.scrollView.hidden = YES;
        [self.view addSubview:self.scrollView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initGroupData) name:@"updateAnnouncement" object:nil];
        if (bgImage) {
            [self.teamChatVc setBgImage:bgImage];
        }
    }
    [[FMessageManager sharedManager] refreshUnRead];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupName:) name:@"UpdateGroupName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookAnnouncement) name:@"lookAnnouncement" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMsgRecord) name:FClearMsgRecord object:nil];

//    if (self.type != NIMSessionTypeP2P) {
//        [self requestEggData];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(crackOpenEggSuccess) name:CrackOpenEgg object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestEggData) name:GiveOutEggs object:nil];
//    }
}

- (void)requestEggData{
    @weakify(self);
    [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/groupCaidan" parameters:@{@"groupId":self.sessionId} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            weak_self.eggList = [TKEggListModel modelWithDictionary:response].data;
            [weak_self showEgg];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)crackOpenEggSuccess{
    [self requestEggData];
}

- (void)showEgg{
    if (self.eggList.count > 0) {
        self.eggShellView = [[TKSmashingEggshellView alloc] initWithFrame:CGRectMake(kScreenWidth - 75, kTopHeight+147, 47, 116)];
        [self.view addSubview:self.eggShellView];
        [self.eggShellView refreshViewWithData:self.eggList];
    }else if(self.eggShellView){
        [self.eggShellView removeFromSuperview];
        self.eggShellView = nil;
    }
}

- (void)initP2PData{
    @weakify(self)
    if ([FUserRelationManager sharedManager].allFriends.count > 0) {
        [self getMessageUserInfo];
    }else{
        [[FUserRelationManager sharedManager] reloadAllFriendsData:^(BOOL success) {
            [weak_self getMessageUserInfo];
        }];
    }
}

- (void)initGroupData{
    [self requestGroupData:^{
        if (self.groupModel.announcement.length > 0) {
            self.scrollView.hidden = NO;
            self.scrollView.textView.text = self.groupModel.announcement;
            [self.scrollView.textView startScroll];
        }else{
            self.scrollView.hidden = YES;
        }
    }];
}

- (void)updateGroupName:(NSNotification*)noti{
    self.groupModel.name = noti.object;
    if (self.type != NIMSessionTypeP2P) {
        [self.teamChatVc setGroupMessageNameWithName:[NSString stringWithFormat:@"%@(%ld)",self.groupModel.name,self.groupMembers.count]];
    }
}

- (void)lookAnnouncement{
    @weakify(self)
    [self requestGroupData:^{
        [weak_self showAnnouncement];
    }];
}

- (void)clearMsgRecord{
    if (self.type != NIMSessionTypeP2P) {
        [self.teamChatVc clearMsgRecord];
    }else{
        [self.p2pChatVc clearMsgRecord];
    }
    
}

- (void)showAnnouncement{
    if (self.groupModel.members.count > 0) {
        SWGroupInfoViewController *vc = [[SWGroupInfoViewController alloc] init];
        vc.model = self.groupModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        @weakify(self)
        [self requestGroupData:^{
            SWGroupInfoViewController *vc = [[SWGroupInfoViewController alloc] init];
            vc.model = self.groupModel;
            [weak_self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

- (void)getMessageUserInfo{
    for (FFriendModel *model in [FUserRelationManager sharedManager].allFriends) {
        if ([model.userId isEqualToString:self.sessionId]) {
            self.model = model;
            break;
        }
    }
    if (!self.model) {
        self.model = [FUserRelationManager sharedManager].allFriendDict[self.sessionId];
    }
}

- (void)requestGroupData:(void(^)(void))success{
    if (self.isRequesting) {
        return;
    }
    self.isRequesting = YES;
    @weakify(self)
    NSDictionary *params = @{@"groupId":self.sessionId};
    [[FNetworkManager sharedManager] getRequestFromServer:@"/group/groupHomeInfo" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.groupModel = [FGroupModel modelWithDictionary:response[@"data"]];
            [weak_self.teamChatVc setTeamTitleWithName:weak_self.groupModel.name];
            weak_self.teamChatVc.title = weak_self.groupModel.name;
            weak_self.pageNum = 1;
            [weak_self requestMembers:^{
                if (success) {
                    success();
                }
                self.isRequesting = NO;
            }];
            
        }else{
            self.isRequesting = NO;
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        self.isRequesting = NO;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)requestMembers:(void(^)(void))success{
    @weakify(self)
    NSDictionary *params = @{@"groupId":self.groupModel.groupId,@"page":@(self.pageNum)};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/groupUserListPost" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (weak_self.pageNum == 1) {
                [weak_self.groupMembers removeAllObjects];
            }
            if ([response[@"data"] count] == 0) {
                weak_self.groupMembers = weak_self.groupMembers;
                weak_self.groupModel.members = weak_self.groupMembers;
                [weak_self.teamChatVc setMemberListWithList:weak_self.groupMembers];
                if (success) {
                    success();
                }
                [weak_self.teamChatVc setGroupMessageNameWithName:[NSString stringWithFormat:@"%@(%ld)",self.groupModel.name,weak_self.groupMembers.count]];
                self.isRequesting = NO;
            }else{
                for (NSDictionary *dict in response[@"data"]) {
                    FGroupUserInfoModel *model = [FGroupUserInfoModel modelWithDictionary:dict];
                    [weak_self.groupMembers addObject:model];
                }
                weak_self.pageNum++;
                [weak_self requestMembers:success];
            }
        }else{
            self.isRequesting = NO;
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        self.isRequesting = NO;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (NSMutableArray *)groupMembers{
    if (!_groupMembers) {
        _groupMembers = [[NSMutableArray alloc] init];
    }
    return _groupMembers;
}

#pragma mark - FMessageP2PDelegate
- (void)clickRightMore{
    if (self.type == NIMSessionTypeP2P) {
        if (!self.model) {
            [SVProgressHUD showErrorWithStatus:@"该用户目前不是您的好友"];
            
            [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/searchByUserIdF" parameters:@{@"userId":self.sessionId} success:^(NSDictionary * _Nonnull response) {
                if ([response[@"code"] integerValue] == 200) {
                    FFriendModel *userModel = [FFriendModel modelWithDictionary:response[@"data"]];
                    SWAddFriendViewController *vc = [[SWAddFriendViewController alloc] init];
                    vc.model = userModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } failure:^(NSError * _Nonnull error) {
                
            }];
            
            return;
        }
        SWFriendInfoViewController *vc = [[SWFriendInfoViewController alloc] init];
        vc.user = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (self.groupModel.members.count > 0) {
            SWGroupInfoViewController *vc = [[SWGroupInfoViewController alloc] init];
            vc.model = self.groupModel;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            @weakify(self)
            [self requestGroupData:^{
                SWGroupInfoViewController *vc = [[SWGroupInfoViewController alloc] init];
                vc.model = self.groupModel;
                [weak_self.navigationController pushViewController:vc animated:YES];
            }];
        }
    }
}

- (void)sendRedPacket{    
    if (self.type == NIMSessionTypeP2P) {
        if (!self.model) {
            [SVProgressHUD showErrorWithStatus:@"该用户目前不是您的好友"];
            return;
        }
        SWSendRedPacketViewController *vc = [[SWSendRedPacketViewController alloc] init];
        vc.redType = RedPacketTypePerson;
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        FYSendRedPacketViewController *vc = [[FYSendRedPacketViewController alloc] init];
        vc.groupModel = self.groupModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)sendZhuazhang{
    if (!self.model) {
        [SVProgressHUD showErrorWithStatus:@"该用户目前不是您的好友"];
        return;
    }
    SWSendRedPacketViewController *vc = [[SWSendRedPacketViewController alloc] init];
    vc.redType = RedPacketTypeZhuazhang;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendUserCard{
    SWSelectUserViewController *vc = [[SWSelectUserViewController alloc] init];
    if (self.type == NIMSessionTypeP2P) {
        vc.userId = self.model.userId;
    }else{
        vc.groupModel = self.groupModel;
    }
    vc.type = SelectFriendTypeCommon;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showCollect{
    FMyCollectViewController *vc = [[FMyCollectViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)teamRedPacketActionWithModel:(MessageContentModel *)model{
    if(self.groupModel.shutupState == YES && self.groupModel.rankState != 1 && self.groupModel.rankState != 2){
        [SVProgressHUD showErrorWithStatus:@"全员禁言"];
        return;
    }
    FGroupUserInfoModel *user = [[FGroupUserInfoModel alloc] init];
    user.userId = model.message.from;
    user.avatar = model.avatar;
    user.name = model.fullName;
    
    
    SWSendRedPacketViewController *vc = [[SWSendRedPacketViewController alloc] init];
    vc.redType = RedPacketTypeSingle;
    vc.groupModel = self.groupModel;
    [self.navigationController pushViewController:vc animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc selectUser:user];
    });
}

- (void)teamKickoutActionWithModel:(MessageContentModel *)model{
    NSString *groupId = self.sessionId;
    if (self.groupModel.groupId.length > 0) {
        groupId = self.groupModel.groupId;
    }
    NSDictionary *params = @{@"members":@[model.message.from], @"groupId":groupId};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/outGroup" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            NSMutableArray *list = [[NSMutableArray alloc] initWithArray:weak_self.groupModel.members];
            for (NSInteger i=list.count - 1; i>=0; i--) {
                FGroupUserInfoModel *infoModel = [list objectAtIndex:i];
                if ([infoModel.userId isEqualToString:model.message.from]) {
                    [list removeObjectAtIndex:i];
                    break;
                }
            }
            weak_self.groupModel.members = list;
            [SVProgressHUD showSuccessWithStatus:@"移出成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)teamAvatarActionWithModel:(MessageContentModel *)model{
    FGroupUserInfoModel *infoModel = nil;
    for (FGroupUserInfoModel *tempInfoModel in self.groupModel.members) {
        if ([model.message.from isEqualToString:tempInfoModel.userId]) {
            infoModel = tempInfoModel;
            break;
        }
    }
    if (infoModel) {
        [[FUserRelationManager sharedManager] clickGroupMember:infoModel group:self.groupModel delegate:self];
    }
}

- (void)teamSwitchBtnActionWithModel:(MessageContentModel *)model user:(FGroupUserInfoModel * _Nullable)user{
    NSDictionary *params = @{@"members":@[user.userId], @"groupId":self.groupModel.groupId,@"state":@(!user.forbidState)};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/groupMember/invitationGroupBanOnLooting" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            user.forbidState = !user.forbidState;
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)reloadGroupMember{
    [self requestGroupData:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
