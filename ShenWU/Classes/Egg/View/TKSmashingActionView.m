//
//  TKSmashingActionView.m
//  ShenWU
//
//  Created by Amy on 2024/8/10.
//

#import "TKSmashingActionView.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "TKSmashingSuccessView.h"
@interface TKSmashingActionView ()
@property(nonatomic, strong) UIView *actionView;
@property(nonatomic, strong) UIView *successView;
@property(nonatomic, strong) FLAnimatedImageView *successGifImageView;
@property(nonatomic, strong) FLAnimatedImage *successGifImage;
@property(nonatomic, strong) FLAnimatedImageView *clickGifImageView;
@property(nonatomic, strong) UIButton *smashingBtn;
@property(nonatomic, strong) UIView *progressBgView;;
@property(nonatomic, strong) UIView *progressView;;
@property(nonatomic, strong) YYLabel *tipLabel;
@property(nonatomic, strong) UILabel *sucesssTipLabel;
@property(nonatomic, strong) NSDictionary *sucesssData;
@property(nonatomic, strong) UILabel *refuelLabel;
@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) NSTimer *requestTimer;
@property(nonatomic, strong) TKEggListItemModel *itemModel;
@end

@implementation TKSmashingActionView

- (instancetype)initWithFrame:(CGRect)frame isSuccess:(BOOL)isSuccess
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.5);
        
        if (isSuccess) {
            [self initSuccessView];
            [self showSuccessView];
            if (self.requestTimer) {
                [self.requestTimer invalidate];
                self.requestTimer = nil;
            }
        }else{
            [self initActionView];
            
        }
        
        UIButton *closeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_smashing_close"] target:self sel:@selector(closeBtnAction)];
        closeBtn.frame = CGRectMake(kScreenWidth - 58*kScale, (kScreenHeight - 328*kScale)/2 - 50 - 79*kScale - 39*kScale, 24*kScale, 24*kScale);
        [self addSubview:closeBtn];
        
//        UIButton *closeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_smashing_close"] target:self sel:@selector(closeBtnAction)];
//        closeBtn.frame = CGRectMake(kScreenWidth - 58*kScale, (kScreenHeight - 328*kScale)/2 - 50 - 39*kScale, 24*kScale, 24*kScale);
//        [self addSubview:closeBtn];
//        
//        UIImageView *bgImgView = [[UIImageView alloc] init];
//        bgImgView.frame = CGRectMake((kScreenWidth - 374*kScale)/2, (kScreenHeight - 328*kScale)/2 - 50, 374*kScale, 328*kScale);
//        bgImgView.image = [UIImage imageNamed:@"bg_smashing"];
//        bgImgView.userInteractionEnabled = YES;
//        [self addSubview:bgImgView];
//        
//        UIImageView *eggImgView = [[UIImageView alloc] init];
//        eggImgView.frame = CGRectMake((bgImgView.width - 182*kScale)/2, 39*kScale, 182*kScale, 250*kScale);
//        eggImgView.image = [UIImage imageNamed:@"icn_smashing_egg"];
//        eggImgView.userInteractionEnabled = YES;
//        [bgImgView addSubview:eggImgView];
//        
        
    }
    return self;
}

