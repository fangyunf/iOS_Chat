//
//  SWFriendInfoHeaderView.m
//  ShenWU
//
//  Created by Amy on 2025/2/19.
//

#import "SWFriendInfoHeaderView.h"

@interface SWFriendInfoHeaderView ()
@property(nonatomic, strong) UIButton *idBtn;
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *remarkLabel;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *idLabel;
@property(nonatomic, strong) UIButton *getIdBtn;
@end

@implementation SWFriendInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 28, kScreenWidth-22, 119);
        bgView.backgroundColor = UIColor.clearColor;
        [bgView rounded:12];
        [self addSubview:bgView];
        
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = bgView.bounds;
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 0.5);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.64].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7700].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        gl.cornerRadius = 12;
        [bgView.layer insertSublayer:gl atIndex:0];
        // blur
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualView.frame = bgView.bounds;
        visualView.layer.cornerRadius = 12;
        [bgView addSubview:visualView];
        
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.frame = CGRectMake(16, 26, 64, 64);
        self.avatarImgView.layer.cornerRadius = 8;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImgView.userInteractionEnabled = YES;
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
        [bgView addSubview:self.avatarImgView];
        
//        self.remarkLabel = [FControlTool createLabel:self.user.remark.length > 0?self.user.remark:self.user.name textColor:UIColor.blackColor font:[UIFont semiBoldFontWithSize:20]];
//        self.remarkLabel.frame = CGRectMake(self.avatarImgView.right+14, 20, kScreenWidth - (self.avatarImgView.right+34), 25);
//        [bgView addSubview:self.remarkLabel];
        
        self.nameLabel = [FControlTool createLabel:[NSString stringWithFormat:@"%@",self.user.name] textColor:UIColor.blackColor font:[UIFont boldFontWithSize:20]];
        self.nameLabel.frame = CGRectMake(self.avatarImgView.right+14, 35, kScreenWidth - (self.avatarImgView.right+34), 25);
        [bgView addSubview:self.nameLabel];
        
        
        CGSize idSize = [[NSString stringWithFormat:@"ID:%@",self.user.memberCode] sizeForFont:[UIFont fontWithSize:12] size:CGSizeMake(self.width - 102, 15) mode:NSLineBreakByWordWrapping];
        
        self.idBtn = [[UIButton alloc] init];
        self.idBtn.frame = CGRectMake(self.avatarImgView.right+14, self.nameLabel.bottom+9, idSize.width+4+40, 16);
        [self.idBtn addTarget:self action:@selector(copyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:self.idBtn];
        
        self.idLabel = [FControlTool createLabel:[NSString stringWithFormat:@"账号:%@",self.user.memberCode] textColor:RGBColor(0x999999) font:[UIFont fontWithSize:12]];
        self.idLabel.frame = CGRectMake(0, 0, idSize.width, 24);
        self.idLabel.layer.masksToBounds = YES;
        self.idLabel.textAlignment = NSTextAlignmentCenter;
        [self.idBtn addSubview:self.idLabel];
        
        self.getIdBtn = [FControlTool createButton:@"复制添加好友口令" font:[UIFont fontWithSize:10] textColor:RGBColor(0x081C2C) target:self sel:@selector(copyBtnAction)];
        self.getIdBtn.frame = CGRectMake(bgView.width- 106, (bgView.height - 28)/2, 90, 28);
        self.getIdBtn.backgroundColor = RGBColor(0xF0F0F0);
        [bgView addSubview:self.getIdBtn];
    }
    return self;
}

- (void)setUser:(FFriendModel *)user{
    _user = user;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_person"]];
    self.remarkLabel.text = self.user.remark.length > 0?self.user.remark:self.user.name;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",self.user.name];
    
    CGSize idSize = [[NSString stringWithFormat:@"账号:%@",self.user.memberCode] sizeForFont:[UIFont fontWithSize:12] size:CGSizeMake(self.width - 102, 15) mode:NSLineBreakByWordWrapping];
    
    self.idBtn.frame = CGRectMake(self.avatarImgView.right+14, self.nameLabel.bottom+7, idSize.width+4+16, 24);
    
    self.idLabel.text = [NSString stringWithFormat:@"账号:%@",self.user.memberCode];
    self.idLabel.frame = CGRectMake(0, 0, idSize.width, 24);
}

- (void)copyBtnAction{
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.user.memberCode];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
