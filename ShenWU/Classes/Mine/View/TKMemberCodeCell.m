//
//  TKMemberCodeCell.m
//  ShenWU
//
//  Created by Amy on 2024/9/20.
//

#import "TKMemberCodeCell.h"

@implementation TKMemberCodeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.codeLabel = [FControlTool createLabel:@"" textColor:UIColor.whiteColor font:[UIFont boldFontWithSize:16]];
        self.codeLabel.frame = CGRectMake(0, 0, 90, 31);
        self.codeLabel.textAlignment = NSTextAlignmentCenter;
        self.codeLabel.layer.borderColor = UIColor.whiteColor.CGColor;
        self.codeLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.codeLabel];
    }
    return self;
}

@end
