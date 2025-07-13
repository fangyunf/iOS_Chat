//
//  FRecordVoiceView.m
//  Fiesta
//
//  Created by Amy on 2024/5/30.
//

#import "FRecordVoiceView.h"

@interface FRecordVoiceView ()

@end

@implementation FRecordVoiceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBColor(0x666666);
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
        self.timeLabel = [FControlTool createLabel:@"00:00" textColor:UIColor.whiteColor font:[UIFont semiBoldFontWithSize:30]];
        self.timeLabel.frame = CGRectMake(5, 20, self.width - 10, 42);
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timeLabel];
        
        UILabel *tipLabel = [FControlTool createLabel:@"手指上滑，取消发送" textColor:UIColor.whiteColor font:[UIFont fontWithSize:14]];
        tipLabel.frame = CGRectMake(5, 64, self.width - 10, 20);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipLabel];
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
