//
//  SWWalletMessageCell.m
//  ShenWU
//
//  Created by Amy on 2025/2/27.
//

#import "SWWalletMessageCell.h"

@interface SWWalletMessageCell ()
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@end

@implementation SWWalletMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(0, 15, kScreenWidth, 158);
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 10;
        [self.contentView addSubview:self.bgView];
        
        self.timeLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
        self.timeLabel.frame = CGRectMake(15, 15, kScreenWidth-30, 18);
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:self.timeLabel];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
        self.titleLabel.frame = CGRectMake(15, 15, self.bgView.width - 30, 18);
        [self.bgView addSubview:self.titleLabel];
        
        self.contentLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:13]];
        self.contentLabel.frame = CGRectMake(15, self.titleLabel.bottom+15, self.bgView.width - 30, 90);
        self.contentLabel.numberOfLines = 0;
        [self.bgView addSubview:self.contentLabel];
        
    }
    return self;
}

- (void)setModel:(SWWalletMessageItemModel *)model{
    _model = model;
    
    self.timeLabel.text = [FDataTool updataForNumberTimeYear:[NSString stringWithFormat:@"%ld",model.createTime.integerValue/1000] formatter:@"YYYY-MM-dd HH:mm:ss"];
    NSString *contentStr = @"";
    if (self.isRecharge) {
        self.titleLabel.text = @"用户充值";
        if([model.state isEqualToString:@"1"]){
            contentStr = [NSString stringWithFormat:@"成功充值%.02lf元到您的余额",[model.amount doubleValue]/100];
        }else if([model.state isEqualToString:@"0"]){
            contentStr = [NSString stringWithFormat:@"充值中,充值%.02lf元",[model.amount doubleValue]/100];
        }else {
            contentStr = [NSString stringWithFormat:@"充值%.02lf元失败",[model.amount doubleValue]/100];
        }
    }else{
        self.titleLabel.text = @"用户提现";
        if([model.state isEqualToString:@"0"]){
            contentStr = [NSString stringWithFormat:@"发起申请提现操作:提现%.02lf元",[model.amount doubleValue]/100];
        }else if([model.state isEqualToString:@"1"]){
            contentStr = [NSString stringWithFormat:@"您提现%.02lf元审核通过,注意查看银行短信通知",[model.remitAmount doubleValue]/100];
        }else {
            contentStr = [NSString stringWithFormat:@"您提现%.02lf元失败",[model.amount doubleValue]/100];
        }
    }
    CGSize size = [contentStr sizeForFont:self.contentLabel.font size:CGSizeMake(self.bgView.width - 30, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    self.contentLabel.text = contentStr;
    self.contentLabel.frame = CGRectMake(15, self.titleLabel.bottom+15, self.bgView.width - 30, size.height);
    self.bgView.height = self.titleLabel.bottom+30+size.height;
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
