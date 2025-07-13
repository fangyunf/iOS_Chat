//
//  PSystomNotiCell.h
//  ShenWU
//
//  Created by Amy on 2024/7/20.
//

#import <UIKit/UIKit.h>
#import "PSystomNotiModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PSystomNotiCell : UITableViewCell
- (void)refreshCellWithData:(PSystomNotiModel*)data;
@end

NS_ASSUME_NONNULL_END
