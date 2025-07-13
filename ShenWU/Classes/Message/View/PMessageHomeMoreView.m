//
//  PMessageHomeMoreView.m
//  ShenWU
//
//  Created by Amy on 2024/7/7.
//

#import "PMessageHomeMoreView.h"
#import "SWCreateGroupViewController.h"
#import "SWFriendInfoViewController.h"
#import "SWAddFriendViewController.h"
#import "SWGroupApplyViewController.h"
#import "SWSearchUserViewController.h"
#import "ScanHelper.h"
@interface PMessageHomeMoreView ()
@property(nonatomic, strong) UIImageView *bgImgView;
@property(nonatomic, strong) UILabel *groupNumLabel;
@end

@implementation PMessageHomeMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.6);
        
        self.bgImgView = [[UIImageView alloc] init];
        self.bgImgView.frame = CGRectMake((kScreenWidth - 345*kScale)/2, kScreenHeight - 310*kScale - kBottomSafeHeight , 345*kScale, 300*kScale);
        self.bgImgView.image = [UIImage imageNamed:@"bg_friend_msg_more"];
        self.bgImgView.userInteractionEnabled = YES;
        [self addSubview:self.bgImgView];
        
        UILabel *titleLabel = [FControlTool createLabel:@"更多功能" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:18]];
        titleLabel.frame = CGRectMake(15, 28, self.bgImgView.width-30, 21);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgImgView addSubview:titleLabel];
        
        UIButton *closeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_friend_msg_more_close"] target:self sel:@selector(closeBtnAction)];
        closeBtn.frame = CGRectMake((self.bgImgView.width - 24)/2, self.bgImgView.height - 34, 24, 24);
        [self.bgImgView addSubview:closeBtn];
        
        UIButton *createGroupBtn = [FControlTool createButton:@"建群聊" font:[UIFont fontWithSize:14] textColor:UIColor.blackColor target:self sel:@selector(createGroupBtnAction)];
        createGroupBtn.frame = CGRectMake(15, titleLabel.bottom+60, 76, 100);
        [createGroupBtn setImage:[UIImage imageNamed:@"icn_more_create"] forState:UIControlStateNormal];
        [createGroupBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:8];
        [self.bgImgView addSubview:createGroupBtn];
        
//        UILabel *groupLabel = [FControlTool createLabel:@"建群聊" textColor:UIColor.whiteColor font:[UIFont fontWithSize:13]];
//        groupLabel.frame = CGRectMake(0, 15, createGroupBtn.width, 15);
//        groupLabel.textAlignment = NSTextAlignmentCenter;
//        [createGroupBtn addSubview:groupLabel];
        
//        UIButton *joinGroupBtn = [FControlTool createButton:@"加入群聊" font:[UIFont fontWithSize:14] textColor:RGBColor(0x666666) target:self sel:@selector(joinTeamBtnAction)];
//        joinGroupBtn.frame = CGRectMake(0, createGroupBtn.bottom, 110, 39);
//        [joinGroupBtn setImage:[UIImage imageNamed:@"icn_group_apply"] forState:UIControlStateNormal];
//        [joinGroupBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:8];
//        [self.bgImgView addSubview:joinGroupBtn];
//        
        UIButton *addFriendBtn = [FControlTool createButton:@"加好友" font:[UIFont fontWithSize:14] textColor:UIColor.blackColor target:self sel:@selector(addFriendBtnAction)];
        addFriendBtn.frame = CGRectMake((self.bgImgView.width - 76)/2, titleLabel.bottom+60, 76, 100);
        [addFriendBtn setImage:[UIImage imageNamed:@"icn_more_add"] forState:UIControlStateNormal];
        [addFriendBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:8];
        [self.bgImgView addSubview:addFriendBtn];
        
//        UILabel *friendLabel = [FControlTool createLabel:@"加好友" textColor:UIColor.whiteColor font:[UIFont fontWithSize:13]];
//        friendLabel.frame = CGRectMake(0, 15, createGroupBtn.width, 15);
//        friendLabel.textAlignment = NSTextAlignmentCenter;
//        [addFriendBtn addSubview:friendLabel];

        UIButton *scanBtn = [FControlTool createButton:@"扫一扫" font:[UIFont fontWithSize:14] textColor:UIColor.blackColor target:self sel:@selector(scanBtnAction)];
        scanBtn.frame = CGRectMake(self.bgImgView.width - 91, titleLabel.bottom+60, 76, 100);
        [scanBtn setImage:[UIImage imageNamed:@"icn_more_scan"] forState:UIControlStateNormal];
        [scanBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:8];
        [self.bgImgView addSubview:scanBtn];
        
//        UILabel *scanLabel = [FControlTool createLabel:@"扫一扫" textColor:UIColor.whiteColor font:[UIFont fontWithSize:13]];
//        scanLabel.frame = CGRectMake(0, 15, createGroupBtn.width, 15);
//        scanLabel.textAlignment = NSTextAlignmentCenter;
//        [scanBtn addSubview:scanLabel];
//
//        self.groupNumLabel = [FControlTool createLabel:@"" textColor:UIColor.whiteColor font:[UIFont fontWithSize:8]];
//        self.groupNumLabel.frame = CGRectMake(self.bgImgView.width - 10, joinGroupBtn.top + 17, 5, 5);
//        self.groupNumLabel.backgroundColor = RGBColor(0xFD2635);
//        self.groupNumLabel.layer.cornerRadius = 2.5;
//        self.groupNumLabel.layer.masksToBounds = YES;
//        self.groupNumLabel.textAlignment = NSTextAlignmentCenter;
//        self.groupNumLabel.hidden = YES;
//        [self.bgImgView addSubview:self.groupNumLabel];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnReadCount) name:FRefreshUnReadCount object:nil];
//        [self refreshUnReadCount];
    }
    return self;
}

- (void)refreshUnReadCount{
    if ([FMessageManager sharedManager].groupNum > 0) {
        self.groupNumLabel.hidden = NO;
    }else{
        self.groupNumLabel.hidden = YES;
    }
}

- (void)createGroupBtnAction{
    SWCreateGroupViewController *vc = [[SWCreateGroupViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    [self removeFromSuperview];
}

- (void)joinTeamBtnAction{
    SWGroupApplyViewController *vc = [[SWGroupApplyViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    [self removeFromSuperview];
}

- (void)addFriendBtnAction{
    SWSearchUserViewController *vc = [[SWSearchUserViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    [self removeFromSuperview];
}

- (void)scanBtnAction{
    if (self.scanBlock) {
        self.scanBlock();
    }
    [self removeFromSuperview];
}

- (void)closeBtnAction{
    [self removeFromSuperview];
}

#pragma mark - 方法重新
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (!CGRectContainsPoint(self.bgImgView.frame, [touch locationInView:self])) {
        [self removeFromSuperview];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
