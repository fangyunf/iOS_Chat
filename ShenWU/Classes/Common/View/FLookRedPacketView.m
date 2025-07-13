//
//  FRedPacketView.m
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

#import "FLookRedPacketView.h"
#import "ShenWU-Swift.h"
#import "FRedPacketDetailModel.h"
#import "FReceiveMoneyDetailViewController.h"
@interface FLookRedPacketView ()
@property(nonatomic, strong) UIImageView *bgImgView;
@property(nonatomic, strong) UIButton *lookDetailBtn;
@property(nonatomic, strong) UIButton *openBtn;
@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) FRedPacketMessageModel *redPacketModel;

@property(nonatomic, strong) UILabel *desLabel;
@property(nonatomic, strong) NSDictionary *responseDict;
@property(nonatomic, assign) BOOL isRequesting;
@property (nonatomic, copy) void (^successBlock)(NSDictionary *success);
@end

@implementation FLookRedPacketView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.5);
        
        self.bgImgView = [[UIImageView alloc] init];
        self.bgImgView.frame = CGRectMake((kScreenWidth - 299)/2, (kScreenHeight - 423)/2, 299, 423);
        self.bgImgView.userInteractionEnabled = YES;
        [self addSubview:self.bgImgView];
        
        self.closeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_red_close"] target:self sel:@selector(closeBtnAction)];
        self.closeBtn.frame = CGRectMake((kScreenWidth - 31)/2, self.bgImgView.bottom+29, 31, 31);
        [self addSubview:self.closeBtn];
        
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake((self.bgImgView.width - 48)/2, 50, 20, 20);
        self.avatarImgView.layer.cornerRadius = 2;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.bgImgView addSubview:self.avatarImgView];
        
        self.nameLabel = [FControlTool createLabel:@"" textColor:RGBColor(0xFFEEAB) font:[UIFont fontWithSize:16]];
        self.nameLabel.frame = CGRectMake(self.avatarImgView.right+6, 50, self.bgImgView.width - 20, 20);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgImgView addSubview:self.nameLabel];
        
        self.desLabel = [FControlTool createLabel:@"恭喜发财 大吉大利" textColor:RGBColor(0xFFEBA3) font:[UIFont boldFontWithSize:22]];
        self.desLabel.frame = CGRectMake(10, self.nameLabel.bottom+16, self.bgImgView.width - 20, 30);
        self.desLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgImgView addSubview:self.desLabel];
        
        self.lookDetailBtn = [FControlTool createButton:@"查看领取详情 >>" font:[UIFont semiBoldFontWithSize:14] textColor:UIColor.whiteColor target:self sel:@selector(lookDetailBtnAction)];
        self.lookDetailBtn.frame = CGRectMake((self.bgImgView.width - 150)/2, self.bgImgView.height - 36, 150, 20);
//        [self.lookDetailBtn setImage:[UIImage imageNamed:@"icn_red_packet_arrow"] forState:UIControlStateNormal];
//        [self.lookDetailBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:8];
        [self.bgImgView addSubview:self.lookDetailBtn];
        
        self.openBtn = [[UIButton alloc] init];
        self.openBtn.frame = CGRectMake((self.bgImgView.width - 125)/2, 255, 125, 125);
//        self.openBtn.backgroundColor = RGBAlphaColor(0x000000, 0.2);
        [self.openBtn addTarget:self action:@selector(openBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgView addSubview:self.openBtn];
    }
    return self;
}



- (void)loadData:(NSDictionary*)data modelDict:(NSDictionary*)modelDict success:(void(^)(NSDictionary *response))success{
    self.successBlock = success;
    self.redPacketModel = [FRedPacketMessageModel modelWithDictionary:modelDict];
    self.responseDict = data;
    NSInteger mtype = [data[@"type"] integerValue];
    NSString *title = @"";
    if (mtype == 1) {
        if (self.redPacketModel.customType == 21) {
            self.type = RedPacketTypeExclusiveStart;
        }else{
            self.type = RedPacketTypeStart;
        }
        title = self.redPacketModel.title;
    }else if (mtype == 2) {
        if (self.redPacketModel.customType == 21) {
            self.type = RedPacketTypeExclusiveFinish;
            title = @"";
        }else{
            self.type = RedPacketTypeFinish;
            title = @"手慢了，红包已抢完";
        }
    }else if (mtype == 3) {
        if (self.redPacketModel.customType == 21) {
            self.type = RedPacketTypeExclusiveFinish;
        }else{
            self.type = RedPacketTypeFinish;
        }
        title = @"红包已退回";
    }
    NSString *nameStr = [NSString stringWithFormat:@"%@发的红包",self.redPacketModel.sendName];
    CGSize size = [nameStr sizeForFont:self.nameLabel.font size:CGSizeMake(self.bgImgView.width - 56, 20) mode:NSLineBreakByWordWrapping];
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.redPacketModel.sendAvatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@发的红包",self.redPacketModel.sendName];
    
    self.avatarImgView.frame = CGRectMake((self.bgImgView.width - 26 - size.width)/2, self.avatarImgView.top, 20, 20);
    self.nameLabel.frame = CGRectMake(self.avatarImgView.right+6, self.avatarImgView.top, size.width, 20);
    self.desLabel.text = title;
}

