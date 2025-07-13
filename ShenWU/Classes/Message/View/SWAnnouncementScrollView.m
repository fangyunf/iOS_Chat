//
//  SWAnnouncementScrollView.m
//  ShenWU
//
//  Created by Amy on 2024/7/10.
//

#import "SWAnnouncementScrollView.h"

@implementation SWAnnouncementScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGBAlphaColor(0x19C77A, 0.8);
        
        UILabel *titleLabel = [FControlTool createLabel:@"群公告：" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:14]];
        titleLabel.frame = CGRectMake(15, 0, 60, 30);
        [self addSubview:titleLabel];
        
        
        self.textView = [[ScrollTextView alloc] init];
        self.textView.frame = CGRectMake(titleLabel.right+5, 0, kScreenWidth - (titleLabel.right+20), 30);
        self.textView.textScrollMode = TextScrollContinuous;
        self.textView.textScrollDirection = TextScrollMoveLeft;
        self.textView.textColor = UIColor.whiteColor;
        self.textView.textFont = [UIFont fontWithSize:14];
        self.textView.text = @"通知：请大家尽快完成后台认证";
        [self addSubview:self.textView];
        
        [self.textView startScroll];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
