//
//  SWEditGroupNameViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/28.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWEditGroupNameViewController : FBaseViewController
@property(nonatomic, strong) FGroupModel *groupModel;
@property (nonatomic,copy) void(^saveName)(NSString *name);
@end

NS_ASSUME_NONNULL_END
