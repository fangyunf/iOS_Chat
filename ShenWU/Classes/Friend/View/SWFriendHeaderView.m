//
//  SWFriendHeaderView.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWFriendHeaderView.h"
#import "SWFriendHeaderCell.h"
#import "SWBlackListViewController.h"
#import "SWNewFriendViewController.h"
#import "SWLittleHelperViewController.h"
#import "SWMessageDetaillViewController.h"
#import "SWMyGroupsViewController.h"
#import "PSystomNotiViewController.h"
@interface SWFriendHeaderView ()//<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) NSArray *dataList;
@end

@implementation SWFriendHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBColor(0xf1f1f1);
        
        self.dataList = @[@{@"title":@"客服消息",@"imageName":@"icn_msg_kefu"},
                          @{@"title":@"黑名单",@"imageName":@"icn_msg_black"},
                          @{@"title":@"新好友",@"imageName":@"icn_new_friend"},
                          @{@"title":@"群聊",@"imageName":@"icn_msg_team"},
                          @{@"title":@"系统通知",@"imageName":@"icn_msg_systom"}];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame =  CGRectMake(7, 0, kScreenWidth - 14, 100);
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 15;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        
        for (NSInteger i=0; i<self.dataList.count; i++) {
            NSDictionary *dict = [self.dataList objectAtIndex:i];
            UIButton *btn = [FControlTool createButton:dict[@"title"] font:[UIFont fontWithSize:15] textColor:RGBColor(0x333333) target:self sel:@selector(btnAction:)];
            btn.frame = CGRectMake(10+((bgView.width - 60)/5+10)*i, 0, (bgView.width - 60)/5, 100);
            [btn setImage:[UIImage imageNamed:dict[@"imageName"]] forState:UIControlStateNormal];
            [btn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:14];
            btn.tag = 100+i;
            [bgView addSubview:btn];
            
            UILabel *numLabel = [FControlTool createLabel:@"" textColor:[UIColor whiteColor] font:[UIFont fontWithSize:7]];
            numLabel.frame = CGRectMake(btn.right-((bgView.width - 60)/5 - 32)/2 - 7.5, 19, 15, 15);
            numLabel.backgroundColor = RGBColor(0xFD2635);
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.layer.cornerRadius = 7.5;
            numLabel.layer.masksToBounds = YES;
            numLabel.tag = 200+i;
            numLabel.hidden = YES;
            [bgView addSubview:numLabel];
            
            if (i == 0 ) {
                NIMSession *session = [NIMSession session:[FMessageManager sharedManager].serviceUserId type:NIMSessionTypeP2P];
                NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
                if (recent.unreadCount > 0) {
                    numLabel.text = [FDataTool getUnreadCount:recent.unreadCount];
                    numLabel.hidden = NO;
                }
            }
            if (i == 4 ) {
//                NIMSession *session = [NIMSession session:[FUserModel sharedUser].userID type:NIMSessionTypeP2P];
//                NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
//                if (recent.unreadCount > 0) {
//                    numLabel.text = [FDataTool getUnreadCount:recent.unreadCount];
//                    numLabel.hidden = NO;
//                }
            }
            if (i == 2 && [FMessageManager sharedManager].friendNum > 0) {
                numLabel.text = [FDataTool getUnreadCount:[FMessageManager sharedManager].friendNum];
                numLabel.hidden = NO;
            }
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnReadCount) name:FRefreshUnReadCount object:nil];
    }
    return self;
}

- (void)refreshUnReadCount{
    UILabel *kefuNumLabel = [self viewWithTag:200];
    NIMSession *kefuSession = [NIMSession session:[FMessageManager sharedManager].serviceUserId type:NIMSessionTypeP2P];
    NIMRecentSession *kefuRecent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:kefuSession];
    if (kefuRecent.unreadCount > 0) {
        kefuNumLabel.text = [FDataTool getUnreadCount:kefuRecent.unreadCount];
        kefuNumLabel.hidden = NO;
    }else{
        kefuNumLabel.hidden = YES;
    }
    
//    UILabel *sysNumLabel = [self viewWithTag:204];
//    NIMSession *sysSession = [NIMSession session:[FUserModel sharedUser].userID type:NIMSessionTypeP2P];
//    NIMRecentSession *sysRecent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:sysSession];
//    if (sysRecent.unreadCount > 0) {
//        sysNumLabel.text = [FDataTool getUnreadCount:sysRecent.unreadCount];
//        sysNumLabel.hidden = NO;
//    }else{
//        sysNumLabel.hidden = YES;
//    }
    
    UILabel *friendNumLabel = [self viewWithTag:202];
    if ([FMessageManager sharedManager].friendNum > 0) {
        friendNumLabel.text = [FDataTool getUnreadCount:[FMessageManager sharedManager].friendNum];
        friendNumLabel.hidden = NO;
    }else{
        friendNumLabel.hidden = YES;
    }
}

