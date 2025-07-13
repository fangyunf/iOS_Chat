//
//  FBillingFilterItemCell.m
//  Fiesta
//
//  Created by Amy on 2024/5/28.
//

#import "FBillingFilterItemCell.h"

@interface FBillingFilterItemCell ()

@end

@implementation FBillingFilterItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x8251D9) font:[UIFont fontWithSize:14]];
        self.titleLabel.frame = CGRectMake(0, 0, (kScreenWidth - 32 - 22)/3, 43);
        self.titleLabel.backgroundColor = RGBColor(0xFAF9FF);
        self.titleLabel.layer.cornerRadius = 4;
        self.titleLabel.layer.masksToBounds = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.titleLabel.backgroundColor = kMainColor;
        self.titleLabel.textColor = [UIColor whiteColor];
    }else{
        self.titleLabel.backgroundColor = RGBColor(0xFAF9FF);
        self.titleLabel.textColor = RGBColor(0x333333);
    }
}

@end
