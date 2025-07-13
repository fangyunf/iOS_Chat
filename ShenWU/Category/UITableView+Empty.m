//
//  UITableView+Empty.m
//  lpop
//
//  Created by Amy on 2022/10/26.
//

#import "UITableView+Empty.h"

@implementation UITableView (Empty)
- (void)showEmptyWtihFrame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title{
    [self showEmptyWtihFrame:frame imageName:imageName title:title titleColor:RGBColor(0x999999)];
}

- (void)showEmptyWtihFrame:(CGRect)frame imageName:(NSString*)imageName title:(NSString*)title titleColor:(UIColor*)titleColor{
    
    NSString *contentStr = title;
    NSMutableAttributedString * contentAtt = [[NSMutableAttributedString alloc] initWithString:contentStr];
    contentAtt.lineSpacing = 0;
    contentAtt.color = titleColor;
    contentAtt.font = [UIFont fontWithSize:16];
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kScreenWidth - 140, 1000) text:contentAtt];
    
    CGSize titleSize = layout.textBoundingSize;
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:frame];
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIImageView *showImageView = [[UIImageView alloc]init];
    showImageView.frame = CGRectMake((frame.size.width - image.size.width)/2, (frame.size.height - 10 - titleSize.height - image.size.height)/2 + frame.origin.y, image.size.width, image.size.height);
    showImageView.image = [UIImage imageNamed:imageName];
    [backgroundView addSubview:showImageView];
    
    YYLabel *titleLb = [[YYLabel alloc] init];
    titleLb.frame = CGRectMake(15, CGRectGetMaxY(showImageView.frame)+12, kScreenWidth - 30, titleSize.height);
    titleLb.textColor = titleColor;
    titleLb.font = [UIFont fontWithSize:15];
    titleLb.numberOfLines = 0;
    titleLb.attributedText = contentAtt;
    titleLb.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:titleLb];
    
    
    
    self.backgroundView = backgroundView;
}

- (void)hiddenEmpty{
    self.backgroundView = nil;
}
@end