- (void)btnAction:(UIButton*)sender{
    NSInteger index = sender.tag - 100;
    if (index == 0) {
        SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = NIMSessionTypeP2P;
        vc.sessionId = [FMessageManager sharedManager].serviceUserId;
        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
        NIMSession *session = [NIMSession session:[FMessageManager sharedManager].serviceUserId type:NIMSessionTypeP2P];
        [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:session];
        [[FMessageManager sharedManager] refreshUnRead];
        UILabel *kefuNumLabel = [self viewWithTag:200];
        kefuNumLabel.hidden = YES;
        [self addCustonSevirce:[FMessageManager sharedManager].serviceUserId];
    }else if(index == 1){
        SWBlackListViewController *vc = [[SWBlackListViewController alloc] init];
        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if(index == 2){
        SWNewFriendViewController *vc = [[SWNewFriendViewController alloc] init];
        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if(index == 3){
        SWMyGroupsViewController *vc = [[SWMyGroupsViewController alloc] init];
        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if(index == 4){
        PSystomNotiViewController *vc = [[PSystomNotiViewController alloc] init];
        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//        SWLittleHelperViewController *vc = [[SWLittleHelperViewController alloc] init];
//        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//        NIMSession *session = [NIMSession session:[FUserModel sharedUser].userID type:NIMSessionTypeP2P];
//        [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:session];
//        [[FMessageManager sharedManager] refreshUnRead];
//        UILabel *sysNumLabel = [self viewWithTag:204];
//        sysNumLabel.hidden = YES;
    }
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


//#pragma mark - UITableViewDelegate,UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataList.count;
//    
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60;
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellId = @"cellId";
//    SWFriendHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[SWFriendHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor whiteColor];
//        
//    }
//    NSDictionary *dict = [self.dataList objectAtIndex:indexPath.row];
//    cell.titleLabel.text = dict[@"title"];
//    cell.icnImgView.image = [UIImage imageNamed:dict[@"imageName"]];
//    cell.numberLabel.hidden = YES;
//    if (indexPath.row == 0 ) {
//        NIMSession *session = [NIMSession session:[FMessageManager sharedManager].serviceUserId type:NIMSessionTypeP2P];
//        NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
//        if (recent.unreadCount > 0) {
//            cell.numberLabel.text = [FDataTool getUnreadCount:recent.unreadCount];
//            cell.numberLabel.hidden = NO;
//        }
//    }
//    if (indexPath.row == 4 ) {
//        NIMSession *session = [NIMSession session:[FUserModel sharedUser].userID type:NIMSessionTypeP2P];
//        NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
//        if (recent.unreadCount > 0) {
//            cell.numberLabel.text = [FDataTool getUnreadCount:recent.unreadCount];
//            cell.numberLabel.hidden = NO;
//        }
//    }
//    if (indexPath.row == 2 && [FMessageManager sharedManager].friendNum > 0) {
//        cell.numberLabel.text = [FDataTool getUnreadCount:[FMessageManager sharedManager].friendNum];
//        cell.numberLabel.hidden = NO;
//    }
//    return cell;
//    
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        SWMessageDetaillViewController *vc = [[SWMessageDetaillViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.type = NIMSessionTypeP2P;
//        vc.sessionId = [FMessageManager sharedManager].serviceUserId;
//        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//        NIMSession *session = [NIMSession session:[FMessageManager sharedManager].serviceUserId type:NIMSessionTypeP2P];
//        [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:session];
//        [tableView reloadData];
//        [[FMessageManager sharedManager] refreshUnRead];
//        [self addCustonSevirce:[FMessageManager sharedManager].serviceUserId];
//    }else if(indexPath.row == 1){
//        SWBlackListViewController *vc = [[SWBlackListViewController alloc] init];
//        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//    }else if(indexPath.row == 2){
//        SWNewFriendViewController *vc = [[SWNewFriendViewController alloc] init];
//        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//    }else if(indexPath.row == 3){
//        SWMyGroupsViewController *vc = [[SWMyGroupsViewController alloc] init];
//        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//    }else if(indexPath.row == 4){
//        SWLittleHelperViewController *vc = [[SWLittleHelperViewController alloc] init];
//        [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//        NIMSession *session = [NIMSession session:[FUserModel sharedUser].userID type:NIMSessionTypeP2P];
//        [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:session];
//        [tableView reloadData];
//        [[FMessageManager sharedManager] refreshUnRead];
//    }
//}
//
//
//#pragma mark - Getter
//
//- (UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300) style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.backgroundColor = RGBColor(0xf1f1f1);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.scrollEnabled = NO;
//        [self addSubview:_tableView];
//    }
//    return _tableView;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
