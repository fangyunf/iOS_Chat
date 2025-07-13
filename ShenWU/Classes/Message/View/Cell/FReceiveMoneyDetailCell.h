//
//  FReceiveMoneyDetailCell.h
//  Fiesta
//
//  Created by Amy on 2024/6/1.
//

#import <UIKit/UIKit.h>
#import "FRedPacketDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FReceiveMoneyDetailCell : UITableViewCell
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, strong) UIButton *bestBtn;
- (void)refreshCellWithData:(FRedPacketUserModel*)data;
@end

NS_ASSUME_NONNULL_END
