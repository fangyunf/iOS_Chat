//
//  TKVipCenterViewController.m
//  ShenWU
//
//  Created by Amy on 2024/9/19.
//

#import "TKVipCenterViewController.h"
//#import <SDCycleScrollView/SDCycleScrollView.h>
#import "TKVipItemCell.h"
#import "TKMemberListModel.h"
#import "TKMemberCodeCell.h"
@interface TKVipCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *vipCollectionView;
@property(nonatomic, strong) UIImageView *vipImgView;
@property(nonatomic, strong) TKMemberListModel *dataModel;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, assign) NSInteger vipLevel;
@property(nonatomic, assign) NSInteger selectIndex;
@end

@implementation TKVipCenterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"会员中心";
    
    self.view.backgroundColor = RGBColor(0x1E1E1E);
    [self setWhiteNavBack];
    
    UIImageView *bgImgView = [FControlTool createImageView];
    bgImgView.frame = self.view.bounds;
    bgImgView.image = [UIImage imageNamed:@"bg_vip"];
    [self.view addSubview:bgImgView];
    
    self.vipLevel = 1;
    self.selectIndex = -1;
    
    
    [self.view addSubview:self.vipCollectionView];
    
    
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(16,kTopHeight+100,kScreenWidth - 32,426);
    [view rounded:12];
    [self.view addSubview:view];
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = view.bounds;
    gl.startPoint = CGPointMake(0.5, 0.79);
    gl.endPoint = CGPointMake(0.5, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:253/255.0 blue:215/255.0 alpha:0.19].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:253/255.0 blue:151/255.0 alpha:0.0800].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [view.layer insertSublayer:gl atIndex:0];
//    // blur
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//    visualView.frame = view.bounds;
//    [view addSubview:visualView];
    
    self.titleLabel = [FControlTool createLabel:@"VIP1靓号" textColor:kMainColor font:[UIFont boldFontWithSize:16]];
    self.titleLabel.frame = CGRectMake(0, 16, kScreenWidth-32, 24);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.titleLabel];
    
    [view addSubview:self.collectionView];
    
    UILabel *tipLabel = [FControlTool createLabel:@"购买即可获得对应ID靓号" textColor:RGBColor(0xFFffff) font:[UIFont fontWithSize:14]];
    tipLabel.frame = CGRectMake(0, kScreenHeight - 76 - 18, kScreenWidth, 17);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    
    UIButton *buyBtn = [FControlTool createButton:@"立即购买" font:[UIFont boldFontWithSize:20] textColor:UIColor.whiteColor target:self sel:@selector(buyBtnAction)];
    buyBtn.frame = CGRectMake(15, tipLabel.bottom+5, kScreenWidth - 30, 50);
    buyBtn.backgroundColor = kMainColor;
    buyBtn.layer.cornerRadius = 25;
    buyBtn.layer.masksToBounds = YES;
    [self.view addSubview:buyBtn];
    
    self.titleLabel.text = [NSString stringWithFormat:@"VIP%d靓号",1];
    self.vipLevel = 1;
    self.selectIndex = -1;
    [self.collectionView reloadData];
    
    [self requestVipData];
}

- (void)requestVipData{
    @weakify(self);
    [[FNetworkManager sharedManager] postRequestFromServer:@"/meteor/list" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if (![FDataTool isNull:response] && ![FDataTool isNull:response[@"data"]]) {
            weak_self.dataModel = [TKMemberListModel modelWithDictionary:response[@"data"]];
            weak_self.titleLabel.text = [NSString stringWithFormat:@"VIP%d靓号",1];
            weak_self.vipLevel = 1;
            weak_self.selectIndex = -1;
            [weak_self.vipCollectionView reloadData];
            [weak_self.collectionView reloadData];
            
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)buyBtnAction{
    if (self.selectIndex < 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择靓号"];
        return;
    }
    @weakify(self);
    TKMemberItemModel *data = self.dataModel.list[self.vipLevel - 1];
    [FPayPasswordView showPayPrice:[NSString stringWithFormat:@"%.2lf",data.memberConfig.price.integerValue/100.0] success:^(NSString * _Nonnull password) {
        [weak_self requestBuy:password];
    }];
}

- (void)requestBuy:(NSString*)password{
    TKMemberItemModel *model = self.dataModel.list[self.vipLevel-1];
    NSString *code = [NSString stringWithFormat:@"%@",model.memberCode[self.selectIndex]];
    NSDictionary *params = @{@"memberCode":code,@"password":password};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/meteor/buyMember" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"购买成功"];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.vipCollectionView]) {
        return self.dataModel.list.count;
    }
    if (self.dataModel) {
        TKMemberItemModel *model = self.dataModel.list[self.vipLevel-1];
        return model.memberCode.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.vipCollectionView]) {
        TKVipItemCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TKVipItemCell class]) forIndexPath:indexPath];
        itemCell.tag = indexPath.row+1;
        [itemCell refreshCellWithData:self.dataModel.list[indexPath.row]];
        return itemCell;
    }
    TKMemberItemModel *model = self.dataModel.list[self.vipLevel-1];
    
    TKMemberCodeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TKMemberCodeCell class]) forIndexPath:indexPath];
    cell.codeLabel.text = [NSString stringWithFormat:@"%@",model.memberCode[indexPath.item]];
    if (indexPath.item == self.selectIndex) {
        cell.codeLabel.textColor = kMainColor;
        cell.codeLabel.layer.borderColor = kMainColor.CGColor;
    }else{
        cell.codeLabel.textColor = UIColor.whiteColor;
        cell.codeLabel.layer.borderColor = UIColor.whiteColor.CGColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.vipCollectionView]) {
        self.titleLabel.text = [NSString stringWithFormat:@"VIP%ld靓号",indexPath.row+1];
        self.vipLevel = indexPath.row+1;
        self.selectIndex = -1;
        [self.collectionView reloadData];
        
        @weakify(self);
        [[FNetworkManager sharedManager] postRequestFromServer:@"/meteor/list" parameters:@{} success:^(NSDictionary * _Nonnull response) {
            if (![FDataTool isNull:response] && ![FDataTool isNull:response[@"data"]]) {
                weak_self.dataModel = [TKMemberListModel modelWithDictionary:response[@"data"]];
                weak_self.selectIndex = -1;
                [weak_self.vipCollectionView reloadData];
                [weak_self.collectionView reloadData];
                
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
        return;
    }
    self.selectIndex = indexPath.row;
    [self.collectionView reloadData];
    
}

#pragma mark ----懒加载
- (UICollectionView *)vipCollectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(79, 37);
        layout.minimumInteritemSpacing = 10;
        _vipCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, kTopHeight+30, kScreenWidth - 32, 37) collectionViewLayout:layout];
        [_vipCollectionView registerClass:[TKVipItemCell class] forCellWithReuseIdentifier:NSStringFromClass([TKVipItemCell class])];
        _vipCollectionView.backgroundColor = [UIColor clearColor];
        _vipCollectionView.showsHorizontalScrollIndicator = NO;
        _vipCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _vipCollectionView.delegate = self;
        _vipCollectionView.dataSource = self;
    }
    return _vipCollectionView;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(90, 31);
        layout.minimumLineSpacing = 25;
//        layout.minimumInteritemSpacing = (kScreenWidth - 90*3 - 32 - 32)/2;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, self.titleLabel.bottom+14, kScreenWidth - 32 - 32, 426-58) collectionViewLayout:layout];
        [_collectionView registerClass:[TKMemberCodeCell class] forCellWithReuseIdentifier:NSStringFromClass([TKMemberCodeCell class])];
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
