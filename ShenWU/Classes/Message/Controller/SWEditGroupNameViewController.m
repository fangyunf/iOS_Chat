//
//  SWEditGroupNameViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/28.
//

#import "SWEditGroupNameViewController.h"

@interface SWEditGroupNameViewController ()
@property(nonatomic, strong) UITextField *inputTextField;
@end

@implementation SWEditGroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = self.view.bounds;
//    bgImgView.image = [UIImage imageNamed:@"bg_mine"];
    bgImgView.backgroundColor = RGBColor(0xf2f2f2);
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.userInteractionEnabled = YES;
    bgImgView.layer.masksToBounds = YES;
    [self.view addSubview:bgImgView];
    
    UIView *inputBgView = [[UIView alloc] init];
    inputBgView.frame = CGRectMake(15, 107+kTopHeight, kScreenWidth - 30, 47);
    inputBgView.backgroundColor = UIColor.whiteColor;
    inputBgView.layer.cornerRadius = 10;
    inputBgView.layer.masksToBounds = YES;
    [self.view addSubview:inputBgView];
    
    UILabel *titleLabel = [FControlTool createLabel:@"群聊名称：" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:18]];
    titleLabel.frame = CGRectMake(8, 0, 90, 47);
    [inputBgView addSubview:titleLabel];
    
    self.inputTextField = [[UITextField alloc] init];
    self.inputTextField.frame = CGRectMake(titleLabel.right+8, 0, inputBgView.width - (titleLabel.right+18), 47);
    self.inputTextField.textColor = UIColor.blackColor;
    self.inputTextField.font = [UIFont boldFontWithSize:18];
    self.inputTextField.placeholder = @"请输入群聊名称";
    self.inputTextField.returnKeyType = UIReturnKeyDone;
    self.inputTextField.text = self.groupModel.name;
    [inputBgView addSubview:self.inputTextField];
    
    UIButton *sureBtn = [FControlTool createCommonButton:@"确定" font:[UIFont boldFontWithSize:18] cornerRadius:26 size:CGSizeMake(kScreenWidth - 120, 52) target:self sel:@selector(sureBtnAction)];
    sureBtn.frame = CGRectMake(60, inputBgView.bottom+100, kScreenWidth - 120, 52);
    sureBtn.layer.cornerRadius = 26;
    sureBtn.layer.masksToBounds = YES;
    [self.view addSubview:sureBtn];
}

- (void)sureBtnAction{
    if ([self.inputTextField.text stringByTrim].length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入群聊名称"];
        return;
    }
    NSDictionary *params = @{@"groupName":[self.inputTextField.text stringByTrim],@"groupId":self.groupModel.groupId};
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/updateGroupInfo" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (weak_self.saveName) {
                weak_self.saveName([weak_self.inputTextField.text stringByTrim]);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGroupName" object:[weak_self.inputTextField.text stringByTrim]];
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
