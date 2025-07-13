//
//  SWEditNameView.m
//  ShenWU
//
//  Created by Amy on 2024/6/21.
//

#import "SWEditNameView.h"

@interface SWEditNameView ()<UITextFieldDelegate>
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UITextField *inputTextField;
@end

@implementation SWEditNameView

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
        
        UIView *inputBgView = [[UIView alloc] init];
        inputBgView.frame = CGRectMake(15, self.titleLabel.bottom+31, kScreenWidth - 30, 54);
        inputBgView.layer.borderColor = UIColor.blackColor.CGColor;
        inputBgView.layer.borderWidth = 2;
        inputBgView.layer.cornerRadius = 15;
        [self.bgView addSubview:inputBgView];
        
        self.inputTextField = [[UITextField alloc] init];
        self.inputTextField.frame = CGRectMake(20, 0, inputBgView.width - 40, 54);
        self.inputTextField.font = [UIFont fontWithSize:16];
        self.inputTextField.textColor = [UIColor blackColor];
        self.inputTextField.returnKeyType = UIReturnKeyDone;
        [inputBgView addSubview:self.inputTextField];
        
        UIButton *sureBtn = [FControlTool createCommonButton:@"确定" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 120, 52) target:self sel:@selector(sureBtnAction)];
        sureBtn.frame = CGRectMake(60, inputBgView.bottom+113-kBottomSafeHeight, kScreenWidth - 120, 52);
        sureBtn.layer.cornerRadius = 26;
        sureBtn.layer.masksToBounds = YES;
        [self.bgView addSubview:sureBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)setNickName:(NSString *)nickName{
    _nickName = nickName;
    self.inputTextField.text = nickName;
}

- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame = CGRectMake(0, kScreenHeight-314, kScreenWidth, 314);
    } completion:^(BOOL finished) {
        [self.inputTextField becomeFirstResponder];
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
    if (self.inputTextField.text.length == 0) {
        return;
    }
    if (self.saveName) {
        self.saveName(self.inputTextField.text);
    }
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
