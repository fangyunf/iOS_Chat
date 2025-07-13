//
//  TKReportViewController.m
//  ShenWU
//
//  Created by Amy on 2024/8/8.
//

#import "TKReportViewController.h"
#import "UITextView+Placeholder.h"
@interface TKReportViewController ()
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *idLabel;
@property(nonatomic, strong) UILabel *selectLabel;
@end

@implementation TKReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"投诉";
    self.view.backgroundColor = RGBColor(0xf2f2f2);
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - kTopHeight);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    UIView *infoBgView = [[UIView alloc] init];
    infoBgView.frame = CGRectMake(15, 52, kScreenWidth - 30, 117);
    infoBgView.backgroundColor = [UIColor whiteColor];
    infoBgView.layer.cornerRadius = 5;
    infoBgView.layer.masksToBounds = YES;
    [self.scrollView addSubview:infoBgView];
    
    self.avatarImgView = [[UIImageView alloc] init];
    self.avatarImgView.frame = CGRectMake(32, 20, 80, 80);
    self.avatarImgView.layer.cornerRadius = 5;
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImgView.userInteractionEnabled = YES;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    [self.scrollView addSubview:self.avatarImgView];
    
    CGSize size = [self.model.name sizeForFont:[UIFont boldFontWithSize:18] size:CGSizeMake(infoBgView.width - 102, 20) mode:NSLineBreakByWordWrapping];
    
    self.nameLabel = [FControlTool createLabel:self.model.name textColor:UIColor.blackColor font:[UIFont boldFontWithSize:18]];
    self.nameLabel.frame = CGRectMake(16, 56, size.width, 21);
    [infoBgView addSubview:self.nameLabel];
    
    
    CGSize idSize = [[NSString stringWithFormat:@"ID:%@",self.model.memberCode] sizeForFont:[UIFont fontWithSize:12] size:CGSizeMake(infoBgView.width - 102, 15) mode:NSLineBreakByWordWrapping];
    
    self.idLabel = [FControlTool createLabel:[NSString stringWithFormat:@"ID:%@",self.model.memberCode] textColor:RGBColor(0x666666) font:[UIFont fontWithSize:12]];
    self.idLabel.frame = CGRectMake(16, self.nameLabel.bottom+5, idSize.width+16+40, 15);
    self.idLabel.layer.masksToBounds = YES;
    [infoBgView addSubview:self.idLabel];
    
    UIView *selectBgView = [[UIView alloc] init];
    selectBgView.frame = CGRectMake(15, infoBgView.bottom+13, kScreenWidth - 30, 117);
    selectBgView.backgroundColor = [UIColor whiteColor];
    selectBgView.layer.cornerRadius = 5;
    selectBgView.layer.masksToBounds = YES;
    [self.scrollView addSubview:selectBgView];
    
    UILabel *selectTitleLabel = [FControlTool createLabel:@"投诉类型" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    selectTitleLabel.frame = CGRectMake(16, 17, selectBgView.width - 32, 18);
    [selectBgView addSubview:selectTitleLabel];
    
    self.selectLabel = [FControlTool createLabel:@"请选择" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    self.selectLabel.frame = CGRectMake(16, 55, selectBgView.width - 32, 35);
    [selectBgView addSubview:self.selectLabel];
    
    UIImageView *selectArrowImgView = [[UIImageView alloc] init];
    selectArrowImgView.frame = CGRectMake(selectBgView.width - 33, 55+8, 21, 20);
    selectArrowImgView.image = [UIImage imageNamed:@"icn_mine_arrow"];
    [selectBgView addSubview:selectArrowImgView];
    
    UIView *inputBgView = [[UIView alloc] init];
    inputBgView.frame = CGRectMake(15, selectBgView.bottom+13, kScreenWidth - 30, 155);
    inputBgView.backgroundColor = [UIColor whiteColor];
    inputBgView.layer.cornerRadius = 5;
    inputBgView.layer.masksToBounds = YES;
    [self.scrollView addSubview:inputBgView];
    
    UILabel *inputTitleLabel = [FControlTool createLabel:@"投诉内容" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    inputTitleLabel.frame = CGRectMake(16, 17, inputBgView.width - 32, 18);
    [inputBgView addSubview:inputTitleLabel];
    
    UITextView *inputTextView = [[UITextView alloc] init];
    inputTextView.frame = CGRectMake(16, inputTitleLabel.bottom+21, inputBgView.width - 32, 74);
    inputTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    inputTextView.placeholder = @"请详细填写，已确保投诉能够受理";
    inputTextView.placeholderColor = RGBColor(0x999999);
    inputTextView.placeholderLabel.font = [UIFont boldFontWithSize:14];
    inputTextView.font = [UIFont boldFontWithSize:14];
    inputTextView.textColor = RGBColor(0x333333);
    inputTextView.backgroundColor = UIColor.whiteColor;
    [inputBgView addSubview:inputTextView];
    
    
    UIView *imageBgView = [[UIView alloc] init];
    imageBgView.frame = CGRectMake(15, inputBgView.bottom+13, kScreenWidth - 30, 184);
    imageBgView.backgroundColor = [UIColor whiteColor];
    imageBgView.layer.cornerRadius = 5;
    imageBgView.layer.masksToBounds = YES;
    [self.scrollView addSubview:imageBgView];
    
    UILabel *imageTitleLabel = [FControlTool createLabel:@"其它佐证" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
    imageTitleLabel.frame = CGRectMake(16, 17, inputBgView.width - 32, 18);
    [imageBgView addSubview:imageTitleLabel];
    
    
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
