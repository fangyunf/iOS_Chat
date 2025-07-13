//
//  SWMessageDetaillViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWMessageDetaillViewController : FBaseViewController
@property(nonatomic, strong) NSString *sessionId;
@property(nonatomic, assign) NIMSessionType type;
@property(nonatomic, strong) FGroupModel *groupModel;
@end

NS_ASSUME_NONNULL_END
