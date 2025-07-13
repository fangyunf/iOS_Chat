//
//  SWGroupManagerViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/26.
//

#import "FBaseViewController.h"
#import "SWGroupInfoHeaderView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SWGroupManagerViewController : FBaseViewController
@property(nonatomic, strong) FGroupModel *groupModel;
@property(nonatomic, assign) GroupSettingType type;
@property (nonatomic, copy) void (^reloadBlock)(void);
@end

NS_ASSUME_NONNULL_END