- (void)setType:(RedPacketStatus)type{
    _type = type;
    switch (type) {
        case RedPacketTypeStart:
            self.bgImgView.image = [UIImage imageNamed:@"bg_red_start"];
            self.lookDetailBtn.hidden = NO;
            self.lookDetailBtn.frame = CGRectMake((self.bgImgView.width - 150)/2, self.bgImgView.height - 36, 150, 20);
            self.openBtn.hidden = NO;
            break;
        case RedPacketTypeFinish:
            self.bgImgView.image = [UIImage imageNamed:@"bg_red_finish"];
            self.lookDetailBtn.hidden = NO;
            self.lookDetailBtn.frame = CGRectMake((self.bgImgView.width - 150)/2, self.bgImgView.height - 81, 150, 20);
            self.openBtn.hidden = YES;
            break;
        case RedPacketTypeExclusiveStart:
            self.bgImgView.image = [UIImage imageNamed:@"bg_s_red_start"];
            self.lookDetailBtn.frame = CGRectMake((self.bgImgView.width - 150)/2, self.bgImgView.height - 36, 150, 20);
            self.lookDetailBtn.hidden = NO;
            self.openBtn.hidden = NO;
            break;
        case RedPacketTypeExclusiveFinish:
            self.bgImgView.image = [UIImage imageNamed:@"bg_s_red_finish"];
            self.lookDetailBtn.frame = CGRectMake((self.bgImgView.width - 150)/2, self.bgImgView.height - 81, 150, 20);
            self.lookDetailBtn.hidden = NO;
            self.openBtn.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)closeBtnAction{
    [self removeFromSuperview];
}

- (void)lookDetailBtnAction{
    NSLog(@"lookDetailBtnAction");
    FReceiveMoneyDetailViewController *vc = [[FReceiveMoneyDetailViewController alloc] init];
    vc.redPacketDict = self.redPacketModel.modelToJSONObject;
    vc.isLook = YES;
    [[FControlTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    [self removeFromSuperview];
}

- (void)openBtnAction{
    if(self.isRequesting){
        return;
    }
    self.isRequesting = YES;
    NSString *requestUrl = @"";
    if (self.redPacketModel.customType == 21) {
        requestUrl = @"/red/reciveExclusiveRedpacket";
    }else if (self.redPacketModel.customType == 22) {
        requestUrl = @"/red/recivePersonRedpacket";
    }else if (self.redPacketModel.customType == 23) {
        requestUrl = @"/red/grab";
    }
    @weakify(self)
    [[FNetworkManager sharedManager] postRequestFromServer:requestUrl parameters:@{@"redpacketId":self.redPacketModel.redPacketId,@"createTime":self.redPacketModel.createTime} success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            self.successBlock(weak_self.responseDict);
            if (![FDataTool isNull:response[@"data"]]) {
                FRedPacketDetailModel *model = [FRedPacketDetailModel modelWithDictionary:response[@"data"]];
                BOOL isExist = NO;
                if (model.vos.count > 0) {
                    for (FRedPacketUserModel *userModel in model.vos) {
                        if ([[FUserModel sharedUser].userID isEqualToString:userModel.userId]) {
                            isExist = YES;
                        }
                    }
                }
                if (isExist) {
                    if ([requestUrl isEqualToString:@"/red/grab"]) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"receiveUserName"] = [FUserModel sharedUser].nickName;
                        dic[@"receiveUserId"] = [FUserModel sharedUser].userID;
                        dic[@"sendUserName"] = self.redPacketModel.sendName;
                        dic[@"sendUserId"] = self.redPacketModel.fromUserId;
                        [[FMessageManager sharedManager] sendTipMessage:[FDataTool convertToJsonData:dic] sessionId:self.sessionId type:2];
                    }else if ([requestUrl isEqualToString:@"/red/recivePersonRedpacket"]) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"receiveUserName"] = [FUserModel sharedUser].nickName;
                        dic[@"receiveUserId"] = [FUserModel sharedUser].userID;
                        dic[@"sendUserName"] = self.redPacketModel.sendName;
                        dic[@"sendUserId"] = self.redPacketModel.fromUserId;
                        [[FMessageManager sharedManager] sendTipMessage:[FDataTool convertToJsonData:dic] sessionId:self.sessionId type:1];
                    }
                }
            }
            
            [weak_self removeFromSuperview];
            self.isRequesting = NO;
        }else{
            self.isRequesting = NO;
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        self.isRequesting = NO;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
