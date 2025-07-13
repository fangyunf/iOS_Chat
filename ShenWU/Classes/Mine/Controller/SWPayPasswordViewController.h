//
//  SWPayPasswordViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/29.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PasswordTypeSetting,
    PasswordTypeEdit,
    PasswordTypeForgot,
} PasswordType;

@interface SWPayPasswordViewController : FBaseViewController
@property(nonatomic, assign) PasswordType type;
@end

NS_ASSUME_NONNULL_END
