//
//  SWGroupMemberCell.m
//  ShenWU
//
//  Created by Amy on 2024/6/24.
//

#import "SWGroupMemberCell.h"

@implementation SWGroupMemberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake(8, 0, 40, 40);
        self.avatarImgView.layer.cornerRadius = 4;
        self.avatarImgView.layer.borderColor = UIColor.whiteColor.CGColor;
        self.avatarImgView.layer.borderWidth = 1;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImgView];
        
        self.tagLabel = [FControlTool createLabel:@"" textColor:UIColor.whiteColor font:[UIFont fontWithSize:9]];
        self.tagLabel.frame = CGRectMake(8, 25, 40, 15);
        self.tagLabel.backgroundColor = kMainColor;
        self.tagLabel.textAlignment = NSTextAlignmentCenter;
        self.tagLabel.hidden = YES;
        [self.tagLabel rounded:5];
        [self.contentView addSubview:self.tagLabel];
        
        self.nameLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:10]];
        self.nameLabel.frame = CGRectMake(0, self.avatarImgView.bottom+8, 56, 19);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.hidden = YES;
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)refreshCellWithData:(FGroupUserInfoModel*)model{
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    self.nameLabel.text = model.name;
    if (model.rankState == 1) {
        self.tagLabel.hidden = NO;
        self.tagLabel.text = @"群主";
    }else if (model.rankState == 2) {
        self.tagLabel.hidden = NO;
        self.tagLabel.text = @"管理";
    }else {
        self.tagLabel.hidden = YES;
    }
}

@end
