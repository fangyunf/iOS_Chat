//
//  FPayPasswordView.h
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPayTextField : UITextField

@end

@interface FPayPasswordView : UIView
+ (void)showPayPrice:(NSString *)price success:(void(^)(NSString *password))success;

@end

NS_ASSUME_NONNULL_END
