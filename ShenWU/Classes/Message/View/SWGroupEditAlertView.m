//
//  SWGroupEditAlertView.m
//  ShenWU
//
//  Created by Amy on 2024/6/28.
//

#import "SWGroupEditAlertView.h"

@interface SWGroupEditAlertView ()
@property(nonatomic, strong) UIView *bgView;
@end

@implementation SWGroupEditAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.5);
        
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 314);
        self.bgView.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.bgView];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:18]];
        self.titleLabel.frame = CGRectMake(48, 29, kScreenWidth - 96, 22);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.titleLabel];
        
        UIButton *closeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_name_close"] target:self sel:@selector(closeBtnAction)];
        closeBtn.frame = CGRectMake(kScreenWidth - 37, 29, 22, 22);
        [self.bgView addSubview:closeBtn];
        
        UIButton *nameBtn = [FControlTool createButton:@"修改群名称" font:[UIFont fontWithSize:18] textColor:UIColor.blackColor target:self sel:@selector(nameBtnAction)];
        nameBtn.frame = CGRectMake(15, 77, kScreenWidth - 30, 54);
        nameBtn.backgroundColor = RGBColor(0xf2f2f2);
        nameBtn.layer.cornerRadius = 10;
        nameBtn.layer.masksToBounds = YES;
        [self.bgView addSubview:nameBtn];
        
        UIButton *announcementBtn = [FControlTool createButton:@"修改公告栏" font:[UIFont fontWithSize:18] textColor:UIColor.blackColor target:self sel:@selector(announcementBtnAction)];
        announcementBtn.frame = CGRectMake(15, nameBtn.bottom+13, kScreenWidth - 30, 54);
        announcementBtn.backgroundColor = RGBColor(0xf2f2f2);
        announcementBtn.layer.cornerRadius = 10;
        announcementBtn.layer.masksToBounds = YES;
        [self.bgView addSubview:announcementBtn];
        
        UIButton *avatarBtn = [FControlTool createButton:@"修改群头像" font:[UIFont fontWithSize:18] textColor:UIColor.blackColor target:self sel:@selector(avatarBtnAction)];
        avatarBtn.frame = CGRectMake(15, announcementBtn.bottom+13, kScreenWidth - 30, 54);
        avatarBtn.backgroundColor = RGBColor(0xf2f2f2);
        avatarBtn.layer.cornerRadius = 10;
        avatarBtn.layer.masksToBounds = YES;
        [self.bgView addSubview:avatarBtn];
    }
    return self;
}

- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = CGRectMake(0, kScreenHeight-314, kScreenWidth, 314);
    }];
}

- (void)nameBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editGroupName)]) {
        [self.delegate editGroupName];
        [self removeFromSuperview];
    }
}

- (void)announcementBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editGroupAnnouncement)]) {
        [self.delegate editGroupAnnouncement];
        [self removeFromSuperview];
    }
}

- (void)avatarBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editGroupAvatar)]) {
        [self.delegate editGroupAvatar];
        [self removeFromSuperview];
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.hidden == YES) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.top = kScreenHeight-314;
    }];
}

- (void)closeBtnAction{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
