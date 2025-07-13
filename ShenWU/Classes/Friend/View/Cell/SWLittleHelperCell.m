//
//  SWLittleHelperCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/29.
//

#import "SWLittleHelperCell.h"

@interface SWLittleHelperCell ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, strong) UILabel *methodLabel;
@property(nonatomic, strong) UILabel *statusLabel;
@end

@implementation SWLittleHelperCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(15, 10, kScreenWidth - 30, 162);
        bgView.backgroundColor = UIColor.whiteColor;
        bgView.layer.cornerRadius = 15;
        bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:bgView];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(121, 39, 0.5, bgView.height - 78);
        lineView.backgroundColor = RGBColor(0xc0c0c0);
        [bgView addSubview:lineView];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
        self.titleLabel.frame = CGRectMake(10, 43, 100, 18);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:self.titleLabel];
        
        UILabel *moneyTitleLabel = [FControlTool createLabel:@"金额" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
        moneyTitleLabel.frame = CGRectMake(10, self.titleLabel.bottom+10, 100, 17);
        moneyTitleLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:moneyTitleLabel];
        
        self.moneyLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:18]];
        self.moneyLabel.frame = CGRectMake(10, moneyTitleLabel.bottom+10, 100, 21);
        self.moneyLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:self.moneyLabel];
        
        UILabel *methodTitleLabel = [FControlTool createLabel:@"收款方式" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
        methodTitleLabel.frame = CGRectMake(lineView.right+30, 43, 68, 18);
        [bgView addSubview:methodTitleLabel];
        
        self.methodLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
        self.methodLabel.frame = CGRectMake(methodTitleLabel.right, 43, bgView.width - moneyTitleLabel.right - 10, 18);
        [bgView addSubview:self.methodLabel];
        
        UILabel *statusTitleLabel = [FControlTool createLabel:@"交易状态" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
        statusTitleLabel.frame = CGRectMake(lineView.right+30, self.titleLabel.bottom+10, 68, 17);
        [bgView addSubview:statusTitleLabel];
        
        self.statusLabel = [FControlTool createLabel:@"xxxxx" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
        self.statusLabel.frame = CGRectMake(statusTitleLabel.right, self.titleLabel.bottom+10, bgView.width - moneyTitleLabel.right - 10, 17);
        [bgView addSubview:self.statusLabel];
        
        UILabel *timeTitleLabel = [FControlTool createLabel:@"申请时间" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
        timeTitleLabel.frame = CGRectMake(lineView.right+30, moneyTitleLabel.bottom+10, 68, 21);
        [bgView addSubview:timeTitleLabel];
        
        self.timeLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:14]];
        self.timeLabel.frame = CGRectMake(timeTitleLabel.right, moneyTitleLabel.bottom+10, bgView.width - moneyTitleLabel.right - 10, 21);
        [bgView addSubview:self.timeLabel];
    }
    return self;
}

- (void)refreshCellWithData:(FLittleHelperModel*)model{
    if (model.state == 101) {
        self.titleLabel.text = @"小助手消息";
    }else if (model.state == 102) {
        self.titleLabel.text = @"充值成功";
    }else if (model.state == 103) {
        self.titleLabel.text = @"提现审核";
    }else if (model.state == 104) {
        self.titleLabel.text = @"提现成功";
    }else if (model.state == 105) {
        self.titleLabel.text = @"提现失败";
    }else if (model.state == 106) {
        self.titleLabel.text = @"红包退回";
    }else if (model.state == 107) {
        self.titleLabel.text = @"系统消息";
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",model.money/100.0];
    self.methodLabel.text = model.payTerm;
    self.statusLabel.text = model.payMsg;
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
