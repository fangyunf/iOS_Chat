//
//  FBaseViewController.m
//  Fiesta
//
//  Created by Amy on 2024/5/23.
//

#import "FBaseViewController.h"

@interface FBaseViewController ()

@end

@implementation FBaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navTopView = [[UIImageView alloc] init];
    self.navTopView.frame = CGRectMake(0, 0, kScreenWidth, kTopHeight);
    self.navTopView.backgroundColor = UIColor.whiteColor;
    self.navTopView.hidden = NO;
    self.navTopView.image = [UIImage imageNamed:@"bg_nav_top"];
    self.navTopView.contentMode = UIViewContentModeScaleAspectFill;
    self.navTopView.userInteractionEnabled = YES;
    [self.view addSubview:self.navTopView];
    [self.navTopView sendSubviewToBack:self.view];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    _tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_tapGestureRecognizer];
    
}

- (void)setWhiteNavBack{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"icn_nav_withe_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *barBut = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barBut;
}

- (UIBarButtonItem *)getRightBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)selector{
    CGSize rightSize = [title sizeForFont:font size:CGSizeMake(200, 44) mode:NSLineBreakByWordWrapping];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, rightSize.width, 44);
    [rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    rightBtn.titleLabel.font = font;
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (UIBarButtonItem *)getRightBarButtonItem:(NSString *)imgstr target:(id)target action:(SEL)selector
{
    UIImage *img = [UIImage imageNamed:imgstr];
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setImage:img forState:UIControlStateNormal];
    if(@available(iOS 11.0, *)){
        rightBtn.frame = CGRectMake(0, 0, 44 , 44);
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 44-img.size.width, 0, 0)];
    }else{
        rightBtn.frame = CGRectMake(0, 0, img.size.width , img.size.height);
    }
    [rightBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItemBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    return rightItemBtn;
}

- (UIBarButtonItem *)getLeftBarButtonItem:(NSString *)imgstr target:(id)target action:(SEL)selector
{
    UIImage *img = [UIImage imageNamed:imgstr];
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setImage:img forState:UIControlStateNormal];
    if(@available(iOS 11.0, *)){
        rightBtn.frame = CGRectMake(0, 0, 44 , 44);
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 44-img.size.width)];
    }else{
        rightBtn.frame = CGRectMake(0, 0, img.size.width , img.size.height);
    }
    [rightBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItemBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    return rightItemBtn;
}

- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 隐藏键盘相关
- (void)keyboardHide:(id _Nullable)sender
{
    [self.view endEditing:YES];
}

- (void)removeKeyHideTap
{
    [self.view removeGestureRecognizer:_tapGestureRecognizer];
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
