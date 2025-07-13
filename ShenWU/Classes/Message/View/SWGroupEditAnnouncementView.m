//
//  SWGroupEditAnnouncementView.m
//  ShenWU
//
//  Created by Amy on 2024/6/28.
//

#import "SWGroupEditAnnouncementView.h"

@interface SWGroupEditAnnouncementView ()
@property(nonatomic, strong) UIView *bgView;

@end

@implementation SWGroupEditAnnouncementView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.5);
        
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 314);
        self.bgView.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.bgView];
        
        self.titleLabel = [FControlTool createLabel:@"修改公告" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:18]];
        self.titleLabel.frame = CGRectMake(48, 29, kScreenWidth - 96, 22);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.titleLabel];
        
        UIButton *closeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_name_close"] target:self sel:@selector(closeBtnAction)];
        closeBtn.frame = CGRectMake(kScreenWidth - 37, 29, 22, 22);
        [self.bgView addSubview:closeBtn];
        
        self.inputTextView = [[UITextView alloc] init];
        self.inputTextView.frame = CGRectMake(15, 77, kScreenWidth - 30, 145);
        self.inputTextView.font = [UIFont fontWithSize:16];
        self.inputTextView.layer.borderColor = UIColor.blackColor.CGColor;
        self.inputTextView.layer.borderWidth = 2;
        self.inputTextView.layer.cornerRadius = 15;
        self.inputTextView.textColor = [UIColor blackColor];
        self.inputTextView.contentInset = UIEdgeInsetsMake(12, 20, 12, 20);
        self.inputTextView.returnKeyType = UIReturnKeyDone;
        [self.bgView addSubview:self.inputTextView];
        
        UIButton *sureBtn = [FControlTool createCommonButton:@"确定" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 120, 52) target:self sel:@selector(sureBtnAction)];
        sureBtn.frame = CGRectMake(60, self.inputTextView.bottom+20, kScreenWidth - 120, 52);
        sureBtn.layer.cornerRadius = 26;
        sureBtn.layer.masksToBounds = YES;
        [self.bgView addSubview:sureBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = CGRectMake(0, kScreenHeight-314, kScreenWidth, 314);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.inputTextView becomeFirstResponder];
        });
    }];
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.hidden == YES) {
        return;
    }
   
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.top -= rect.size.height;
    }];
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

- (void)sureBtnAction{
    NSDictionary *params = @{@"announcement":[self.inputTextView.text stringByTrim],@"groupId":self.model.groupId};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/updateGroupInfo" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (weak_self.saveName) {
                weak_self.saveName([weak_self.inputTextView.text stringByTrim]);
            }
            [weak_self removeFromSuperview];
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAnnouncement" object:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
