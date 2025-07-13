//
//  SWWalletMessageCell.h
//  ShenWU
//
//  Created by Amy on 2025/2/27.
//

#import <UIKit/UIKit.h>
#import "SWWalletMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SWWalletMessageCell : UITableViewCell
@property(nonatomic, assign) BOOL isRecharge;
@property(nonatomic, strong) SWWalletMessageItemModel *model;
@end

NS_ASSUME_NONNULL_END