- (void)initActionView{
    self.actionView = [[UIView alloc] init];
    self.actionView.frame = self.bounds;
    [self addSubview:self.actionView];
    
    self.clickGifImageView = [[FLAnimatedImageView alloc] init];
    self.clickGifImageView.contentMode = UIViewContentModeScaleToFill;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"点击按钮" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    self.clickGifImageView.animationRepeatCount = 1;
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:imageData];
    self.clickGifImageView.frame =  CGRectMake((kScreenWidth - image.size.width/2)/2, (kScreenHeight - image.size.height/2)/2-100, image.size.width/2, image.size.height/2);;
    self.clickGifImageView.animatedImage = image;
    self.clickGifImageView.userInteractionEnabled = YES;
    __weak  FLAnimatedImageView *weakImgView = self.clickGifImageView;
    self.clickGifImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
        NSLog(@"loopCountRemaining === :%ld",loopCountRemaining);
        [weakImgView stopAnimating];
    };
    
    [self.actionView addSubview:self.clickGifImageView];
    
    FLAnimatedImageView *smashGifImageView = [[FLAnimatedImageView alloc] init];
    
    smashGifImageView.contentMode = UIViewContentModeScaleToFill;
    NSString *smashPath = [[NSBundle mainBundle] pathForResource:@"砸蛋" ofType:@"gif"];
    NSData *smashImageData = [NSData dataWithContentsOfFile:smashPath];
    smashGifImageView.animationRepeatCount = 1;
    FLAnimatedImage *smashImage = [FLAnimatedImage animatedImageWithGIFData:smashImageData];
    smashGifImageView.frame =  CGRectMake((kScreenWidth - smashImage.size.width/2)/2, (kScreenHeight - smashImage.size.height/2)/2-100, smashImage.size.width/2, smashImage.size.height/2);
    smashGifImageView.animatedImage = smashImage;
    smashGifImageView.userInteractionEnabled = YES;
    [self.actionView addSubview:smashGifImageView];
    
    self.refuelLabel = [FControlTool createLabel:@"" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:14]];
    self.refuelLabel.frame = CGRectMake(36, kScreenHeight/2+123, kScreenWidth - 72, 17);
    [self.actionView addSubview:self.refuelLabel];
    
    self.progressLabel = [FControlTool createLabel:@"0.00%" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:14]];
    self.progressLabel.frame = CGRectMake(36, kScreenHeight/2+123, kScreenWidth - 72, 17);
    self.progressLabel.textAlignment = NSTextAlignmentRight;
    [self.actionView addSubview:self.progressLabel];
    
    self.progressBgView = [[UIView alloc] init];
    self.progressBgView.frame = CGRectMake(36, kScreenHeight/2+150, kScreenWidth - 72, 10);
    self.progressBgView.backgroundColor = RGBAlphaColor(0xF06AF9, 0.2);
    self.progressBgView.layer.cornerRadius = 5;
    self.progressBgView.layer.masksToBounds = YES;
    [self.actionView addSubview:self.progressBgView];
    
    self.progressView = [[UIView alloc] init];
    self.progressView.frame = CGRectMake(0, 0, 0, 10);
    self.progressView.backgroundColor = RGBColor(0xF06AF9);
    self.progressView.layer.cornerRadius = 5;
    self.progressView.layer.masksToBounds = YES;
    [self.progressBgView addSubview:self.progressView];
    
//    FLAnimatedImageView *progressGifImageView = [[FLAnimatedImageView alloc] init];
//    
//    progressGifImageView.contentMode = UIViewContentModeScaleToFill;
//    NSString *progressPath = [[NSBundle mainBundle] pathForResource:@"进度条" ofType:@"gif"];
//    NSData *progressImageData = [NSData dataWithContentsOfFile:progressPath];
//    progressGifImageView.animationRepeatCount = 1;
//    FLAnimatedImage *progressImage = [FLAnimatedImage animatedImageWithGIFData:progressImageData];
//    progressGifImageView.frame = CGRectMake((kScreenWidth - progressImage.size.width/2)/2, (kScreenHeight - progressImage.size.height/2)/2, progressImage.size.width/2, progressImage.size.height/2);;
//    progressGifImageView.animatedImage = progressImage;
//    progressGifImageView.userInteractionEnabled = YES;
//    [self.actionView addSubview:progressGifImageView];
    
    NSString *smashingBtnStr = @"砸蛋+1";
    if ([FUserModel sharedUser].hy) {
        smashingBtnStr = @"砸蛋+2";
    }
    self.smashingBtn = [FControlTool createButton:smashingBtnStr font:[UIFont boldFontWithSize:20] textColor:UIColor.whiteColor target:self sel:@selector(smashingBtnAction)];
    self.smashingBtn.userInteractionEnabled = NO;
    self.smashingBtn.frame = CGRectMake((self.width - 145*kScale)/2, smashGifImageView.bottom - 55*kScale, 145*kScale, 54*kScale);
    [self.smashingBtn setBackgroundImage:[UIImage imageNamed:@"icn_smashing_btn"] forState:UIControlStateNormal];
    [self.actionView addSubview:self.smashingBtn];
    
    NSString * tipText = @"砸中即可获得388元余额";
    NSMutableAttributedString * tipAtt = [[NSMutableAttributedString alloc] initWithString:tipText];
    tipAtt.lineSpacing = 0;
    tipAtt.color = UIColor.whiteColor;
    tipAtt.font = [UIFont fontWithSize:12];
    NSRange range = [tipText rangeOfString:@"388"];
    [tipAtt setColor:[UIColor redColor] range:range];
    
    self.tipLabel = [[YYLabel alloc] init];
    self.tipLabel.frame = CGRectMake(15, self.smashingBtn.bottom+10, kScreenWidth - 30, 16);
    self.tipLabel.font = [UIFont fontWithSize:12];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.userInteractionEnabled = YES;
    self.tipLabel.attributedText = tipAtt;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.actionView addSubview:self.tipLabel];
    
    if (![FUserModel sharedUser].hy) {
        NSString * vipText = @"开通VIP更有机会砸中彩蛋哦  去开通";
        NSMutableAttributedString * vipAtt = [[NSMutableAttributedString alloc] initWithString:vipText];
        vipAtt.lineSpacing = 0;
        vipAtt.color = UIColor.whiteColor;
        vipAtt.font = [UIFont fontWithSize:12];
        NSRange vipRange = [vipText rangeOfString:@"去开通"];
        [vipAtt setColor:[UIColor redColor] range:vipRange];
        @weakify(self);
        [vipAtt setTextHighlightRange:vipRange color:[UIColor redColor] backgroundColor:UIColor.clearColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [weak_self buyVip];
        }];
        
        YYLabel *vipTipLabel = [[YYLabel alloc] init];
        vipTipLabel.frame = CGRectMake(15, self.tipLabel.bottom+3, kScreenWidth - 30, 16);
        vipTipLabel.font = [UIFont fontWithSize:12];
        vipTipLabel.numberOfLines = 0;
        vipTipLabel.userInteractionEnabled = YES;
        vipTipLabel.attributedText = vipAtt;
        vipTipLabel.textAlignment = NSTextAlignmentCenter;
        [self.actionView addSubview:vipTipLabel];
    }
    
    [self initSuccessView];
    
    [self updateLabel];
}

