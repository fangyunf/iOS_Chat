//
//  TKEditInfoView.m
//  ShenWU
//
//  Created by Amy on 2024/8/7.
//

#import "TKEditInfoView.h"

@interface TKEditInfoView ()

@end

@implementation TKEditInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
        self.titleLabel.frame = CGRectMake(30, 0, kScreenWidth - 60, 18);
        [self addSubview:self.titleLabel];
        
        self.tipLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x999999) font:[UIFont boldFontWithSize:12]];
        self.tipLabel.frame = CGRectMake(30, self.titleLabel.bottom+6, kScreenWidth - 60, 15);
        [self addSubview:self.tipLabel];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(15, self.tipLabel.bottom+11, kScreenWidth - 30, 53);
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        
        self.contentLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
        self.contentLabel.frame = CGRectMake(15, 0, kScreenWidth - 60, 53);
        [bgView addSubview:self.contentLabel];
        
        self.detailLabel = [FControlTool createLabel:@"修改" textColor:RGBColor(0x999999) font:[UIFont boldFontWithSize:12]];
        self.detailLabel.frame = CGRectMake(15, 0, kScreenWidth - 90, 53);
        [bgView addSubview:self.detailLabel];
        
        self.arrowImgView = [[UIImageView alloc] init];
        self.arrowImgView.frame = CGRectMake(bgView.width - 33, 16.5, 21, 20);
        self.arrowImgView.image = [UIImage imageNamed:@"icn_mine_arrow"];
        [bgView addSubview:self.arrowImgView];
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
