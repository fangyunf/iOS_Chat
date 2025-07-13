//
//  SWShopViewController.m
//  ShenWU
//
//  Created by Amy on 2024/10/19.
//

#import "SWShopViewController.h"
#import "SWShopHeaderView.h"
#import "SWShopItemCell.h"
#import "SWSearchView.h"
#import "SWOrderViewController.h"
@interface SWShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataList;
@end

@implementation SWShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [FControlTool createLabel:@"商城" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:24]];
    titleLabel.frame = CGRectMake(16, kStatusHeight+7, kScreenWidth - 28, 30);
    [self.view addSubview:titleLabel];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.view.bounds;
    gl.startPoint = CGPointMake(0.5, 0.03);
    gl.endPoint = CGPointMake(0.5, 0.77);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:252/255.0 green:74/255.0 blue:11/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:252/255.0 green:223/255.0 blue:186/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:253/255.0 blue:249/255.0 alpha:1].CGColor];
    gl.locations = @[@(0), @(0.6f), @(1.0f)];
    [self.view.layer insertSublayer:gl atIndex:0];
    
    SWSearchView *searchView = [[SWSearchView alloc] initWithFrame:CGRectMake(16, self.navTopView.bottom+10, kScreenWidth - 32, 48)];
    searchView.placeholder = @"搜索";
    searchView.backgroundColor = UIColor.clearColor;
    @weakify(self)
    searchView.searchBlock = ^(NSString * _Nonnull content) {
        
    };
    searchView.endSearchBlock = ^{
        
    };
    [self.view addSubview:searchView];
    
    UIImageView *fireworkImgView1 = [FControlTool createImageView];
    fireworkImgView1.frame = CGRectMake(kScreenWidth - 37, kStatusHeight+32, 37, 56);
    fireworkImgView1.image = [UIImage imageNamed:@"img_firework_2"];
    [self.view addSubview:fireworkImgView1];
    
    UIImageView *fireworkImgView2 = [FControlTool createImageView];
    fireworkImgView2.frame = CGRectMake(0, kStatusHeight+110, 52, 66);
    fireworkImgView2.image = [UIImage imageNamed:@"img_firework_1"];
    [self.view addSubview:fireworkImgView2];
    
    [self.view addSubview:self.collectionView];
    
    [self initData];
}

