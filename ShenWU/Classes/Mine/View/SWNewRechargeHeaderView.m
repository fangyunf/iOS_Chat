//
//  SWNewRechargeHeaderView.m
//  ShenWU
//
//  Created by Amy on 2025/2/12.
//

#import "SWNewRechargeHeaderView.h"
#import "SWNewRechargeValueCell.h"
@interface SWNewRechargeHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, assign) NSInteger selectIndex;
@property(nonatomic, strong) UITextField *moneyTextField;
@end

@implementation SWNewRechargeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectIndex = -1;
        
        UILabel *titleLabel = [FControlTool createLabel:@"购买数量" textColor:UIColor.blackColor font:[UIFont fontWithSize:15]];
        titleLabel.frame = CGRectMake(0, 15, 62, 20);
        [self addSubview:titleLabel];
        
        UIImageView *coinImgView = [FControlTool createImageView];
        coinImgView.frame = CGRectMake(titleLabel.right+4, 15, 19, 20);
        coinImgView.image = [UIImage imageNamed:@"icn_recharge_coin"];
        [self addSubview:coinImgView];
        
        self.dataList = [NSMutableArray arrayWithObjects:@"100",@"300",@"500",@"1000",@"2000",@"3000", nil];
        
        [self addSubview:self.collectionView];
        
        UIView *moneyView = [[UIView alloc] init];
        moneyView.frame = CGRectMake(0, self.collectionView.bottom+40, kScreenWidth-32, 56);
        moneyView.backgroundColor = RGBAlphaColor(0x0A7FFF, 0.08);
        [moneyView rounded:6];
        [self addSubview:moneyView];
        
        UILabel *moneyTitleLabel = [FControlTool createLabel:@"充值金额" textColor:UIColor.blackColor font:[UIFont fontWithSize:15]];
        moneyTitleLabel.frame = CGRectMake(27, 0, moneyView.width - 54, 56);
        [moneyView addSubview:moneyTitleLabel];
        
        self.moneyTextField = [[UITextField alloc] init];
        self.moneyTextField.frame = CGRectMake(moneyView.width - 225, 0, 200, 56);
        self.moneyTextField.textColor = RGBColor(0x333333);
        self.moneyTextField.placeholder = @"¥0.00";
        self.moneyTextField.delegate = self;
        self.moneyTextField.font = [UIFont boldFontWithSize:30];
        self.moneyTextField.textAlignment = NSTextAlignmentRight;
        self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [moneyView addSubview:self.moneyTextField];
        
        UILabel *methodLabel = [FControlTool createLabel:@"支付方式" textColor:UIColor.blackColor font:[UIFont fontWithSize:15]];
        methodLabel.frame = CGRectMake(0, moneyView.bottom+30, kScreenWidth-32 - 52, 15);
        [self addSubview:methodLabel];
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.selectIndex = -1;
    [self.collectionView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.moneyValue = textField.text;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWNewRechargeValueCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SWNewRechargeValueCell class]) forIndexPath:indexPath];
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
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
    SWNewRechargeValueCell *cell = (SWNewRechargeValueCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0]];
    cell.isSelected = NO;
    
    SWNewRechargeValueCell *selectCell = (SWNewRechargeValueCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    selectCell.isSelected = YES;
    
    self.selectIndex = indexPath.row;
    
    self.moneyValue = [self.dataList objectAtIndex:indexPath.row];
    self.moneyTextField.text = self.moneyValue;
//    if (self.selectBlock) {
//        self.selectBlock([[self.dataList objectAtIndex:indexPath.row][@"type"] integerValue]);
//    }
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(84, 35);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 48, kScreenWidth-32, 80) collectionViewLayout:layout];
        [_collectionView registerClass:[SWNewRechargeValueCell class] forCellWithReuseIdentifier:NSStringFromClass([SWNewRechargeValueCell class])];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