- (void)initSuccessView{
    self.successView = [[UIView alloc] init];
    self.successView.frame = self.bounds;
    self.successView.hidden = YES;
    [self addSubview:self.successView];
    
    self.successGifImageView = [[FLAnimatedImageView alloc] init];
    
    self.successGifImageView.contentMode = UIViewContentModeScaleToFill;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"砸中彩蛋" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    self.successGifImageView.animationRepeatCount = 1;
    self.successGifImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
    
    
    [self.successView addSubview:self.successGifImageView];
    [self.successGifImageView stopAnimating];
}

- (void)showSuccessView{
    [self removeTimer];
    [self.actionView removeFromSuperview];
    self.successView.hidden = NO;
    self.successGifImageView.frame = CGRectMake((kScreenWidth - self.successGifImage.size.width/2)/2, (kScreenHeight - self.successGifImage.size.height/2)/2-100, self.successGifImage.size.width/2, self.successGifImage.size.height/2);
    self.successGifImageView.animatedImage = self.successGifImage;

    __weak  FLAnimatedImageView *weakImgView = self.successGifImageView;
    @weakify(self)
    self.successGifImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
        NSLog(@"loopCountRemaining === :%ld",loopCountRemaining);
        [weakImgView stopAnimating];
        [weak_self showSuccessDetailView];
    };
    [self.successGifImageView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UILabel *tipLabel = [FControlTool createLabel:[NSString stringWithFormat:@"经过激烈角逐，恭喜%@中奖了！这是对%@的独一无二的才能和运气的肯定。幸运之神在您身边！！！",weak_self.sucesssData[@"name"],weak_self.sucesssData[@"name"]] textColor:UIColor.whiteColor font:[UIFont fontWithSize:14]];
        tipLabel.frame = CGRectMake(70, self.successGifImageView.height - 225, self.successGifImageView.width - 140, 90);
        tipLabel.numberOfLines = 0;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.successGifImageView addSubview:tipLabel];
    });
}

