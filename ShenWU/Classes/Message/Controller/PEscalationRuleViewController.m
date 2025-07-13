//
//  PEscalationRuleViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/17.
//

#import "PEscalationRuleViewController.h"

@interface PEscalationRuleViewController ()

@end

@implementation PEscalationRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"升级规则";
    
    self.view.backgroundColor = RGBColor(0xf2f2f2);
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(15, kTopHeight+12, kScreenWidth - 30, 230);
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    UILabel *contentLabel = [FControlTool createLabel:@"规则说明:\n每个群只能拉 500个人，如若想再拉人，须够买会员才能增加群成员\n升级1000人数88元\n升级人数永久生效，如解散群将失效;" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    contentLabel.frame = CGRectMake(22, 22, bgView.width - 44, bgView.height - 44);
    contentLabel.numberOfLines = 0;
    [bgView addSubview:contentLabel];
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
