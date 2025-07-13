//
//  FBillingDetailsCell.h
//  Fiesta
//
//  Created by Amy on 2024/5/28.
//

#import <UIKit/UIKit.h>
#import "FTranscationsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FBillingDetailsCell : UITableViewCell
@property(nonatomic, strong) UIImageView *iconImgView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, strong) UILabel *balanceLabel;
- (void)refreshCellWithData:(FTranscationsModel*)data;
@end

NS_ASSUME_NONNULL_END
