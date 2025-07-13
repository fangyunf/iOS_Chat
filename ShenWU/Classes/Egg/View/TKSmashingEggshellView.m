//
//  TKSmashingEggshellView.m
//  ShenWU
//
//  Created by Amy on 2024/8/10.
//

#import "TKSmashingEggshellView.h"
#import "TKSmashingActionView.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "TKEggListModel.h"
@interface TKSmashingEggshellView ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *icnImgView;
@property(nonatomic, strong) UIButton *smashingBtn;
@property(nonatomic, strong) NSArray *dataList;
@property(nonatomic, strong) TKSmashingActionView *actionView;
@end

@implementation TKSmashingEggshellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [FControlTool createLabel:@"小银子发放了\n2个388彩蛋" textColor:RGBColor(0xAB4CAF) font:[UIFont boldFontWithSize:7]];
        self.titleLabel.frame = CGRectMake(0, 0, self.width, 25);
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.icnImgView = [[UIImageView alloc] init];
        self.icnImgView.frame = CGRectMake((self.width - 46)/2, self.titleLabel.bottom+3, 46, 64);
        self.icnImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.icnImgView.layer.masksToBounds = YES;
        self.icnImgView.image = [UIImage imageNamed:@"icn_msg_egg"];
        [self addSubview:self.icnImgView];
        
        FLAnimatedImageView *gifImageView = [[FLAnimatedImageView alloc] init];
        
        gifImageView.contentMode = UIViewContentModeScaleToFill;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"小彩蛋" ofType:@"gif"];
        NSData *imageData = [NSData dataWithContentsOfFile:path];
        gifImageView.animationRepeatCount = 1;
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:imageData];
        gifImageView.frame = CGRectMake((self.width - 46)/2, self.titleLabel.bottom+3, 46, 64);
        gifImageView.animatedImage = image;
        
        [self addSubview:gifImageView];
        
        self.smashingBtn = [FControlTool createButton:@"砸蛋" font:[UIFont boldFontWithSize:10] textColor:UIColor.whiteColor target:self sel:@selector(smashingBtnAction)];
        [self.smashingBtn setBackgroundImage:[UIImage imageNamed:@"bg_msg_smashing"] forState:UIControlStateNormal];
        self.smashingBtn.frame = CGRectMake((self.width - 47)/2, gifImageView.bottom+10, 47, 17);
        [self addSubview:self.smashingBtn];
        
        UITapGestureRecognizer *smashingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showEggDetail)];
        [self addGestureRecognizer:smashingTap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(crackOpenEggAction:) name:CrackOpenEgg object:nil];
    }
    return self;
}

- (void)showEggDetail{
    @weakify(self);
    self.actionView = [[TKSmashingActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) isSuccess:NO];
    [self.actionView refreshViewWithData:self.dataList.firstObject];
    self.actionView.clickOnCloseBtn = ^{
        weak_self.actionView = nil;
    };
    [[FControlTool keyWindow] addSubview:self.actionView];
}

- (void)crackOpenEggAction:(NSNotification*)noti{
    if (self.actionView) {
        [self.actionView removeTimer];
        [self.actionView removeFromSuperview];
        self.actionView = nil;
    }
    
    NSDictionary *dict = noti.object;
    self.actionView = [[TKSmashingActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) isSuccess:YES];
    [self.actionView refreshSuccessViewWithData:dict];
    [[FControlTool keyWindow] addSubview:self.actionView];
}

- (void)smashingBtnAction{
//    [[FMessageManager sharedManager] smashingEgg];
}

- (void)refreshViewWithData:(NSArray*)data{
    self.dataList = data;
    NSInteger price = 0;
    for (TKEggListItemModel *model in data) {
        price += model.amount;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"发放了%ld个彩蛋\n共%ld元",data.count,price/100];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
