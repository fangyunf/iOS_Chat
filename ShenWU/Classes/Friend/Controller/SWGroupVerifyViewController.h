//
//  SWGroupVerifyViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/30.
//

#import "FBaseViewController.h"
#import "FApplyGroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@class SWGroupVerifyViewController;

@protocol SWGroupVerifyViewControllerDelegate <NSObject>

- (void)groupRefuseApply:(SWGroupVerifyViewController*)controller;
- (void)groupAgreeApply:(SWGroupVerifyViewController*)controller;

@end

@interface SWGroupVerifyViewController : FBaseViewController
@property(nonatomic, strong) FApplyGroupModel *model;
@property(nonatomic, weak) id<SWGroupVerifyViewControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
