//
//  SWNotiScrollView.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWNotiScrollView.h"

@interface SWNotiScrollView ()

@end

@implementation SWNotiScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        UIImageView *bgImgView = [FControlTool createImageViewWithFrame:CGRectMake(0, 0, self.width, 42) withImage:[UIImage imageNamed:@"bg_noti"]];
//        [self addSubview:bgImgView];
        
        UIImageView *iconImgView = [FControlTool createImageViewWithFrame:CGRectMake(13, 11, 21, 20) withImage:[UIImage imageNamed:@"icn_msg_noti"]];
        [self addSubview:iconImgView];
        
        self.textView = [[ScrollTextView alloc] init];
        self.textView.frame = CGRectMake(iconImgView.right+7, 0, self.width - (iconImgView.right+14), self.height);
        self.textView.textScrollMode = TextScrollContinuous;
        self.textView.textScrollDirection = TextScrollMoveLeft;
        self.textView.textColor = kMainColor;
        self.textView.textFont = [UIFont fontWithSize:13];
        self.textView.text = @"";
        [self addSubview:self.textView];
        
        [self.textView startScroll];
    }
    return self;
}

@end
