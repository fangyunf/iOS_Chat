//
//  FBillingDetailsCell.m
//  Fiesta
//
//  Created by Amy on 2024/5/28.
//

#import "FBillingDetailsCell.h"

@implementation FBillingDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImgView = [[UIImageView alloc] init];
        self.iconImgView.frame = CGRectMake(15, 15, 39, 39);
        self.iconImgView.image = [UIImage imageNamed:@"icn_send_quan"];
        [self.contentView addSubview:self.iconImgView];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:15]];
        self.titleLabel.frame = CGRectMake(self.iconImgView.right+12, 15, kScreenWidth-22 - (self.iconImgView.right+130), 18);
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel = [FControlTool createLabel:@"2023-01-23  16:00" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:12]];
        self.timeLabel.frame = CGRectMake(self.iconImgView.right+12, 39, kScreenWidth-22 - (self.iconImgView.right+130), 15);
        [self.contentView addSubview:self.timeLabel];
        
        self.moneyLabel = [FControlTool createLabel:@"-888.00" textColor:UIColor.blackColor font:[UIFont fontWithSize:15]];
        self.moneyLabel.frame = CGRectMake(kScreenWidth-22 - 226, 10, 200, 18);
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.moneyLabel];
        
        self.balanceLabel = [FControlTool createLabel:@"-888.00" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:14]];
        self.balanceLabel.frame = CGRectMake(kScreenWidth-22 - 226, 33, 200, 16);
        self.balanceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.balanceLabel];
        
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.frame = CGRectMake(kScreenWidth - 21, 29, 6, 11);
        arrowImgView.image = [UIImage imageNamed:@"icn_setting_arrow"];
        [self.contentView addSubview:arrowImgView];
    }
    return self;
}

- (void)refreshCellWithData:(FTranscationsModel*)data{
    NSArray *list = [FDataTool getTransactionTypeDictionary];
    NSDictionary *dataDict = nil;
    for (NSDictionary *dic in list) {
        if ([[dic objectForKey:@"type"] integerValue] == data.moduleType) {
            dataDict = dic;
            break;
        }
    }
    NSString *money = [NSString stringWithFormat:@"%.2lf",data.amount/100.0];
    self.moneyLabel.textColor = RGBColor(0x0CB402);
    if (data.amount > 0) {
        money = [NSString stringWithFormat:@"+%.2lf",data.amount/100.0];
        self.moneyLabel.textColor = RGBColor(0xFE4D30);
    }
    self.moneyLabel.text = money;
    self.balanceLabel.text = [NSString stringWithFormat:@"余额：%.2lf",(data.balance + data.amount)/100.0];
    self.timeLabel.text = [FDataTool updataForNumberTimeYear:[NSString stringWithFormat:@"%ld",data.createTime.integerValue/1000] formatter:@"YYYY-MM-dd HH:mm:ss"];
    if (data.name.length > 0) {
        self.titleLabel.text = data.name;
        self.iconImgView.image = [UIImage imageNamed:[dataDict objectForKey:@"imageName"]];
    }else{
        if (dataDict) {
            self.titleLabel.text = [dataDict objectForKey:@"title"];
            self.iconImgView.image = [UIImage imageNamed:[dataDict objectForKey:@"imageName"]];
        }
    }
    
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
