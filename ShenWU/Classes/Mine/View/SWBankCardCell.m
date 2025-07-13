//
//  SWBankCardCell.m
//  ShenWU
//
//  Created by Amy on 2024/7/1.
//

#import "SWBankCardCell.h"

@interface SWBankCardCell ()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *cardNoLabel;
@end

@implementation SWBankCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgImageView = [[UIImageView alloc] init];
        self.bgImageView.frame = CGRectMake((kScreenWidth - 317)/2, 0, 317, 170);
        self.bgImageView.image = [UIImage imageNamed:@"bank_bg_other"];
        self.bgImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.bgImageView];
        
        UIButton *unbindBtn = [FControlTool createButton:@"解绑" font:[UIFont boldFontWithSize:14] textColor:RGBColor(0x666666) target:self sel:@selector(unbindBtnAction)];
        unbindBtn.frame = CGRectMake(self.bgImageView.width - 51, 10, 41, 20);
        [self.bgImageView addSubview:unbindBtn];
        
        self.nameLabel = [FControlTool createLabel:@"" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:16]];
        self.nameLabel.frame = CGRectMake(15, 10, self.bgImageView.width - 104, 20);
        [self.bgImageView addSubview:self.nameLabel];
        
        self.cardNoLabel = [FControlTool createLabel:@"" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:24]];
        self.cardNoLabel.frame = CGRectMake(15, self.bgImageView.height - 41, self.bgImageView.width - 30, 27);
        [self.bgImageView addSubview:self.cardNoLabel];
        
    }
    return self;
}

- (void)unbindBtnAction{
    if (self.unbindBlock) {
        self.unbindBlock(self.tag);
    }
}

- (void)refreshCellWithData:(FBankCardModel*)data{
//    if ([data.bankName containsString:@"工商"]) {
//        self.bgImageView.image = [UIImage imageNamed:@"bank_bg_gongshang"];
//        self.nameLabel.textColor = RGBColor(0xD93538);
//        self.cardNoLabel.textColor = RGBColor(0xD93538);
//    }else if ([data.bankName containsString:@"农业"]) {
//        self.bgImageView.image = [UIImage imageNamed:@"bank_bg_nongye"];
//        self.nameLabel.textColor = RGBColor(0x009C96);
//        self.cardNoLabel.textColor = RGBColor(0x009C96);
//    }else if ([data.bankName containsString:@"建设"]) {
//        self.bgImageView.image = [UIImage imageNamed:@"bank_bg_jianshe"];
//        self.nameLabel.textColor = RGBColor(0x004F9C);
//        self.cardNoLabel.textColor = RGBColor(0x004F9C);
//    }else if ([data.bankName containsString:@"中国"]) {
//        self.bgImageView.image = [UIImage imageNamed:@"bank_bg_zhongguo"];
//        self.nameLabel.textColor = RGBColor(0xC7162E);
//        self.cardNoLabel.textColor = RGBColor(0xC7162E);
//    }else{
//        self.bgImageView.image = [UIImage imageNamed:@"bank_bg_other"];
//        self.nameLabel.textColor = UIColor.blackColor;
//        self.cardNoLabel.textColor = UIColor.blackColor;
//    }
    self.nameLabel.text = data.bankName;
    if (data.bankCardNo.length == 0) {
        self.cardNoLabel.text = data.certNo;
    }else{
        self.cardNoLabel.text = data.bankCardNo;
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
