//
//  SWMessageViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/19.
//

#import "SWMessageViewController.h"
#import "TKNotiyViewController.h"
#import "SWNotiScrollView.h"
#import "ShenWU-Swift.h"
#import "SWSearchView.h"
#import "SWSearchUserViewController.h"
#import "SWSearchViewController.h"
#import "SWMessageDetaillViewController.h"
#import "PMessageHomeMoreView.h"
#import "SWLittleHelperViewController.h"
#import "ScanHelper.h"
#import "SWFriendInfoViewController.h"
#import "SWAddFriendViewController.h"
#import "FMoreActionView.h"
@interface SWMessageViewController ()<FConversationListDelegate>
@property(nonatomic, strong) FConversationListShowVc *conversationVc;
@property(nonatomic, strong) UILabel *redPointView;
@property(nonatomic, strong) SWNotiScrollView *notiView;
@property(nonatomic, strong) FGroupModel *groupModel;
@property(nonatomic, strong) NSMutableArray *groupMembers;
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, strong) SWSearchView *searchView;
@property(nonatomic, strong) FMoreActionView *moreView;
@end

@implementation SWMessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.whiteColor};
    self.navigationController.navigationBar.titleTextAttributes = attribute;

    self.navigationController.navigationBarHidden = YES;
    [self requestNotiNum];
    [[FMessageManager sharedManager] requestApplyListNum];
    [self.conversationVc setAppearWithIsAppear:YES];
    [self.conversationVc reloadTableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.conversationVc setAppearWithIsAppear:NO];
    [self.searchView endSearchContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTopView.hidden = YES;
    
    UIImageView *topBgImgView = [FControlTool createImageView];
    topBgImgView.frame = CGRectMake(0, 0, kScreenWidth, 267*kScale);
    topBgImgView.image = [UIImage imageNamed:@"bg_common_top"];
    [self.view addSubview:topBgImgView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"对话" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:24]];
    titleLabel.frame = CGRectMake(16, kStatusHeight+7, kScreenWidth - 32, 30);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLabel];
    
    self.view.backgroundColor = RGBColor(0xF5F7FA);
    
    self.notiView = [[SWNotiScrollView alloc] initWithFrame:CGRectMake(10, self.navTopView.bottom+16, kScreenWidth - 20, 42)];
    self.notiView.backgroundColor = RGBAlphaColor(0x8F55FF, 0.08);
    [self.notiView rounded:12];
    [self.view addSubview:self.notiView];
    
    self.searchView = [[SWSearchView alloc] initWithFrame:CGRectMake(16, self.notiView.bottom+8, kScreenWidth - 32, 42)];
    self.searchView.placeholder = @"搜索";
    @weakify(self)
    self.searchView.searchBlock = ^(NSString * _Nonnull content) {
        [weak_self.conversationVc searchDataWithContent:content];
    };
    self.searchView.endSearchBlock = ^{
        [weak_self.conversationVc searchDataWithContent:@""];
    };
    [self.view addSubview:self.searchView];
    
    UIButton *moreBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_friend_add"] target:self sel:@selector(moreBtnAction)];
    moreBtn.frame = CGRectMake(kScreenWidth - 61, kStatusHeight, 44, 44);
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:moreBtn];
    
    UIButton *notiBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_friend_msg_noti"] target:self sel:@selector(notiBtnAction)];
    notiBtn.frame = CGRectMake(moreBtn.left - 27, kStatusHeight, 44, 44);
    notiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:notiBtn];
    
    self.redPointView = [FControlTool createLabel:@"99+" textColor:UIColor.whiteColor font:[UIFont fontWithSize:10]];
    self.redPointView.frame = CGRectMake(moreBtn.left - 13, kStatusHeight+6, 24, 12);
    self.redPointView.backgroundColor = RGBAlphaColor(0xFF0000, 0.8);
    self.redPointView.layer.cornerRadius = 6;
    self.redPointView.layer.masksToBounds = YES;
    self.redPointView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.redPointView];
    
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imLoginSuccess) name:FIMLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topScrollInfoChange:) name:FTopInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnReadCount) name:FRefreshUnReadCount object:nil];
    [self refreshUnReadCount];
    if (kAppDelegate.isIMLogin) {
        [self imLoginSuccess];
    }
}

- (void)imLoginSuccess{
    if (self.conversationVc) {
        return;
    }
    self.conversationVc = [[FConversationListShowVc alloc] init];
    self.conversationVc.delegate = self;
    self.conversationVc.view.frame = CGRectMake(0, self.searchView.bottom+8, kScreenWidth, kScreenHeight-(self.searchView.bottom+6) - kTabBarHeight);
    [self addChildViewController:self.conversationVc];
    [self.view addSubview:self.conversationVc.view];
    
    [self.conversationVc setSelectTypeWithType:NIMSessionTypeTeam];
}

- (void)requestNotiNum{
    @weakify(self);
    [[FNetworkManager sharedManager] getRequestFromServer:@"/customer/noticeList" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            NSInteger old = 0;
            if (kUserDefaultObjectForKey(SYSNOTINUM)) {
                old = [kUserDefaultObjectForKey(SYSNOTINUM) integerValue];
            }
            [FMessageManager sharedManager].sysNotiNum = [response[@"data"] count] - old;
            [weak_self refreshUnReadCount];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)refreshUnReadCount{
    NIMSession *sysSession = [NIMSession session:[FUserModel sharedUser].userID type:NIMSessionTypeP2P];
    NIMRecentSession *sysRecent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:sysSession];
    if ([FMessageManager sharedManager].groupNum > 0 || sysRecent.unreadCount > 0 || [FMessageManager sharedManager].sysNotiNum > 0) {
        self.redPointView.hidden = NO;
        self.redPointView.text = [FDataTool getUnreadCount:[FMessageManager sharedManager].groupNum+sysRecent.unreadCount+[FMessageManager sharedManager].sysNotiNum];
    }else{
        self.redPointView.hidden = YES;
    }
}

