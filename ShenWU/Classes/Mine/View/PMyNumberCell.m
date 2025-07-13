//
//  PMyNumberCell.m
//  ShenWU
//
//  Created by Amy on 2024/7/17.
//

#import "PMyNumberCell.h"

@implementation PMyNumberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x000000) font:[UIFont fontWithSize:14]];
        self.titleLabel.frame = CGRectMake(0, 0, (kScreenWidth - 40)/2, 45);
        self.titleLabel.backgroundColor = RGBColor(0xF2F2F2);
        self.titleLabel.layer.cornerRadius = 15;
        self.titleLabel.layer.masksToBounds = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
