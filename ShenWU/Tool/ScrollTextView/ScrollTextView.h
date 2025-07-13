//
//  ScrollTextView.h
//  Fiesta
//
//  Created by A on 2024/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TextScrollMode){
    TextScrollContinuous,     //连续的滚动
    TextScrollSpace,          //间隔的滚动
    TextScrollRound           //往复的滚动
};


typedef NS_ENUM(NSInteger,TextScrollDirection){
    TextScrollMoveLeft,       //向左滚动
    TextScrollMoveRight       //向右滚动
};


@interface ScrollTextView : UIView

//滚动类型
@property (nonatomic) TextScrollMode textScrollMode;
//滚动方向
@property (nonatomic) TextScrollDirection textScrollDirection;
//字体颜色
@property (nonatomic,strong) UIColor * textColor;
//文字内容
@property (nonatomic,strong) NSString * text;
//字体大小
@property (nonatomic,strong) UIFont * textFont;
//滚动速度 不设置就默认
@property (nonatomic)CGFloat speed;
//连续滚动时两段之间间隔大小
@property (nonatomic)CGFloat disance;

//开始滚动
- (void)startScroll;
@end


NS_ASSUME_NONNULL_END