- (void)initData{
    self.dataList = [[NSMutableArray alloc] init];
    
//    [self.dataList addObject:@{@"image":@"https://img.zcool.cn/community/0139605ebcc969a801214814876e86.jpg@1280w_1l_2o_100sh.jpg",@"name":@"榨汁杯",@"price":@"¥68"}];
    [self.dataList addObject:@{@"image":@"https://img2.baidu.com/it/u=2441920201,1057085013&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=533",@"name":@"T恤",@"price":@"¥99"}];
    [self.dataList addObject:@{@"image":@"https://img1.baidu.com/it/u=2450120045,1777628418&fm=253&fmt=auto&app=138&f=JPEG?w=696&h=500",@"name":@"玩偶猫",@"price":@"¥128"}];
    [self.dataList addObject:@{@"image":@"http://t13.baidu.com/it/u=3969801106,555309175&fm=224&app=112&f=JPEG?w=500&h=500",@"name":@"哈卡曼顿智能音响",@"price":@"¥399"}];
    [self.dataList addObject:@{@"image":@"https://m.360buyimg.com/mobilecms/s750x750_jfs/t6019/323/2026519602/83998/de825fee/593a084fN31d2eed0.jpg%21q80.jpg",@"name":@"劳特莱男手表",@"price":@"¥6899"}];
    [self.dataList addObject:@{@"image":@"http://t15.baidu.com/it/u=3909023002,3275374159&fm=224&app=112&f=JPEG?w=500&h=333",@"name":@"俄罗斯进口酒",@"price":@"¥188"}];
    [self.dataList addObject:@{@"image":@"https://img01.yzcdn.cn/upload_files/2020/07/20/FtL-2PVjUn2fLm2oLtIk_J-lSnkl.png%21middle.jpg",@"name":@"纯棉家用面巾",@"price":@"¥18"}];
    [self.dataList addObject:@{@"image":@"https://pics3.baidu.com/feed/14ce36d3d539b600f2ac7825c9e8042dc75cb705.jpeg?token=e1898181ab92cc860fb7a0d96c75807d",@"name":@"荣事达空气炸锅",@"price":@"¥166"}];
    [self.dataList addObject:@{@"image":@"https://m.360buyimg.com/mobilecms/s750x750_jfs/t16717/313/940311777/218543/7a1cde0a/5ab1f06aN63d61d78.jpg%21q80.jpg",@"name":@"美味饼干",@"price":@"¥68"}];
    [self.dataList addObject:@{@"image":@"https://img01.yzcdn.cn/upload_files/2019/06/19/Fhz_PeJiLkR_Tsc-XE9Z2HkiwbLk.jpg%21middle.jpg",@"name":@"尖头平底小皮鞋",@"price":@"¥198"}];
    [self.dataList addObject:@{@"image":@"https://m.360buyimg.com/mobilecms/s750x750_jfs/t12478/133/1721840369/262610/3c81ba2c/5a2667f7N0efbb528.jpg%21q80.jpg",@"name":@"儿童雨靴",@"price":@"¥38"}];
    [self.dataList addObject:@{@"image":@"https://img14.360buyimg.com/pop/jfs/t1/59735/19/11330/116002/5d8c271eEe8b5f06b/7ecb68a18c402aec.jpg",@"name":@"苏泊尔保温壶",@"price":@"¥188"}];
    [self.dataList addObject:@{@"image":@"https://img01.yzcdn.cn/upload_files/2020/06/12/Fukv-kRW8xo5HVosWHpIJJS0Z4fY.jpg%21middle.jpg",@"name":@"滋源柔顺洗发水",@"price":@"¥98"}];
    [self.dataList addObject:@{@"image":@"https://img01.yzcdn.cn/upload_files/2021/05/15/FhyJFynd47ZY4Mbl4zRsT_fsIIWK.jpg%21middle.jpg",@"name":@"海尔洗衣机",@"price":@"¥2688"}];
    [self.dataList addObject:@{@"image":@"https://a.vpimg2.com/upload/merchandise/pdcvis/2017/03/02/197/164cd802295243578e8b86e99862ea84-651.jpg",@"name":@"口红",@"price":@"¥158"}];
    [self.dataList addObject:@{@"image":@"https://source.shop.busionline.com/201612011934-storeid-21393-5641de44a7d285641de44a7d711447157316.jpg",@"name":@"德芙巧克力",@"price":@"¥288"}];
    
    [self.dataList addObject:@{@"image":@"https://wx4.sinaimg.cn/mw690/0063nsE9ly1huhnesw5r1j60m80m8q6002.jpg",@"name":@"吉列剃须刀",@"price":@"¥78"}];
    [self.dataList addObject:@{@"image":@"https://img.yzcdn.cn/upload_files/2020/10/22/FuJUdUeEbBIbke9XOoQerfElO5lX.jpg%21middle.jpg",@"name":@"皮棉拖鞋女",@"price":@"¥28"}];
    [self.dataList addObject:@{@"image":@"https://ww4.sinaimg.cn/mw690/006P4QiMgy1hua58sthskj30p00xcjtv.jpg",@"name":@"时尚连衣裙女",@"price":@"¥488"}];
    [self.dataList addObject:@{@"image":@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.alicdn.com%2Fbao%2Fuploaded%2FTB1QXqRVSrqK1RjSZK9XXXyypXa.png&refer=http%3A%2F%2Fimg.alicdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1732435706&t=3e76df727478cb45380a6c70de7ea2c6",@"name":@"薄款冰丝袜子",@"price":@"¥48"}];
    [self.dataList addObject:@{@"image":@"https://www.ourqm.com/upload/2021/04/20/20210420212150885.jpg",@"name":@"GUCCI女士香水",@"price":@"¥429"}];
    
    [self.dataList addObject:@{@"image":@"https://wx4.sinaimg.cn/mw690/0063nsE9ly1huhnesw5r1j60m80m8q6002.jpg",@"name":@"吉列剃须刀",@"price":@"¥78"}];
    [self.dataList addObject:@{@"image":@"https://img.yzcdn.cn/upload_files/2020/10/22/FuJUdUeEbBIbke9XOoQerfElO5lX.jpg%21middle.jpg",@"name":@"皮棉拖鞋女",@"price":@"¥28"}];
    [self.dataList addObject:@{@"image":@"https://ww4.sinaimg.cn/mw690/006P4QiMgy1hua58sthskj30p00xcjtv.jpg",@"name":@"时尚连衣裙女",@"price":@"¥488"}];
    [self.dataList addObject:@{@"image":@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.alicdn.com%2Fbao%2Fuploaded%2FTB1QXqRVSrqK1RjSZK9XXXyypXa.png&refer=http%3A%2F%2Fimg.alicdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1732435706&t=3e76df727478cb45380a6c70de7ea2c6",@"name":@"薄款冰丝袜子",@"price":@"¥48"}];
    [self.dataList addObject:@{@"image":@"https://www.ourqm.com/upload/2021/04/20/20210420212150885.jpg",@"name":@"GUCCI女士香水",@"price":@"¥429"}];
    
    
}

- (void)searchBtnAction{
    
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {kScreenWidth,350};
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = {kScreenWidth,30};
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SWShopHeaderView *headView;
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        return headView;
    }
    if([kind isEqual:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SWShopItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SWShopItemCell class]) forIndexPath:indexPath];
    [cell refreshCellWithData:self.dataList[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SWOrderViewController *vc = [[SWOrderViewController alloc] init];
    vc.productData = self.dataList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((kScreenWidth - 40)/2, 258);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.navTopView.bottom+68, kScreenWidth, kScreenHeight - (self.navTopView.bottom+68) - kTabBarHeight) collectionViewLayout:layout];
        [_collectionView registerClass:[SWShopItemCell class] forCellWithReuseIdentifier:NSStringFromClass([SWShopItemCell class])];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[SWShopHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
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
