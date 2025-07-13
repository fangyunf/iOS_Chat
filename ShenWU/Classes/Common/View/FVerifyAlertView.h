//
//  FVerifyAlertView.h
//  Fiesta
//
//  Created by Amy on 2024/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FVerifyAlertView : UIView
/// sms图片路径
@property (nonatomic, strong) NSString *smsImgUrl;

@property(nonatomic, copy) void(^clickOnSureBtn)(NSString *code);

@property(nonatomic, copy) void(^clickOnRefreshBtn)(void);
@end

NS_ASSUME_NONNULL_END
