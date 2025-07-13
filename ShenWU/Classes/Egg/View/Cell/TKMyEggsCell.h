//
//  TKMyEggsCell.h
//  ShenWU
//
//  Created by Amy on 2024/8/25.
//

#import <UIKit/UIKit.h>
#import "TKEggListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TKMyEggsCell : UITableViewCell
@property(nonatomic, copy) void(^clickOnIssueBtn)(void);
- (void)refreshCellWithData:(TKEggListItemModel*)data;
@end

NS_ASSUME_NONNULL_END
