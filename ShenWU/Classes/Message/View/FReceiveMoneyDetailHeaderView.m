//
//  FReceiveMoneyDetailHeaderView.m
//  Fiesta
//
//  Created by Amy on 2024/6/1.
//

#import "FReceiveMoneyDetailHeaderView.h"
#import "SWRedPacketRecordViewController.h"
#import "ShenWU-Swift.h"
@interface FReceiveMoneyDetailHeaderView ()
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, strong) UILabel *infoLabel;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UIButton *lookRecordBtn;
@property(nonatomic, strong) FRedPacketDetailModel *redPacketModel;
@end

@implementation FReceiveMoneyDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *title = @"";
        CGSize size = [title sizeForFont:[UIFont boldFontWithSize:18] size:CGSizeMake(kScreenWidth - 32 - 39, 25) mode:NSLineBreakByWordWrapping];
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:23]];
        self.titleLabel.frame = CGRectMake((kScreenWidth - 39 - size.width)/2+39, 146*kScale+16.5, size.width, 25);
        [self addSubview:self.titleLabel];
        
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake((kScreenWidth - 39 - size.width)/2, 146*kScale+19, 20, 20);
        self.avatarImgView.layer.cornerRadius = 10;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImgView.image = [UIImage imageNamed:@"avatar_person"];
        [self addSubview:self.avatarImgView];
        
        self.tipLabel = [FControlTool createLabel:@"恭喜发财 大吉大利" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
        self.tipLabel.frame = CGRectMake(16, self.avatarImgView.bottom+14, kScreenWidth - 32, 20);
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.tipLabel];
        
        self.moneyLabel = [FControlTool createLabel:@"" textColor:RGBColor(0xEB5644) font:[UIFont semiBoldFontWithSize:38]];
        self.moneyLabel.frame = CGRectMake(16, self.tipLabel.bottom+14, kScreenWidth - 32, 53);
        self.moneyLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.moneyLabel];
        
        self.lookRecordBtn = [FControlTool createButton:@"" font:[UIFont fontWithSize:14] textColor:RGBColor(0x999999) target:self sel:@selector(lookRecordBtnAction)];
        self.lookRecordBtn.frame = CGRectMake(0, self.moneyLabel.bottom+15, kScreenWidth, 17);
        [self.lookRecordBtn setImage:[UIImage imageNamed:@"icn_red_packet_arrow"] forState:UIControlStateNormal];
        [self.lookRecordBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:3];
        [self addSubview:self.lookRecordBtn];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = CGRectMake(0, self.lookRecordBtn.bottom+20, kScreenWidth, 10);
        self.lineView.backgroundColor = RGBColor(0xf6f6f6);
        [self addSubview:self.lineView];
        
        self.infoLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
        self.infoLabel.frame = CGRectMake(16, self.lineView.bottom+12, kScreenWidth - 32, 20);
        [self addSubview:self.infoLabel];
    }
    return self;
}

- (void)changeViewFrame:(NSString *)toUserId{
    NSString *title = [NSString stringWithFormat:@"%@发出的红包",self.redPacketModel.sendName];
    CGSize size = [title sizeForFont:[UIFont boldFontWithSize:23] size:CGSizeMake(kScreenWidth - 32 - 39, 25) mode:NSLineBreakByWordWrapping];
    
    self.tipLabel.text = @"恭喜发财 大吉大利";
    
    if (self.redPacketModel.redpacketType == 21 && ![toUserId isEqualToString:[FUserModel sharedUser].userID]) {
        self.titleLabel.frame = CGRectMake((kScreenWidth - 26 - size.width)/2+26, 146*kScale+16.5, size.width, 25);
        self.avatarImgView.frame = CGRectMake((kScreenWidth - 26 - size.width)/2, 146*kScale+19, 20, 20);
        self.tipLabel.frame = CGRectMake(16, self.avatarImgView.bottom+14, kScreenWidth - 32, 20);
        self.moneyLabel.frame = CGRectMake(16, self.tipLabel.bottom+14, kScreenWidth - 32, 53);
        self.moneyLabel.hidden = YES;
        self.infoLabel.frame = CGRectMake(16, self.avatarImgView.bottom+48, kScreenWidth - 32, 20);
        self.lookRecordBtn.hidden = YES;
        if (self.redPacketModel.vos.count == 0) {
            self.infoLabel.text = [NSString stringWithFormat:@"红包金额%.2lf元 等待对方领取",self.redPacketModel.sendAmount/100.0];
        }else{
            self.infoLabel.text = [NSString stringWithFormat:@"1个红包共%.2lf元",self.redPacketModel.sendAmount/100.0];
        }
    }else if(self.redPacketModel.redpacketType == 21){
        self.titleLabel.frame = CGRectMake((kScreenWidth - 26 - size.width)/2+26, 146*kScale+16.5, size.width, 25);
        self.avatarImgView.frame = CGRectMake((kScreenWidth - 26 - size.width)/2, 146*kScale+19, 20, 20);
        self.tipLabel.frame = CGRectMake(16, self.avatarImgView.bottom+3, kScreenWidth - 32, 20);
        self.moneyLabel.frame = CGRectMake(16, self.tipLabel.bottom+14, kScreenWidth - 32, 53);
        self.infoLabel.hidden = YES;
    }
    self.lineView.hidden = YES;
}

