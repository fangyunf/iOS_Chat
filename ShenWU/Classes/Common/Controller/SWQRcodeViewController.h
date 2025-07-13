//
//  SWQRcodeViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/21.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWQRcodeViewController : FBaseViewController
@property(nonatomic, assign) BOOL isGroup;
@property(nonatomic, strong) FGroupModel *groupModel;
@end

NS_ASSUME_NONNULL_END
