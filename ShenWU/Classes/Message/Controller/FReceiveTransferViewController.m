//
//  FReceiveTransferViewController.m
//  ShenWU
//
//  Created by Amy on 2024/10/10.
//

#import "FReceiveTransferViewController.h"
#import "FReceiveMoneyDetailHeaderView.h"
#import "ShenWU-Swift.h"
@interface FReceiveTransferViewController ()
@property(nonatomic, strong) FReceiveMoneyDetailHeaderView *headerView;
@property(nonatomic, strong) FRedPacketMessageModel *redPacketModel;
@end

@implementation FReceiveTransferViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, 0.34)]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = RGBColor(0xF6F6F6);
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:RGBColor(0xF6F6F6) size:CGSizeMake(kScreenWidth, 0.34)]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTopView.hidden = YES;
    
    UIImageView *topBgImgView = [[UIImageView alloc] init];
    topBgImgView.frame = CGRectMake(0, 0, kScreenWidth, 206*kScale);
    topBgImgView.image = [UIImage imageNamed:@"bg_get_top"];
    [self.view addSubview:topBgImgView];

    self.headerView = [[FReceiveMoneyDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130+206*kScale+kStatusBarHeight)];
    [self.view addSubview:self.headerView];
    
    [self.headerView refreshTransferViewWithData:_redPacketDict];
}

- (void)setRedPacketDict:(NSDictionary *)redPacketDict{
    _redPacketDict = redPacketDict;
    NSLog(@"redPacketDict === :%@",redPacketDict);
    
}

//- (void)reloadView{
//    self.headerView.customType = self.redPacketModel.customType;
//    self.headerView.fromUserId = self.redPacketModel.fromUserId;
//    [self.headerView refreshViewWithData:self.redPacketDetailModel];
//    if (self.redPacketModel.customType == 21) {
//        [self.headerView changeViewFrame:self.redPacketModel.toUserId];
//        
//        if([self.redPacketModel.toUserId isEqualToString:[FUserModel sharedUser].userID]){
//            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 117+206*kScale);
//        }else{
//            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 52+206*kScale);
//        }
//        self.tableView.tableHeaderView = self.headerView;
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
