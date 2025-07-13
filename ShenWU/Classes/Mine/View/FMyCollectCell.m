//
//  FMyCollectCell.m
//  Fiesta
//
//  Created by Amy on 2024/5/28.
//

#import "FMyCollectCell.h"

@interface FMyCollectCell ()

@end

@implementation FMyCollectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(0, 0, kScreenWidth , 75);
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bgView];
        
        self.titleLabel = [FControlTool createLabel:@"你们用我的账号登录，18276678900，然后退…" textColor:UIColor.blackColor font:[UIFont fontWithSize:16]];
        self.titleLabel.frame = CGRectMake(16, 14, kScreenWidth - 32, 22);
        [self.bgView addSubview:self.titleLabel];
        
        self.nameLabel = [FControlTool createLabel:@"陈多多" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:12]];
        self.nameLabel.frame = CGRectMake(16, self.bgView.height - 31, kScreenWidth - 32, 17);
        [self.bgView addSubview:self.nameLabel];
        
        self.timeLabel = [FControlTool createLabel:@"2024-8-23" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:12]];
        self.timeLabel.frame = CGRectMake(16, self.bgView.height - 31, kScreenWidth - 32, 17);
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:self.timeLabel];
        
        self.contentImgView = [[UIImageView alloc] init];
        self.contentImgView.frame = CGRectMake(16, 14, 63, 66);
        self.contentImgView.layer.cornerRadius = 4;
        self.contentImgView.layer.masksToBounds = YES;
        self.contentImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentImgView.image = [UIImage imageNamed:@"avatar_person"];
        [self.contentView addSubview:self.contentImgView];
    }
    return self;
}

- (void)updateViewFrame:(BOOL)isImage{
    if (isImage) {
        self.bgView.frame = CGRectMake(0, 0, kScreenWidth , 119);
    }else{
        self.bgView.frame = CGRectMake(0, 0, kScreenWidth , 75);
    }
    
    self.timeLabel.top = self.bgView.height - 31;
    self.nameLabel.top = self.bgView.height - 31;
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
