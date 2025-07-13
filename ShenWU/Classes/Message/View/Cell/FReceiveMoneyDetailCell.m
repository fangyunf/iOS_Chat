//
//  FReceiveMoneyDetailCell.m
//  Fiesta
//
//  Created by Amy on 2024/6/1.
//

#import "FReceiveMoneyDetailCell.h"

@interface FReceiveMoneyDetailCell ()
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *timeLabel;


@end

@implementation FReceiveMoneyDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake(16, 10, 39, 39);
        self.avatarImgView.layer.cornerRadius = 18.5;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImgView.image = [UIImage imageNamed:@"avatar_person"];
        [self.contentView addSubview:self.avatarImgView];
        
        self.nameLabel = [FControlTool createLabel:@"恭喜发财 大吉大利" textColor:UIColor.blackColor font:[UIFont fontWithSize:16]];
        self.nameLabel.frame = CGRectMake(self.avatarImgView.right+12, 10, kScreenWidth - (self.avatarImgView.right+98), 22);
        [self.contentView addSubview:self.nameLabel];
        
        self.timeLabel = [FControlTool createLabel:@"01-11   18:28:40" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:12]];
        self.timeLabel.frame = CGRectMake(self.avatarImgView.right+12, 32, kScreenWidth - (self.avatarImgView.right+98), 17);
        [self.contentView addSubview:self.timeLabel];
        
        self.moneyLabel = [FControlTool createLabel:@"88.88元" textColor:UIColor.blackColor font:[UIFont fontWithSize:16]];
        self.moneyLabel.frame = CGRectMake(self.avatarImgView.right+12, 10, kScreenWidth - (self.avatarImgView.right+28), 22);
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.moneyLabel];
        
        self.bestBtn = [FControlTool createButton:@"手气最佳" font:[UIFont boldFontWithSize:12] textColor:RGBColor(0xEBAD02)];
        self.bestBtn.frame = CGRectMake(kScreenWidth - 91, 32, 75, 17);
        [self.bestBtn setImage:[UIImage imageNamed:@"icn_best"] forState:UIControlStateNormal];
        [self.bestBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:4];
        self.bestBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.bestBtn];
    }
    return self;
}

- (void)refreshCellWithData:(FRedPacketUserModel*)data{
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    if([FDataTool isNull:data.remark]){
        self.nameLabel.text = data.name;
    }else{
        self.nameLabel.text = data.remark;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf元",data.amount/100.0];
    if (data.reciveTime.length == 0) {
        self.timeLabel.text = [FDataTool updataForNumberTimeYear:[NSString stringWithFormat:@"%ld",data.createTime.integerValue/1000] formatter:@"YYYY-MM-dd HH:mm:ss"];
    }else{
        self.timeLabel.text = [FDataTool updataForNumberTimeYear:[NSString stringWithFormat:@"%ld",data.reciveTime.integerValue/1000] formatter:@"YYYY-MM-dd HH:mm:ss"];
    }
    
    self.bestBtn.hidden = !data.isFirstGood;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
