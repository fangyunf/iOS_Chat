//
//  SWSecurityVerifyViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/19.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWCodeTextField : UITextField

@end

@interface SWSecurityVerifyViewController : FBaseViewController
@property(nonatomic, strong) NSString *phone;
@end

NS_ASSUME_NONNULL_END
