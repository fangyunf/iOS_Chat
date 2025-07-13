//
//  PSystomNotiCell.m
//  ShenWU
//
//  Created by Amy on 2024/7/20.
//

#import "PSystomNotiCell.h"

@interface PSystomNotiCell ()
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@end

@implementation PSystomNotiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.timeLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x999999) font:[UIFont fontWithSize:12]];
        self.timeLabel.frame = CGRectMake(0, 0, kScreenWidth, 15);
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.timeLabel];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(0, self.timeLabel.bottom+10, kScreenWidth, 158);
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 10;
        [self.contentView addSubview:self.bgView];
        
        self.titleLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont boldFontWithSize:15]];
        self.titleLabel.frame = CGRectMake(15, 20, self.bgView.width - 30, 18);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.titleLabel];
        
        self.contentLabel = [FControlTool createLabel:@"" textColor:UIColor.blackColor font:[UIFont fontWithSize:13]];
        self.contentLabel.frame = CGRectMake(15, self.titleLabel.bottom+15, self.bgView.width - 30, 90);
        self.contentLabel.numberOfLines = 0;
        [self.bgView addSubview:self.contentLabel];
        
    }
    return self;
}

- (void)refreshCellWithData:(PSystomNotiModel*)data{
    self.timeLabel.text = [FDataTool updataForNumberTimeYear:[NSString stringWithFormat:@"%ld",data.createTime.integerValue/1000] formatter:@"YYYY-MM-dd HH:mm:ss"];
    self.titleLabel.text = data.title;
    if (data.contentHeight < 90) {
        self.bgView.frame = CGRectMake(0, self.timeLabel.bottom+10, kScreenWidth, 158);
        self.contentLabel.frame = CGRectMake(15, self.titleLabel.bottom+15+(90-data.contentHeight)/2, self.bgView.width - 30, data.contentHeight);
        self.contentLabel.text = data.content;
    }else{
        self.bgView.frame = CGRectMake(0, self.timeLabel.bottom+10, kScreenWidth, 158+(data.contentHeight - 90));
        self.contentLabel.frame = CGRectMake(15, self.titleLabel.bottom+15, self.bgView.width - 30, data.contentHeight);
        self.contentLabel.text = data.content;
    }
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