- (void)showSuccessDetailView{
    [self removeFromSuperview];
    if(![FDataTool isNull:self.sucesssData] && ![FDataTool isNull:self.sucesssData[@"userId"]] && [[NSString stringWithFormat:@"%@",self.sucesssData[@"userId"]] isEqualToString:[FUserModel sharedUser].userID]){
        TKSmashingSuccessView *view = [[TKSmashingSuccessView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [[FControlTool keyWindow] addSubview:view];
    }
    
}

- (void)updateLabel{
    CGFloat currentProgress = [FMessageManager sharedManager].progress*1.0/[FMessageManager sharedManager].totalProgress*100;
    if (currentProgress == 0) {
        self.refuelLabel.text = @"砸蛋时刻开始，大奖等着你";
    }else if (currentProgress > 0){
        self.refuelLabel.text = @"砸蛋进行时，你是最幸运的";
    }else if (currentProgress > 10){
        self.refuelLabel.text = @"你的努力看得见，彩蛋离你更近了";
    }else if (currentProgress > 20){
        self.refuelLabel.text = @"每次的突破，都是更近一步";
    }else if (currentProgress > 30){
        self.refuelLabel.text = @"坚持！！！你是最厉害的";
    }else if (currentProgress > 40){
        self.refuelLabel.text = @"这手速太快了吧！飞速前进";
    }else if (currentProgress > 50){
        self.refuelLabel.text = @"彩蛋在招手，加油";
    }else if (currentProgress > 60){
        self.refuelLabel.text = @"哎呀！你怎么有突破了呀！！！";
    }else if (currentProgress > 70){
        self.refuelLabel.text = @"你太快了！！别人都追不上了！";
    }else if (currentProgress > 80){
        self.refuelLabel.text = @"看见彩蛋了！赶快继续加油";
    }else if (currentProgress > 90){
        self.refuelLabel.text = @"努努力，还差一点，彩蛋在招手";
    }else if (currentProgress > 100){
        self.refuelLabel.text = @"恭喜恭喜，大奖属于你！！！";
    }
}

- (void)refreshViewWithData:(TKEggListItemModel *)data{
    self.itemModel = data;
    NSString * tipText = [NSString stringWithFormat:@"砸中即可获得%ld元余额",data.amount/100];
    NSMutableAttributedString * tipAtt = [[NSMutableAttributedString alloc] initWithString:tipText];
    tipAtt.lineSpacing = 0;
    tipAtt.color = UIColor.whiteColor;
    tipAtt.font = [UIFont fontWithSize:12];
    NSRange range = [tipText rangeOfString:[NSString stringWithFormat:@"%ld",data.amount/100]];
    [tipAtt setColor:[UIColor redColor] range:range];
    
    self.tipLabel.attributedText = tipAtt;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [self requestProgress];
    if (!self.requestTimer) {
        self.requestTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(requestProgress) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.requestTimer forMode:NSRunLoopCommonModes];
        [self.requestTimer fire];
    }
}

- (void)refreshSuccessViewWithData:(NSDictionary *)data{
    self.sucesssData = data;
    if (self.sucesssTipLabel) {
        
    }
}

- (void)closeBtnAction{
    if (self.clickOnCloseBtn) {
        self.clickOnCloseBtn();
    }
    [self removeTimer];
    [self removeFromSuperview];
    
}

- (void)removeTimer{
    if (self.requestTimer) {
        [self.requestTimer invalidate];
        self.requestTimer = nil;
    }
}

- (void)smashingBtnAction{
    [self.clickGifImageView startAnimating];
    __weak  FLAnimatedImageView *weakImgView = self.clickGifImageView;
    self.clickGifImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
        NSLog(@"loopCountRemaining === :%ld",loopCountRemaining);
        [weakImgView stopAnimating];
    };
    self.progressView.frame = CGRectMake(0, 0, self.progressBgView.width*([FMessageManager sharedManager].progress/[FMessageManager sharedManager].totalProgress), 10);
    self.progressLabel.text = [NSString stringWithFormat:@"%.2lf%%",([FMessageManager sharedManager].progress/[FMessageManager sharedManager].totalProgress*100)];
    [self updateLabel];
}

- (void)requestProgress{
    if (!self.actionView) {
        [self removeTimer];
    }
    @weakify(self)
    NSDictionary *params = @{@"fafId":self.itemModel.fafId};
    [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/caidaning" parameters:params success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            if (![FDataTool isNull:response] && ![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"caidanLs"]]) {
                [FMessageManager sharedManager].totalProgress = [response[@"data"][@"caidanLs"] integerValue];
                [FMessageManager sharedManager].progress = [response[@"data"][@"groupLs"] integerValue];
                [weak_self smashingBtnAction];
                [weak_self updateLabel];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)buyVip{
    [SVProgressHUD show];
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/huiYuanJia" parameters:[NSDictionary new] success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            if (![FDataTool isNull:response] && ![FDataTool isNull:response[@"data"]] && ![FDataTool isNull:response[@"data"][@"price"]]) {
                NSInteger price = [response[@"data"][@"price"] integerValue];
                NSString *priceStr = [NSString stringWithFormat:@"%ld",price/100];
                [weak_self showVipBuyAlertWithPrice:priceStr];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)showVipBuyAlertWithPrice:(NSString*)price{
    @weakify(self)
    TKPaySucceseAlertView *view = [[TKPaySucceseAlertView alloc] initWithFrame:self.bounds bgImgStr:@"bg_comom_alert" title:[NSString stringWithFormat:@"即将支付%@元获得会员权益",price] des:@"成为会员后砸蛋中奖几率翻倍，更有机会获得彩蛋" btnStr:@"确定"];
    view.clickOnSureBtn = ^{
        
        [FPayPasswordView showPayPrice:@"88" success:^(NSString * _Nonnull password) {
            [weak_self requestBuy:password];
        }];
    };
    [[FControlTool keyWindow] addSubview:view];
}

- (void)requestBuy:(NSString *)password{
    @weakify(self)
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/caidan/gmHuiYuan" parameters:@{} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            [weak_self showVipPaySuccess];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)showVipPaySuccess{
    [FUserModel sharedUser].hy = YES;
    [self.smashingBtn setTitle:@"砸蛋+2" forState:UIControlStateNormal];
    TKPaySucceseAlertView *view = [[TKPaySucceseAlertView alloc] initWithFrame:self.bounds bgImgStr:@"bg_pay_sucess" title:@"恭喜你！购买会员成功" des:@"" btnStr:@"确定"];
    view.clickOnSureBtn = ^{

    };
    [[FControlTool keyWindow] addSubview:view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
