//
//  SWLittleHelperCell.h
//  ShenWU
//
//  Created by Amy on 2024/6/29.
//

#import <UIKit/UIKit.h>
#import "FLittleHelperListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SWLittleHelperCell : UITableViewCell
- (void)refreshCellWithData:(FLittleHelperModel*)model;
@end

NS_ASSUME_NONNULL_END
