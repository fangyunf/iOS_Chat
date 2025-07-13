//
//  SWBankCardViewController.h
//  ShenWU
//
//  Created by Amy on 2024/7/1.
//

#import "FBaseViewController.h"
#import "FBankCardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SWBankCardViewController : FBaseViewController
@property (nonatomic, assign) BOOL isWithdraw;
@property (nonatomic, copy) void(^selectBlock)(FBankCardModel *model);
@end

NS_ASSUME_NONNULL_END
