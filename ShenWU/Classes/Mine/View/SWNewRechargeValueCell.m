//
//  SWNewRechargeValueCell.m
//  ShenWU
//
//  Created by Amy on 2025/2/12.
//

#import "SWNewRechargeValueCell.h"

@implementation SWNewRechargeValueCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [FControlTool createLabel:@"" textColor:[UIColor blackColor] font:[UIFont fontWithSize:16]];
        self.titleLabel.frame = CGRectMake(0, 0, 66, 56);
        self.titleLabel.backgroundColor = UIColor.whiteColor;
        [self.titleLabel rounded:8 width:1 color:RGBColor(0x979797)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.titleLabel.backgroundColor = kMainColor;
        self.titleLabel.textColor = UIColor.whiteColor;
    }else{
        self.titleLabel.backgroundColor = UIColor.whiteColor;
        self.titleLabel.textColor = RGBColor(0x081C2C);
    }
}

@end
