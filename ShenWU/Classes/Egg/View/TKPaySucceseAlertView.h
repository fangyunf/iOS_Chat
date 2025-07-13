//
//  TKPaySucceseAlertView.h
//  ShenWU
//
//  Created by Amy on 2024/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKPaySucceseAlertView : UIView
@property(nonatomic, copy) void(^clickOnSureBtn)(void);
- (instancetype)initWithFrame:(CGRect)frame bgImgStr:(NSString*)bgImgStr title:(NSString*)title des:(NSString*)des btnStr:(NSString*)btnStr;
@end

NS_ASSUME_NONNULL_END
