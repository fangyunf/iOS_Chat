//
//  SWGroupInfoViewController.h
//  ShenWU
//
//  Created by Amy on 2024/6/24.
//

#import "FBaseViewController.h"
#import "SWGroupInfoHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWGroupInfoViewController : FBaseViewController
@property(nonatomic, assign) GroupSettingType type;
@property(nonatomic, strong) FGroupModel *model;
@end

NS_ASSUME_NONNULL_END
