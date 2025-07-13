//
//  TKEggShopViewController.m
//  ShenWU
//
//  Created by Amy on 2024/8/13.
//

#import "TKEggShopViewController.h"
#import "TKSelectGroupViewController.h"
#import "TKMyEggsViewController.h"
#import "TKEggListModel.h"

@interface TKEggShopViewController ()
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic, assign) CGSize contentSize;
@end

@implementation TKEggShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(0xC6463A);
    [self setWhiteNavBack];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, kScreenWidth, 812*kScale);
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.image = [UIImage imageNamed:@"bg_egg_stop"];
    bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgImgView];
    
    UIButton *myEggBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_my_egg_title"] target:self sel:@selector(rightBtnAction)];
    myEggBtn.frame = CGRectMake(kScreenWidth - 96, kTopHeight+10, 83, 27);
    [bgImgView addSubview:myEggBtn];
    
//    self.navigationItem.rightBarButtonItem = [self getRightBarButtonItem:@"icn_my_egg_title" target:self action:@selector(rightBtnAction)];
    
    UIImageView *titleImgView1 = [[UIImageView alloc] init];
    titleImgView1.frame = CGRectMake((kScreenWidth - 118)/2, kTopHeight+10, 118, 27);
    titleImgView1.image = [UIImage imageNamed:@"icn_egg_title_1"];
    [bgImgView addSubview:titleImgView1];
    
    UIImageView *titleImgView2 = [[UIImageView alloc] init];
    titleImgView2.frame = CGRectMake((kScreenWidth - 354*kScale)/2, titleImgView1.bottom+15, 354*kScale, 43*kScale);
    titleImgView2.image = [UIImage imageNamed:@"icn_egg_title_2"];
    [bgImgView addSubview:titleImgView2];
    
    UIImageView *titleImgView3 = [[UIImageView alloc] init];
    titleImgView3.frame = CGRectMake((kScreenWidth - 196)/2, titleImgView2.bottom+20, 196, 23);
    titleImgView3.image = [UIImage imageNamed:@"icn_egg_title_3"];
    [bgImgView addSubview:titleImgView3];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.frame = CGRectMake(0, titleImgView3.bottom+10, kScreenWidth, kScreenHeight - (titleImgView3.bottom+10));
    self.contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.contentScrollView];
    
    self.dataList = [[NSMutableArray alloc] init];
