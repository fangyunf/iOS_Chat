//
//  SWBillingFilterView.m
//  ShenWU
//
//  Created by Amy on 2024/6/30.
//

#import "SWBillingFilterView.h"
#import "FBillingFilterItemCell.h"

@interface SWBillingFilterView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, strong) NSArray *typeList;
@end

@implementation SWBillingFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.5);
        
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(0, kScreenHeight - 507, kScreenWidth, 507);
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self.bgView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
        [self addSubview:self.bgView];
        
//        UIButton *closeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_name_close"] target:self sel:@selector(closeBtnAction)];
//        closeBtn.frame = CGRectMake(kScreenWidth - 37, 29, 22, 22);
//        [self.bgView addSubview:closeBtn];
        UILabel *titleLabel = [FControlTool createLabel:@"选择筛选项" textColor:RGBColor(0x081C2C) font:[UIFont boldFontWithSize:16]];
        titleLabel.frame = CGRectMake(17, 24, kScreenWidth - 34, 22);
        [self.bgView addSubview:titleLabel];
        
        UIButton *cancelBtn = [FControlTool createButton:@"取消" font:[UIFont fontWithSize:18] textColor:RGBColor(0x081C2C) target:self sel:@selector(closeBtnAction)];
        cancelBtn.frame = CGRectMake(16, self.bgView.height - 93 , (kScreenWidth - 41)/2, 48);
        cancelBtn.backgroundColor = RGBColor(0xf1f3f7);
        [cancelBtn rounded:24];
        [self.bgView addSubview:cancelBtn];
        
        UIButton *sureBtn = [FControlTool createButton:@"确定" font:[UIFont fontWithSize:18] textColor:UIColor.whiteColor target:self sel:@selector(sureBtnAction)];
        sureBtn.frame = CGRectMake(cancelBtn.right + 9, self.bgView.height - 93 , (kScreenWidth - 41)/2, 48);
        sureBtn.backgroundColor = kMainColor;
        [sureBtn rounded:24];
        [self.bgView addSubview:sureBtn];
        
        self.dataList = [FDataTool getTransactionTypeDictionary];
        [self.bgView addSubview:self.collectionView];
    }
    return self;
}

- (void)closeBtnAction{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)sureBtnAction{
    if (self.selectBlock) {
        self.selectBlock([[self.dataList objectAtIndex:self.selectIndex][@"type"] integerValue]);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FBillingFilterItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FBillingFilterItemCell class]) forIndexPath:indexPath];
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.row][@"title"];
    if (self.selectIndex == indexPath.row) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex == indexPath.row) {
        return;
    }
    FBillingFilterItemCell *cell = (FBillingFilterItemCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0]];
    cell.isSelected = NO;
    
    FBillingFilterItemCell *selectCell = (FBillingFilterItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    selectCell.isSelected = YES;
    
    self.selectIndex = indexPath.row;
    
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((kScreenWidth - 32 - 22)/3, 43);
        layout.minimumLineSpacing = 11;
        layout.minimumInteritemSpacing = 11;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 327) collectionViewLayout:layout];
        [_collectionView registerClass:[FBillingFilterItemCell class] forCellWithReuseIdentifier:NSStringFromClass([FBillingFilterItemCell class])];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    if (!CGRectContainsPoint(self.bgView.frame, [touch locationInView:self])) {
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
