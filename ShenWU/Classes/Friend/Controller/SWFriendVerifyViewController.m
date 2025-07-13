//
//  SWFriendVerifyViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWFriendVerifyViewController.h"
#import "UITextView+Placeholder.h"
#import "SWEditNameView.h"
@interface SWFriendVerifyViewController ()
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *idLabel;
@property(nonatomic, strong) UITextView *inputTextView;
@property(nonatomic, strong) UITextField *remarkTextField;
@end

@implementation SWFriendVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTopView.hidden = YES;
    
    self.title = @"通过好友验证";
    self.view.backgroundColor = UIColor.whiteColor;
    
//    UIImageView *bgImgView = [[UIImageView alloc] init];
//    bgImgView.frame = self.view.bounds;
//    bgImgView.image = [UIImage imageNamed:@"bg_mine"];
//    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
//    bgImgView.userInteractionEnabled = YES;
//    bgImgView.layer.masksToBounds = YES;
//    [self.view addSubview:bgImgView];
    
    
    self.avatarImgView = [[UIImageView alloc] init];
    self.avatarImgView.frame = CGRectMake(23, kTopHeight+42, 60, 60);
    self.avatarImgView.layer.cornerRadius = 10;
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    [self.view addSubview:self.avatarImgView];
    
    self.nameLabel = [FControlTool createLabel:self.model.name textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    self.nameLabel.frame = CGRectMake(self.avatarImgView.right+18, self.avatarImgView.top+10, kScreenWidth - (self.avatarImgView.right+34), 18);
    [self.view addSubview:self.nameLabel];
    
    self.idLabel = [FControlTool createLabel:[NSString stringWithFormat:@"ID:%@",self.model.memberCode] textColor:UIColor.blackColor font:[UIFont fontWithSize:12]];
    self.idLabel.frame = CGRectMake(self.avatarImgView.right+18, self.nameLabel.bottom+10, kScreenWidth - (self.avatarImgView.right+34), 15);
    [self.view addSubview:self.idLabel];
    
    UILabel *groupTitleLabel = [FControlTool createLabel:@"设置备注" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    groupTitleLabel.frame = CGRectMake(23, self.avatarImgView.bottom+24, kScreenWidth - 46, 17);
    [self.view addSubview:groupTitleLabel];
    
    UIView *remarkBgView = [[UIView alloc] init];
    remarkBgView.frame = CGRectMake(23, groupTitleLabel.bottom+21, kScreenWidth - 46, 44);
    remarkBgView.backgroundColor = RGBColor(0xF2F2F2);
    remarkBgView.layer.cornerRadius = 10;
    remarkBgView.layer.masksToBounds = YES;
    [self.view addSubview:remarkBgView];
    
    self.remarkTextField = [[UITextField alloc] init];
    self.remarkTextField.frame = CGRectMake(19, 0, remarkBgView.width - 38, 44);
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:@"请输入备注" attributes:@{NSForegroundColorAttributeName:RGBColor(0x999999),NSFontAttributeName:[UIFont fontWithSize:15]}];
    self.remarkTextField.attributedPlaceholder = placeholderString;
    self.remarkTextField.font = [UIFont boldFontWithSize:14];
    self.remarkTextField.textColor = RGBColor(0x333333);
    [remarkBgView addSubview:self.remarkTextField];
    
    UILabel *verifyTitleLabel = [FControlTool createLabel:@"验证消息" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    verifyTitleLabel.frame = CGRectMake(23, remarkBgView.bottom+29, kScreenWidth - 46, 17);
    [self.view addSubview:verifyTitleLabel];
    
    self.inputTextView = [[UITextView alloc] init];
    self.inputTextView.frame = CGRectMake(23, verifyTitleLabel.bottom+21, kScreenWidth - 46, 74);
    self.inputTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.inputTextView.text = self.model.leaveMessage;
    self.inputTextView.placeholderColor = RGBColor(0x999999);
    self.inputTextView.placeholderLabel.font = [UIFont boldFontWithSize:14];
    self.inputTextView.font = [UIFont boldFontWithSize:14];
    self.inputTextView.textColor = RGBColor(0x333333);
    self.inputTextView.backgroundColor = RGBColor(0xF2F2F2);
    self.inputTextView.layer.cornerRadius = 10;
    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.editable = NO;
    [self.view addSubview:self.inputTextView];
    
    
    UIButton *agreeBtn = [FControlTool createCommonButton:@"通过验证" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 120, 52) target:self sel:@selector(agreeBtnAction)];
    agreeBtn.frame = CGRectMake(60, self.inputTextView.bottom+58, kScreenWidth - 120, 52);
    agreeBtn.layer.cornerRadius = 26;
    agreeBtn.layer.masksToBounds = YES;
    [self.view addSubview:agreeBtn];
    
    UIButton *refuseBtn = [FControlTool createButton:@"拒绝" font:[UIFont fontWithSize:18] textColor:UIColor.blackColor target:self sel:@selector(refuseBtnAction)];
    refuseBtn.frame = CGRectMake(60, agreeBtn.bottom+15, kScreenWidth - 120, 24);
    [self.view addSubview:refuseBtn];
    
    
}

- (void)refuseBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refuseApply:)]) {
        [self.delegate refuseApply:self];
    }
    [self handleFriendApply:2];
}

- (void)agreeBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreeApply:)]) {
        [self.delegate agreeApply:self];
    }
    [self handleFriendApply:1];
}

- (void)handleFriendApply:(NSInteger)type{
    @weakify(self)
    [SVProgressHUD show];
    NSDictionary *params = @{@"id":self.model.applyId,@"type":@(type),@"remark":self.remarkTextField.text};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/appFriendApplyEd" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [weak_self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
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
