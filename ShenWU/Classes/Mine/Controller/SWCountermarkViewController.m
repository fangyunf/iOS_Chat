//
//  SWCountermarkViewController.m
//  ShenWU
//
//  Created by Amy on 2024/7/17.
//

#import "SWCountermarkViewController.h"
#import "PMyNumberCell.h"
#import "PBuyNumberViewController.h"
#import "POtherPhoneModel.h"
@interface SWCountermarkViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataList;
@end

@implementation SWCountermarkViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的副号";
    [self setWhiteNavBack];
    
    UIImageView *bgImgView = [FControlTool createImageView];
    bgImgView.frame = self.view.bounds;
    bgImgView.image = [UIImage imageNamed:@"bg_countnumber"];
    [self.view addSubview:bgImgView];
    
    UILabel *hostLabel = [FControlTool createLabel:@"我的主号" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:15]];
    hostLabel.frame = CGRectMake(15, kTopHeight+12, kScreenWidth - 30, 18);
    [self.view addSubview:hostLabel];
    
    UILabel *phoneLabel = [FControlTool createLabel:[FUserModel sharedUser].phone textColor:RGBColor(0x000000) font:[UIFont regularFontWithSize:14]];
    phoneLabel.frame = CGRectMake(15, hostLabel.bottom+15, 110, 45);
    phoneLabel.backgroundColor = RGBAlphaColor(0xffffff, 0.64);
    phoneLabel.layer.cornerRadius = 2;
    phoneLabel.layer.masksToBounds = YES;
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:phoneLabel];
    
    UILabel *tipLabel = [FControlTool createLabel:@"默认登录密码和支付密码都为主号码" textColor:UIColor.whiteColor font:[UIFont fontWithSize:12]];
    tipLabel.frame = CGRectMake(15, phoneLabel.bottom+4, kScreenWidth - 30, 15);
    [self.view addSubview:tipLabel];
    
    
    UILabel *otherLabel = [FControlTool createLabel:@"我的副号" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:15]];
    otherLabel.frame = CGRectMake(15, tipLabel.bottom+28, kScreenWidth - 30, 18);
    [self.view addSubview:otherLabel];
    
    self.dataList = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.collectionView];
    
    UIButton *buyBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_buy_number"] target:self sel:@selector(buyBtnAction)];
    buyBtn.frame = CGRectMake(kScreenWidth - 107, kScreenHeight - 184, 101, 111);
    [self.view addSubview:buyBtn];
}

- (void)requestData{
    [self.dataList removeAllObjects];
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/home/wdfh" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            for (NSDictionary *data in response[@"data"]) {
                POtherPhoneModel *model = [POtherPhoneModel modelWithDictionary:data];
                [self.dataList addObject:model];
            }
            [weak_self.collectionView reloadData];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)buyBtnAction{
    PBuyNumberViewController *vc = [[PBuyNumberViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMyNumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PMyNumberCell class]) forIndexPath:indexPath];
    POtherPhoneModel *model = [self.dataList objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ 后两位为00-19",model.phoneFix];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((kScreenWidth - 40)/2, 45);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTopHeight+165, kScreenWidth, kScreenHeight - (kTopHeight+165) - kBottomSafeHeight) collectionViewLayout:layout];
        [_collectionView registerClass:[PMyNumberCell class] forCellWithReuseIdentifier:NSStringFromClass([PMyNumberCell class])];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
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