//    self.dataList = @[@{@"eggImage":@"icn_shop_egg_1",@"price":@"188"},
//                      @{@"eggImage":@"icn_shop_egg_2",@"price":@"288"},
//                      @{@"eggImage":@"icn_shop_egg_3",@"price":@"388"},
//                      @{@"eggImage":@"icn_shop_egg_4",@"price":@"588"},
//                      @{@"eggImage":@"icn_shop_egg_5",@"price":@"666"},
//                      @{@"eggImage":@"icn_shop_egg_6",@"price":@"888"},
//                      @{@"eggImage":@"icn_shop_egg_7",@"price":@"1888"},
//                      @{@"eggImage":@"icn_shop_egg_8",@"price":@"2888"},
//                      @{@"eggImage":@"icn_shop_egg_9",@"price":@"3888"}];
    
    NSString *contentStr = @"购买彩蛋后可选择发放至指定群聊，群内成员均可参与砸蛋，其中vip会员中奖率更高，中奖者可得到相应彩蛋金额至余额，快快一起参与吧！\n\n注：购买彩蛋每笔订单平台将抽取10元服务费";
    
    self.contentSize = [contentStr sizeForFont:[UIFont fontWithSize:12] size:CGSizeMake(kScreenWidth - 100, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    
    UIView *desBgView = [[UIView alloc] init];
    desBgView.frame = CGRectMake(30, kScreenHeight - (self.contentSize.height+114), kScreenWidth - 60, self.contentSize.height+50+28+26);
    desBgView.backgroundColor = RGBColor(0x6F1009);
    desBgView.layer.cornerRadius = 10;
    desBgView.layer.masksToBounds = YES;
    [self.view addSubview:desBgView];
    
    UILabel *desTitleLabel = [FControlTool createLabel:@"- 彩蛋玩法 -" textColor:RGBColor(0xC1A66B) font:[UIFont fontWithSize:26]];
    desTitleLabel.frame = CGRectMake(0, 25, desBgView.width, 26);
    desTitleLabel.textAlignment = NSTextAlignmentCenter;
    [desBgView addSubview:desTitleLabel];
    
    UILabel *desContentLabel = [FControlTool createLabel:contentStr textColor:RGBColor(0xBA9B64) font:[UIFont fontWithSize:12]];
    desContentLabel.frame = CGRectMake(20, desTitleLabel.bottom+28, desBgView.width-40, self.contentSize.height);
    desContentLabel.textAlignment = NSTextAlignmentCenter;
    desContentLabel.numberOfLines = 0;
    [desBgView addSubview:desContentLabel];
    
    [self requestData];
}

- (void)initEggList{
    self.contentScrollView.contentSize = CGSizeMake(kScreenWidth, 146+242*(self.dataList.count/2)+182+(self.contentSize.height+114));
    
    for (NSInteger i=0; i<self.dataList.count; i++) {
        TKEggListItemModel *model = self.dataList[i];
        
        UIImageView *baseImgView = [[UIImageView alloc] init];
        if (i%2 == 0) {
            baseImgView.frame = CGRectMake(0, 146+242*(i/2), 159, 182);
            baseImgView.image = [UIImage imageNamed:@"bg_shop_base_left"];
        }else{
            baseImgView.frame = CGRectMake(kScreenWidth - 159, 146+242*(i/2), 159, 182);
            baseImgView.image = [UIImage imageNamed:@"bg_shop_base_right"];
        }
        [self.contentScrollView addSubview:baseImgView];
        
        UIImageView *eggImgView = [[UIImageView alloc] init];
        if (i/2 == 0) {
            if (i%2 == 0) {
                eggImgView.frame = CGRectMake(12, 146+240*(i/2)-198, 113, 298);
            }else{
                eggImgView.frame = CGRectMake(kScreenWidth - 113 - 12, 146+240*(i/2)-198, 113, 298);
            }
        }else if (i/2 == 1) {
            if (i%2 == 0) {
                eggImgView.frame = CGRectMake(12, 146+223*(i/2)-198, 113, 298);
            }else{
                eggImgView.frame = CGRectMake(kScreenWidth - 113 - 12, 146+223*(i/2)-198, 113, 298);
            }
        }else if (i/2 == 2) {
            if (i%2 == 0) {
                eggImgView.frame = CGRectMake(12, 146+245*(i/2)-198, 113, 298);
            }else{
                eggImgView.frame = CGRectMake(kScreenWidth - 113 - 12, 146+245*(i/2)-198, 113, 298);
            }
        }else if (i/2 == 3) {
            if (i%2 == 0) {
                eggImgView.frame = CGRectMake(12, 146+245*(i/2)-198, 113, 298);
            }else{
                eggImgView.frame = CGRectMake(kScreenWidth - 113 - 12, 146+245*(i/2)-198, 113, 298);
            }
        }else if (i/2 == 4) {
            if (i%2 == 0) {
                eggImgView.frame = CGRectMake(12, 146+250*(i/2)-198, 113, 298);
            }else{
                eggImgView.frame = CGRectMake(kScreenWidth - 113 - 12, 146+250*(i/2)-198, 113, 298);
            }
        }
        eggImgView.tag = 100+i;
        eggImgView.userInteractionEnabled = YES;
//        if (i>9) {
//            eggImgView.image = [UIImage imageNamed:@"icn_shop_egg_9"];
//        }else{
//            eggImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icn_shop_egg_%ld",i+1]];
//        }
        [eggImgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
        [self.contentScrollView addSubview:eggImgView];
        
        UILabel *priceLabel = [FControlTool createLabel:[NSString stringWithFormat:@"¥ %ld",model.price/100] textColor:RGBColor(0xC1A66B) font:[UIFont boldFontWithSize:18]];
        priceLabel.frame = CGRectMake(0, 36, 159, 21);
        priceLabel.textAlignment = NSTextAlignmentCenter;
        [baseImgView addSubview:priceLabel];
        
        UITapGestureRecognizer *payTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payTapAction:)];
        [eggImgView addGestureRecognizer:payTap];
    }
}

- (void)rightBtnAction{
    TKMyEggsViewController *vc = [[TKMyEggsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestData{
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/caidanList" parameters:[NSDictionary new] success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            TKEggListModel *modelList = [TKEggListModel modelWithDictionary:response];
            [weak_self.dataList removeAllObjects];
            [weak_self.dataList addObjectsFromArray:modelList.data];
            [weak_self initEggList];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)payTapAction:(UITapGestureRecognizer*)tap{
    @weakify(self)
    NSInteger index = tap.view.tag - 100;
    TKEggListItemModel *model = [self.dataList objectAtIndex:index];
    [FPayPasswordView showPayPrice:[NSString stringWithFormat:@"%ld",model.price/100] success:^(NSString * _Nonnull password) {
        [weak_self requestBuy:password index:index];
    }];
}

- (void)requestBuy:(NSString*)password index:(NSInteger)index{
    TKEggListItemModel *model = [self.dataList objectAtIndex:index];
    @weakify(self);
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/gmCaidan" parameters:@{@"caiDanId":model.eggId} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            [weak_self buyEggSuccess:model.eggId];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}

- (void)buyEggSuccess:(NSString*)eggId{
    @weakify(self);
    TKPaySucceseAlertView *view = [[TKPaySucceseAlertView alloc] initWithFrame:self.view.bounds bgImgStr:@"bg_pay_sucess" title:@"购买彩蛋成功" des:@"彩蛋可发放在指定群内" btnStr:@"放彩蛋"];
    view.clickOnSureBtn = ^{
        TKSelectGroupViewController *vc = [[TKSelectGroupViewController alloc] init];
        vc.eggId = eggId;
        [weak_self.navigationController pushViewController:vc animated:YES];
    };
    [[FControlTool keyWindow] addSubview:view];
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
