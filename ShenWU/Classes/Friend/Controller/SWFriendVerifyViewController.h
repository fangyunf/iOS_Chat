//
//  SWFriendVerifyViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "FBaseViewController.h"
#import "FFriendApplyListModel.h"
NS_ASSUME_NONNULL_BEGIN

@class SWFriendVerifyViewController;

@protocol SWFriendVerifyViewControllerDelegate <NSObject>

- (void)refuseApply:(SWFriendVerifyViewController*)controller;
- (void)agreeApply:(SWFriendVerifyViewController*)controller;

@end

@interface SWFriendVerifyViewController : FBaseViewController
@property(nonatomic, strong) FFriendApplyModel *model;
@property(nonatomic, weak) id<SWFriendVerifyViewControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
