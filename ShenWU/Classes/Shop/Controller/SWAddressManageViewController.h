//
//  SWAddressManageViewController.h
//  ShenWU
//
//  Created by Amy on 2024/11/8.
//

#import "FBaseViewController.h"
#import "SWAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SWAddressManageViewController : FBaseViewController
@property(nonatomic, copy) void(^selectBlock)(SWAddressModel *model);
@end

NS_ASSUME_NONNULL_END
