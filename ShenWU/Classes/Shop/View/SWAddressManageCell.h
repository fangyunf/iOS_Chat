//
//  SWAddressManageCell.h
//  ShenWU
//
//  Created by Amy on 2024/11/8.
//

#import <UIKit/UIKit.h>
#import "SWAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@class SWAddressManageCell;

@protocol SWAddressManageCellDelegate <NSObject>

- (void)deleteAddress:(SWAddressManageCell*)cell;

- (void)defaultAddress:(SWAddressManageCell*)cell;

- (void)editAddress:(SWAddressManageCell*)cell;

@end

@interface SWAddressManageCell : UITableViewCell
@property(nonatomic, weak) id<SWAddressManageCellDelegate>delegate;
- (void)refreshCellWithData:(SWAddressModel*)data;
@end

NS_ASSUME_NONNULL_END
