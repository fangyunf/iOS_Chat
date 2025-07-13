//
//  SWBindZfbViewController.h
//  ShenWU
//
//  Created by Amy on 2024/7/1.
//

#import "FBaseViewController.h"
#import "FBankCardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SWBindZfbViewController : FBaseViewController
@property(nonatomic, strong) FBankCardModel *model;
@property(nonatomic, assign) BOOL isWx;
@end

NS_ASSUME_NONNULL_END
