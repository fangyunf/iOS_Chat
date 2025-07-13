//
//  FMoreActionView.m
//  Fiesta
//
//  Created by Amy on 2024/5/24.
//

#import "FMoreActionView.h"
#import "SWSearchUserViewController.h"
#import "SWCreateGroupViewController.h"
#import "ScanHelper.h"
#import "SWAddFriendViewController.h"
#import "SWFriendInfoViewController.h"
#import "SWSwitchAccountViewController.h"
@interface FMoreActionView ()
@property(nonatomic, strong) UIImageView *bgImgView;
@end

@implementation FMoreActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgImgView = [[UIImageView alloc] init];
        self.bgImgView.frame = CGRectMake(kScreenWidth - 232, 0, 232, 275);
        self.bgImgView.image = [UIImage imageNamed:@"more_bg"];
//        self.bgImgView.backgroundColor = UIColor.whiteColor;
        self.bgImgView.userInteractionEnabled = YES;
        [self addSubview:self.bgImgView];
        
        UIButton *createGroupBtn = [FControlTool createButton:@"新建群聊" font:[UIFont fontWithSize:16] textColor:UIColor.blackColor target:self sel:@selector(createGroupBtnAction)];
        createGroupBtn.frame = CGRectMake(52, 38, 142, 48);
        [createGroupBtn setImage:[UIImage imageNamed:@"icn_create_group"] forState:UIControlStateNormal];
        createGroupBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [createGroupBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:14];
        [self.bgImgView addSubview:createGroupBtn];
        
//        UIView *lineView = [[UIView alloc] init];
//        lineView.frame = CGRectMake(53, createGroupBtn.bottom, 113, 1);
//        lineView.backgroundColor = RGBColor(0xF0F0F0);
//        [self.bgImgView addSubview:lineView];
        
        UIButton *addFriendBtn = [FControlTool createButton:@"添加好友" font:[UIFont fontWithSize:16] textColor:UIColor.blackColor target:self sel:@selector(addFriendBtnAction)];
        addFriendBtn.frame = CGRectMake(52, createGroupBtn.bottom, 142, 48);
        [addFriendBtn setImage:[UIImage imageNamed:@"icn_add_friend"] forState:UIControlStateNormal];
        addFriendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [addFriendBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:14];
        [self.bgImgView addSubview:addFriendBtn];
        
//        UIView *lineView1 = [[UIView alloc] init];
//        lineView1.frame = CGRectMake(53, addFriendBtn.bottom, 113, 1);
//        lineView1.backgroundColor = RGBColor(0xF0F0F0);
//        [self.bgImgView addSubview:lineView1];
        
        UIButton *scanBtn = [FControlTool createButton:@"扫一扫" font:[UIFont fontWithSize:16] textColor:UIColor.blackColor target:self sel:@selector(scanBtnAction)];
        scanBtn.frame = CGRectMake(52, addFriendBtn.bottom, 142, 48);
        [scanBtn setImage:[UIImage imageNamed:@"icn_scan"] forState:UIControlStateNormal];
        scanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [scanBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:14];
        [self.bgImgView addSubview:scanBtn];
        
        UIButton *switchBtn = [FControlTool createButton:@"切换账号" font:[UIFont fontWithSize:16] textColor:UIColor.blackColor target:self sel:@selector(switchBtnAction)];
        switchBtn.frame = CGRectMake(52, scanBtn.bottom, 142, 48);
        [switchBtn setImage:[UIImage imageNamed:@"icn_switch_account"] forState:UIControlStateNormal];
        switchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [switchBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:14];
        [self.bgImgView addSubview:switchBtn];
    }
    return self;
}

- (void)createGroupBtnAction{
    [self removeFromSuperview];
    SWCreateGroupViewController *vc = [[SWCreateGroupViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)addFriendBtnAction{
    [self removeFromSuperview];
    SWSearchUserViewController *vc = [[SWSearchUserViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)scanBtnAction{
    [self removeFromSuperview];
    @weakify(self);
    __block ScanQRViewController *scanVc = [[ScanHelper shareInstance] scanVCWithStyle:qqStyle qrResultCallBack:^(id result) {
        @strongify(self);
        [scanVc.navigationController popViewControllerAnimated:NO];
        [self showScanResult:result];
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([[NIMSDK sharedSDK].userManager isMyFriend:model.userId]) {
                    SWFriendInfoViewController *vc = [[SWFriendInfoViewController alloc] init];
                    vc.user = model;
                    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
                }else{
                    SWAddFriendViewController *vc = [[SWAddFriendViewController alloc] init];
                    vc.model = model;
                    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
                }
            });
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)switchBtnAction{
    [self removeFromSuperview];
    SWSwitchAccountViewController *vc = [[SWSwitchAccountViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
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