- (void)refreshViewWithData:(FRedPacketDetailModel*)model{
    self.redPacketModel = model;
    
    NSString *title = [NSString stringWithFormat:@"%@发出的红包",self.redPacketModel.sendName];
    CGSize size = [title sizeForFont:[UIFont boldFontWithSize:23] size:CGSizeMake(kScreenWidth - 32 - 39, 25) mode:NSLineBreakByWordWrapping];
    
    self.titleLabel.frame = CGRectMake((kScreenWidth - 26 - size.width)/2+26, 146*kScale+16.5, size.width, 25);
    self.avatarImgView.frame = CGRectMake((kScreenWidth - 26 - size.width)/2, 146*kScale+19, 20, 20);
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.sendAvatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    self.titleLabel.text = title;
    self.tipLabel.text = model.title;
    BOOL isEsixt = NO;
    for (FRedPacketUserModel *user in model.vos) {
        if ([user.userId isEqualToString:[FUserModel sharedUser].userID]) {
            model.reciveAmount = user.amount;
            isEsixt = YES;
            break;
        }
    }
    if (!isEsixt && model.vos.count == model.totalNum && model.type == 2) {
        self.moneyLabel.text = @"";
        [self.lookRecordBtn setTitle:@"查看记录" forState:UIControlStateNormal];
        [self.lookRecordBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:3];
        self.infoLabel.text = [NSString stringWithFormat:@"%@抢完 已领取%ld/%ld个 共%.2lf元",model.lootAll,model.vos.count,model.totalNum,model.sendAmount/100.0];
    }else{
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf",model.reciveAmount/100.0];
        [self.lookRecordBtn setTitle:@"已存入我的钱包，立即查看" forState:UIControlStateNormal];
        [self.lookRecordBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:3];
        if(model.vos.count == model.totalNum){
            
            self.infoLabel.text = [NSString stringWithFormat:@"%@抢完 已领取%ld/%ld个 共%.2lf元",model.lootAll,model.vos.count,model.totalNum,model.sendAmount/100.0];
        }else{
            self.infoLabel.text = [NSString stringWithFormat:@"已领取%ld/%ld个 共%.2lf元",model.vos.count,model.totalNum,model.sendAmount/100.0];
        }
        
    }
    if (self.customType == 22 && [self.fromUserId isEqualToString:[FUserModel sharedUser].userID]) {
        [self.lookRecordBtn setTitle:@"查看记录" forState:UIControlStateNormal];
        [self.lookRecordBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:3];
        self.moneyLabel.hidden = YES;
        if (self.redPacketModel.vos.count == 0) {
            self.infoLabel.text = [NSString stringWithFormat:@"红包金额%.2lf元 等待对方领取",self.redPacketModel.sendAmount/100.0];
        }else{
            self.infoLabel.text = [NSString stringWithFormat:@"1个红包共%.2lf元",self.redPacketModel.sendAmount/100.0];
        }
    }
}

- (void)refreshTransferViewWithData:(NSDictionary*)data{
    
    NSString *title = [NSString stringWithFormat:@"%@发起的转账",data[@"sendName"]];
    if ([data[@"fromUserId"] isEqualToString:[FUserModel sharedUser].userID]) {
        title = @"你发起的转账";
    }
    CGSize size = [title sizeForFont:[UIFont boldFontWithSize:23] size:CGSizeMake(kScreenWidth - 32 - 39, 25) mode:NSLineBreakByWordWrapping];
    
    self.titleLabel.frame = CGRectMake((kScreenWidth - size.width)/2, 146*kScale+16.5, size.width, 25);
    self.avatarImgView.hidden = YES;
    
    self.titleLabel.text = title;
   
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf",[data[@"amount"] integerValue]/100.0];
    if ([data[@"fromUserId"] isEqualToString:[FUserModel sharedUser].userID]) {
        self.tipLabel.text = data[@"title"];
        [self.lookRecordBtn setTitle:[NSString stringWithFormat:@"%@已收款",data[@"toUserName"]] forState:UIControlStateNormal];
    }else{
        if([data[@"title"] isEqualToString:@"你发起了一笔转账"]){
            self.tipLabel.text = @"你收到了一笔转账";
        }else{
            self.tipLabel.text = data[@"title"];
        }
        
        [self.lookRecordBtn setTitle:@"你已收款" forState:UIControlStateNormal];
    }
    
    [self.lookRecordBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:3];
    self.infoLabel.text = @"";
}

- (void)lookRecordBtnAction{
    SWRedPacketRecordViewController *vc = [[SWRedPacketRecordViewController alloc] init];
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
