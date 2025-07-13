//
//  SWPasswordInputCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/29.
//

#import "SWPasswordInputCell.h"

@implementation SWPasswordInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.inputView = [[SWCommonInputView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, 67)];
        [self.contentView addSubview:self.inputView];
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
