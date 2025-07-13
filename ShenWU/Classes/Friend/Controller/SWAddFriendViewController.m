//
//  SWAddFriendViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWAddFriendViewController.h"
#import "UITextView+Placeholder.h"
@interface SWAddFriendViewController ()
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *idLabel;
@property(nonatomic, strong) UITextView *inputTextView;
@end

@implementation SWAddFriendViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加好友";
    
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
    
    UILabel *verifyTitleLabel = [FControlTool createLabel:@"填写验证消息" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    verifyTitleLabel.frame = CGRectMake(23, self.avatarImgView.bottom+25, kScreenWidth - 46, 17);
    [self.view addSubview:verifyTitleLabel];
    
    self.inputTextView = [[UITextView alloc] init];
    self.inputTextView.frame = CGRectMake(23, verifyTitleLabel.bottom+21, kScreenWidth - 46, 74);
    self.inputTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.inputTextView.placeholder = @"填写验证消息";
    self.inputTextView.placeholderColor = RGBColor(0x999999);
    self.inputTextView.placeholderLabel.font = [UIFont boldFontWithSize:14];
    self.inputTextView.font = [UIFont boldFontWithSize:14];
    self.inputTextView.textColor = RGBColor(0x333333);
    self.inputTextView.backgroundColor = RGBColor(0xf2f2f2);
    self.inputTextView.layer.cornerRadius = 10;
    self.inputTextView.layer.masksToBounds = YES;
    [self.view addSubview:self.inputTextView];
    
    UIButton *finishBtn = [FControlTool createCommonButton:@"完成" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 120, 52) target:self sel:@selector(finishBtnAction)];
    finishBtn.frame = CGRectMake(60, self.inputTextView.bottom+135, kScreenWidth - 120, 52);
    finishBtn.layer.cornerRadius = 26;
    finishBtn.layer.masksToBounds = YES;
    [self.view addSubview:finishBtn];
}

- (void)finishBtnAction{
    @weakify(self)
    NSDictionary *params = @{@"memberCode":self.model.memberCode,@"remark":@"",@"msg":self.inputTextView.text};
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/friends/addFriends" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            [weak_self.navigationController popViewControllerAnimated:YES];
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