- (void)reloadTableView{
    [self.conversationVc reloadTableView];
}

- (void)requestData{
    
    ///aideNews/scroll
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] getRequestFromServer:@"/customer/notice" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        NSLog(@"response == :%@",response);
        if ([response[@"code"] integerValue] == 200) {
            NSDictionary *dict = response[@"data"];
            if (![FDataTool isNull:dict] && ![FDataTool isNull:dict[@"content"]] ) {
                weak_self.notiView.hidden = NO;
                weak_self.notiView.textView.text = dict[@"content"];
                [weak_self.notiView.textView startScroll];
            }else{
                weak_self.notiView.textView.text = @"";
            }
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)topScrollInfoChange:(NSNotification*)noti{
    NSDictionary *dict = noti.object;
    if (![FDataTool isNull:dict] && ![FDataTool isNull:dict[@"content"]] ) {
        self.notiView.hidden = NO;
        self.notiView.textView.text = dict[@"content"];
        [self.notiView.textView startScroll];
    }else{
        self.notiView.textView.text = @"";
    }
}

- (void)moreBtnAction{
//    PMessageHomeMoreView *view = [[PMessageHomeMoreView alloc] initWithFrame:self.view.bounds];
//    view.scanBlock = ^{
//        [self scanAction];
//    };
//    [[FControlTool keyWindow] addSubview:view];
    
    self.moreView = [[FMoreActionView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kStatusBarHeight)];
    [self.view addSubview:self.moreView];
}

- (void)searchBtnAction{
    SWSearchViewController *vc = [[SWSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanAction{
    @weakify(self);
    __block ScanQRViewController *scanVc = [[ScanHelper shareInstance] scanVCWithStyle:qqStyle qrResultCallBack:^(id result) {
        @strongify(self);
        [scanVc.navigationController popViewControllerAnimated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showScanResult:result];
        });
    }];
    [[FControlTool getCurrentVC].navigationController pushViewController:scanVc animated:YES];
}

- (void)showScanResult:(NSString *)result{
    
    NSArray *list = [result componentsSeparatedByString:@"."];
    NSDictionary *params = @{@"phoneAndCode":list[1],@"type":@0};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/search" parameters:params success:^(NSDictionary * _Nonnull response) {
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

- (void)notiBtnAction{
    TKNotiyViewController *vc = [[TKNotiyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - FConversationListDelegate
- (void)conversationListSelectedTableRowWithSessionType:(NIMSessionType)sessionType sessionId:(NSString *)sessionId indexPath:(NSIndexPath *)indexPath{
    if (sessionType == NIMSessionTypeP2P) {
        if ([[FMessageManager sharedManager].aideNewsUserId isEqualToString:sessionId]) {
            /// 去小助手
            SWLittleHelperViewController *assistantVc = [[SWLittleHelperViewController alloc] init];
            assistantVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:assistantVc animated:YES];
            [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:[NIMSession session:sessionId type:NIMSessionTypeP2P]];
            [[FMessageManager sharedManager] refreshUnRead];
        }else{
            SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.type = sessionType;
            vc.sessionId = sessionId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }else if (sessionType == NIMSessionTypeTeam) {
//        self.pageNum = 1;
//        [self.groupMembers removeAllObjects];
//        [self requestGroupData:sessionId];
        SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = NIMSessionTypeTeam;
        vc.sessionId = sessionId;
        vc.groupModel = self.groupModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)requestGroupData:(NSString*)groupId{
    @weakify(self)
    NSDictionary *params = @{@"groupId":groupId};
    [[FNetworkManager sharedManager] getRequestFromServer:@"/group/groupHomeInfo" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.groupModel = [FGroupModel modelWithDictionary:response[@"data"]];
            [weak_self requestMembers];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)requestMembers{
    @weakify(self)
    NSDictionary *params = @{@"groupId":self.groupModel.groupId,@"page":@(self.pageNum)};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/groupUserListPost" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (weak_self.pageNum == 1) {
                [weak_self.groupMembers removeAllObjects];
            }
            if ([response[@"data"] count] == 0) {
                [SVProgressHUD dismiss];
                weak_self.groupModel.members = weak_self.groupMembers;
                SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.type = NIMSessionTypeTeam;
                vc.sessionId = weak_self.groupModel.groupId;
                vc.groupModel = weak_self.groupModel;
                [weak_self.navigationController pushViewController:vc animated:YES];
            }else{
                for (NSDictionary *dict in response[@"data"]) {
                    FGroupUserInfoModel *model = [FGroupUserInfoModel modelWithDictionary:dict];
                    [weak_self.groupMembers addObject:model];
                }
                weak_self.pageNum++;
                [weak_self requestMembers];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (NSMutableArray *)groupMembers{
    if (!_groupMembers) {
        _groupMembers = [[NSMutableArray alloc] init];
    }
    return _groupMembers;
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
