//
//  SWCommonInputView.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWCommonInputView.h"

@interface SWCommonInputView ()

@end

@implementation SWCommonInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x333333) font:[UIFont semiBoldFontWithSize:15]];
        self.titleLabel.frame = CGRectMake(15, 0, kScreenWidth - 30, 18);
        [self addSubview:self.titleLabel];
        
        self.inputBgView = [[UIView alloc] init];
        self.inputBgView.frame = CGRectMake(15, self.titleLabel.bottom+5, kScreenWidth - 30, 44);
        self.inputBgView.backgroundColor = RGBColor(0xF2F2F2);
        self.inputBgView.layer.cornerRadius = 10;
        self.inputBgView.layer.masksToBounds = YES;
        [self addSubview:self.inputBgView];
        
        self.inputTextField = [[UITextField alloc] init];
        self.inputTextField.frame = CGRectMake(9, 0, self.inputBgView.width - 18, 44);
        self.inputTextField.font = [UIFont fontWithSize:12];
        self.inputTextField.textColor = RGBColor(0x333333);
        [self.inputBgView addSubview:self.inputTextField];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:RGBColor(0x999999),NSFontAttributeName:[UIFont fontWithSize:12]}];
    self.inputTextField.attributedPlaceholder = placeholderString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
