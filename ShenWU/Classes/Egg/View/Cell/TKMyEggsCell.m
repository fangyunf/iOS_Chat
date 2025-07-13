//
//  TKMyEggsCell.m
//  ShenWU
//
//  Created by Amy on 2024/8/25.
//

#import "TKMyEggsCell.h"

@interface TKMyEggsCell ()
@property(nonatomic, strong) UIImageView *coverImgView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *desLabel;
@property(nonatomic, strong) UIButton *issueBtn;
@end

@implementation TKMyEggsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *coverView = [[UIView alloc] init];
        coverView.frame = CGRectMake(15, 13, 48, 48);
        coverView.layer.cornerRadius = 5;
        coverView.backgroundColor = RGBColor(0x4FA0FA);
        coverView.layer.masksToBounds = YES;
        [self.contentView addSubview:coverView];
        
        self.coverImgView = [[UIImageView alloc] init];
        self.coverImgView.frame = CGRectMake(7, 19, 34, 18);
        self.coverImgView.image = [UIImage imageNamed:@"icn_my_egg"];
        [coverView addSubview:self.coverImgView];
        
        self.titleLabel = [FControlTool createLabel:@"5个388彩蛋" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:18]];
        self.titleLabel.frame = CGRectMake(coverView.right+10, 13, kScreenWidth - (coverView.right+93), 21);
        [self.contentView addSubview:self.titleLabel];
        
        self.desLabel = [FControlTool createLabel:@"彩蛋还未发放，可发放至指定群聊" textColor:UIColor.whiteColor font:[UIFont fontWithSize:13]];
        self.desLabel.frame = CGRectMake(coverView.right+10, 46, kScreenWidth - (coverView.right+93), 15);
        [self.contentView addSubview:self.desLabel];
        
        self.issueBtn = [FControlTool createButton:@"放彩蛋" font:[UIFont boldFontWithSize:15] textColor:[UIColor whiteColor] target:self sel:@selector(issueBtnAction)];
        self.issueBtn.frame = CGRectMake(kScreenWidth - 83, 18, 71, 38);
        self.issueBtn.backgroundColor = kMainColor;
        self.issueBtn.layer.cornerRadius = 19;
        self.issueBtn.layer.masksToBounds = YES;
        self.issueBtn.layer.borderWidth = 0;
        self.issueBtn.userInteractionEnabled = NO;
        self.issueBtn.layer.borderColor = UIColor.whiteColor.CGColor;
        [self.contentView addSubview:self.issueBtn];
    }
    return self;
}

- (void)refreshCellWithData:(TKEggListItemModel*)data{
    
    if ([FDataTool isNull:data.groupName]) {
        self.titleLabel.text = [NSString stringWithFormat:@"%ld个%ld彩蛋",data.num,data.price/100];
        self.desLabel.text = @"彩蛋还未发放，可发放至指定群聊";
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"%ld彩蛋",data.price/100];
        self.desLabel.text = [NSString stringWithFormat:@"彩蛋已发放至 %@ 群聊",data.groupName];
        self.issueBtn.layer.borderWidth = 1;
        self.issueBtn.backgroundColor = [UIColor clearColor];
    }
    
}

- (void)issueBtnAction{
    if (self.clickOnIssueBtn) {
        self.clickOnIssueBtn();
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
