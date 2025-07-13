//
//  TKNotiyCell.m
//  ShenWU
//
//  Created by Amy on 2024/8/8.
//

#import "TKNotiyCell.h"

@interface TKNotiyCell ()

@end

@implementation TKNotiyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icnImgView = [[UIImageView alloc] init];
        self.icnImgView.frame = CGRectMake(16, 12, 56, 56);
        [self.contentView addSubview:self.icnImgView];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:16]];
        self.titleLabel.frame = CGRectMake(self.icnImgView.right+11, 20, kScreenWidth - (self.icnImgView.right+26), 40);
        [self.contentView addSubview:self.titleLabel];
        
        self.numLabel = [FControlTool createLabel:@"" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:12]];
        self.numLabel.frame = CGRectMake(kScreenWidth - 48, 30, 30, 20);
        self.numLabel.backgroundColor = kMainColor;
        self.numLabel.layer.cornerRadius = 10;
        self.numLabel.layer.masksToBounds = YES;
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.numLabel];
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
