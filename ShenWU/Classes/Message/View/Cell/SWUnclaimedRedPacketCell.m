//
//  SWUnclaimedRedPacketCell.m
//  ShenWU
//
//  Created by Amy on 2025/3/27.
//

#import "SWUnclaimedRedPacketCell.h"

@interface SWUnclaimedRedPacketCell ()
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@end

@implementation SWUnclaimedRedPacketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgImgView = [FControlTool createImageView];
        self.bgImgView.frame = CGRectMake((kScreenWidth - 343)/2, 15, 343, 125);
        self.bgImgView.backgroundColor = [UIColor whiteColor];
        self.bgImgView.image = [UIImage imageNamed:@"icn_msg_red_packet"];
        [self.contentView addSubview:self.bgImgView];
        
        self.moneyLabel = [FControlTool createLabel:@"888.88元" textColor:UIColor.whiteColor font:[UIFont semiBoldFontWithSize:24]];
        self.moneyLabel.frame = CGRectMake(72, 16, self.bgImgView.width - 88, 24);
        [self.bgImgView addSubview:self.moneyLabel];
        
        self.contentLabel = [FControlTool createLabel:@"恭喜发财 大吉大利" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:16]];
        self.contentLabel.frame = CGRectMake(72, 51, self.bgImgView.width - 88, 16);
        [self.bgImgView addSubview:self.contentLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(14, 85, self.bgImgView.width - 28, 1);
        lineView.backgroundColor = RGBAlphaColor(0xffffff, 0.2);
        [self.bgImgView addSubview:lineView];
        
        self.titleLabel = [FControlTool createLabel:@"拼手气红包" textColor:UIColor.whiteColor font:[UIFont fontWithSize:14]];
        self.titleLabel.frame = CGRectMake(14, 91, self.bgImgView.width - 28, 24);
        [self.bgImgView addSubview:self.titleLabel];
        
        self.timeLabel = [FControlTool createLabel:@"2025-03-24" textColor:UIColor.whiteColor font:[UIFont fontWithSize:14]];
        self.timeLabel.frame = CGRectMake(14, 91, self.bgImgView.width - 28, 24);
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.bgImgView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setModel:(SWUnclaimedRedPacketModel *)model{
    _model = model;
    NSString *title = @"";
    if (model.type == 21) {
        title = @"专属红包";
        self.bgImgView.image = [UIImage imageNamed:@"icn_msg_red_packet_e"];
    }else if (model.type == 22) {
        title = @"红包";
        self.bgImgView.image = [UIImage imageNamed:@"icn_msg_red_packet"];
    }else if (model.type == 28) {
        title = @"转账";
        self.bgImgView.image = [UIImage imageNamed:@"icn_msg_red_packet"];
    }else if (model.type == 23) {
        title = @"拼手气红包";
        self.bgImgView.image = [UIImage imageNamed:@"icn_msg_red_packet"];
    }else{
        title = @"红包";
        self.bgImgView.image = [UIImage imageNamed:@"icn_msg_red_packet"];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf元",model.amount/100.0];
    self.contentLabel.text = model.title;
    self.titleLabel.text = title;
    self.timeLabel.text = [FDataTool updataForNumberTimeYear:[NSString stringWithFormat:@"%ld",model.createTime.integerValue/1000] formatter:@"YYYY-MM-dd HH:mm:ss"];
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
