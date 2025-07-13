//
//  SWMineCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/23.
//

#import "SWMineCell.h"

@interface SWMineCell ()
@property(nonatomic, strong) UIView *bgView;
@end

@implementation SWMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(0, 0, kScreenWidth - 32, 48);
        self.bgView.backgroundColor = UIColor.whiteColor;
        [self.bgView rounded:24];
        [self.contentView addSubview:self.bgView];
        
        self.icnImgView = [[UIImageView alloc] init];
        self.icnImgView.frame = CGRectMake(16, 10, 28, 28);
        self.icnImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.bgView addSubview:self.icnImgView];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:16]];
        self.titleLabel.frame = CGRectMake(self.icnImgView.right+12, 0, kScreenWidth-72, 48);
        [self.bgView addSubview:self.titleLabel];
        
        self.arrowImgView = [[UIImageView alloc] init];
        self.arrowImgView.frame = CGRectMake(kScreenWidth - 32 - 33, 14, 21, 20);
        self.arrowImgView.image = [UIImage imageNamed:@"icn_mine_arrow"];
        [self.bgView addSubview:self.arrowImgView];
        
    }
    return self;
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
