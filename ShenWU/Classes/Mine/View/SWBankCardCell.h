//
//  SWBankCardCell.h
//  ShenWU
//
//  Created by Amy on 2024/7/1.
//

#import <UIKit/UIKit.h>
#import "FBankCardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SWBankCardCell : UITableViewCell
@property (nonatomic, copy) void(^unbindBlock)(NSInteger index);
- (void)refreshCellWithData:(FBankCardModel*)data;
@end

NS_ASSUME_NONNULL_END
