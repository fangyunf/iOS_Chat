//
//  SWOrderViewController.m
//  ShenWU
//
//  Created by Amy on 2024/11/8.
//

#import "SWOrderViewController.h"
#import "SWAddressManageViewController.h"
@interface SWOrderViewController ()
@property(nonatomic, strong) UILabel *namePhoneLabel;
@property(nonatomic, strong) UILabel *addressLabel;
@property(nonatomic, strong) UILabel *numberLabel;
@property(nonatomic, assign) NSInteger number;
@property(nonatomic, assign) NSInteger price;
@property(nonatomic, strong) UIButton *balanceBtn;
@property(nonatomic, strong) UIButton *wechaBtn;
@property(nonatomic, strong) UIButton *balanceSelectBtn;
@property(nonatomic, strong) UIButton *wechatSelectBtn;
@property(nonatomic, strong) UILabel *totalPriceLabel;
@end

@implementation SWOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交订单";
    
    self.number = 1;
    
    NSString *priceStr = self.productData[@"price"];
    self.price = [[priceStr stringByReplacingOccurrencesOfString:@"¥" withString:@""] integerValue];
    
    
    self.view.backgroundColor = RGBColor(0xF0F0F0);
    
    UIView *addressBgView = [[UIView alloc] init];
    addressBgView.frame = CGRectMake(0, kTopHeight+10, kScreenWidth, 60);
    addressBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addressBgView];
    
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapAction)];
    [addressBgView addGestureRecognizer:addressTap];
    
    UILabel *addressTitleLabel = [FControlTool createLabel:@"收货地址" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    addressTitleLabel.frame = CGRectMake(15, 0, 60, 60);
    [addressBgView addSubview:addressTitleLabel];
    
    UIImageView *addressImgView = [FControlTool createImageView];
    addressImgView.frame = CGRectMake(addressTitleLabel.right+3, 23, 12, 14);
    addressImgView.image = [UIImage imageNamed:@"weizhi"];
    [addressBgView addSubview:addressImgView];
    
    UIImageView *arrowImgView = [FControlTool createImageView];
    arrowImgView.frame = CGRectMake(addressBgView.width - 21, 25, 6, 10);
    arrowImgView.image = [UIImage imageNamed:@"icn_order_arrow"];
    [addressBgView addSubview:arrowImgView];
    
    self.namePhoneLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
    self.namePhoneLabel.frame = CGRectMake(addressImgView.right+8, 14, arrowImgView.left - (addressImgView.right+16), 14);
    [addressBgView addSubview:self.namePhoneLabel];
    
    self.addressLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
    self.addressLabel.frame = CGRectMake(addressImgView.right+8, self.namePhoneLabel.bottom+10, arrowImgView.left - (addressImgView.right+16), 14);
    [addressBgView addSubview:self.addressLabel];
    
    
    UIImageView *productImgView = [FControlTool createImageView];
    productImgView.frame = CGRectMake(12, addressBgView.bottom+18, 111, 111);
    [productImgView rounded:6];
    [productImgView sd_setImageWithURL:[NSURL URLWithString:self.productData[@"image"]]];
    [self.view addSubview:productImgView];
    
    UILabel *productNameLabel = [FControlTool createLabel:self.productData[@"name"] textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    productNameLabel.frame = CGRectMake(productImgView.right+9, productImgView.top+21, arrowImgView.left - (productImgView.right+16), 14);
    [self.view addSubview:productNameLabel];
    
    UILabel *productPriceLabel = [FControlTool createLabel:self.productData[@"price"] textColor:RGBColor(0xC80000) font:[UIFont boldFontWithSize:14]];
    productPriceLabel.frame = CGRectMake(productImgView.right+9, productNameLabel.bottom+15, arrowImgView.left - (productImgView.right+16), 14);
    [self.view addSubview:productPriceLabel];
    
    UIButton *deleteBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_jian"] target:self sel:@selector(deleteBtnAction)];
    deleteBtn.frame = CGRectMake(kScreenWidth - 18 - 71, productImgView.top+37, 18, 18);
    [self.view addSubview:deleteBtn];
    
    UIButton *addBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_jia"] target:self sel:@selector(addBtnAction)];
    addBtn.frame = CGRectMake(kScreenWidth - 18 - 15, productImgView.top+37, 18, 18);
    [self.view addSubview:addBtn];
    
    self.numberLabel = [FControlTool createLabel:[NSString stringWithFormat:@"%ld",self.number] textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
    self.numberLabel.frame = CGRectMake(deleteBtn.right, productImgView.top+37, addBtn.left - deleteBtn.right, 18);
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.numberLabel];
    
    UILabel *methodLabel = [FControlTool createLabel:@"支付方式" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:14]];
    methodLabel.frame = CGRectMake(16, productImgView.bottom+25, kScreenWidth - 32, 14);
    [self.view addSubview:methodLabel];
    
    self.balanceBtn = [FControlTool createButton:@"" font:[UIFont fontWithSize:12] textColor:UIColor.blackColor target:self sel:@selector(balanceBtnAction)];
    self.balanceBtn.frame = CGRectMake(0, methodLabel.bottom+11, kScreenWidth, 36);
    [self.view addSubview:self.balanceBtn];
    
    self.balanceSelectBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_order_unselect"] target:self sel:@selector(balanceBtnAction)];
    self.balanceSelectBtn.frame = CGRectMake(kScreenWidth - 31, 10, 16, 16);
    [self.balanceSelectBtn setImage:[UIImage imageNamed:@"icn_order_select"] forState:UIControlStateSelected];
    self.balanceSelectBtn.selected = YES;
    [self.balanceBtn addSubview:self.balanceSelectBtn];
    
    UIImageView *balanceImgView = [FControlTool createImageView];
    balanceImgView.frame = CGRectMake(16, 10, 15, 16);
    balanceImgView.image = [UIImage imageNamed:@"icn_order_balance"];
    [self.balanceBtn addSubview:balanceImgView];
    
    UILabel *balanceLabel = [FControlTool createLabel:@"余额支付" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
    balanceLabel.frame = CGRectMake(balanceImgView.right+5, 0, kScreenWidth/2, 36);
    [self.balanceBtn addSubview:balanceLabel];
    
    self.wechaBtn = [FControlTool createButton:@"" font:[UIFont fontWithSize:12] textColor:UIColor.blackColor target:self sel:@selector(wechaBtnAction)];
    self.wechaBtn.frame = CGRectMake(0, self.balanceBtn.bottom, kScreenWidth, 36);
    [self.view addSubview:self.wechaBtn];
    
    self.wechatSelectBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_order_unselect"] target:self sel:@selector(wechaBtnAction)];
    self.wechatSelectBtn.frame = CGRectMake(kScreenWidth - 31, 10, 16, 16);
    [self.wechatSelectBtn setImage:[UIImage imageNamed:@"icn_order_select"] forState:UIControlStateSelected];
    [self.wechaBtn addSubview:self.wechatSelectBtn];
    
    UIImageView *wechatImgView = [FControlTool createImageView];
    wechatImgView.frame = CGRectMake(16, 10, 15, 16);
    wechatImgView.image = [UIImage imageNamed:@"icn_order_wechat"];
    [self.wechaBtn addSubview:wechatImgView];
    
    UILabel *wechatLabel = [FControlTool createLabel:@"微信支付" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
    wechatLabel.frame = CGRectMake(balanceImgView.right+5, 0, kScreenWidth/2, 36);
    [self.wechaBtn addSubview:wechatLabel];
    
    UIView *payBgView = [[UIView alloc] init];
    payBgView.frame = CGRectMake(0, self.wechaBtn.bottom+15, kScreenWidth, 50);
    payBgView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:payBgView];
    
    UILabel *totalLabel = [FControlTool createLabel:@"合计：" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
    totalLabel.frame = CGRectMake(16, 0, 45, 50);
    [payBgView addSubview:totalLabel];
    
    self.totalPriceLabel = [FControlTool createLabel:[NSString stringWithFormat:@"¥%ld",self.number*self.price] textColor:RGBColor(0xC80000) font:[UIFont boldFontWithSize:18]];
    self.totalPriceLabel.frame = CGRectMake(totalLabel.right, 0, 200, 50);
    [payBgView addSubview:self.totalPriceLabel];
    
    UIButton *payBtn = [FControlTool createButton:@"立即支付" font:[UIFont boldFontWithSize:15] textColor:UIColor.whiteColor target:self sel:@selector(payBtnAction)];
    payBtn.frame = CGRectMake(kScreenWidth - 166, 0, 166, 50);
    [payBtn rounded:25];
    payBtn.backgroundColor = RGBColor(0xB09964);
    [payBgView addSubview:payBtn];
}

- (void)addressTapAction{
    @weakify(self);
    SWAddressManageViewController *vc = [[SWAddressManageViewController alloc] init];
    vc.selectBlock = ^(SWAddressModel * _Nonnull model) {
        weak_self.namePhoneLabel.text = [NSString stringWithFormat:@"%@  %@",model.name,model.phone];
        weak_self.addressLabel.text = model.address;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteBtnAction{
    if (self.number == 1) {
        return;
    }
    self.number--;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.number];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%ld",self.number*self.price];
}

- (void)addBtnAction{
    self.number++;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.number];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%ld",self.number*self.price];
}

- (void)balanceBtnAction{
    self.wechatSelectBtn.selected = NO;
    self.balanceSelectBtn.selected = YES;
}

- (void)wechaBtnAction{
    self.wechatSelectBtn.selected = YES;
    self.balanceSelectBtn.selected = NO;
}

- (void)payBtnAction{
    if (self.namePhoneLabel.text.length == 0 || self.addressLabel.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择地址"];
        return;
    }
    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
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
