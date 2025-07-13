//
//  SWGroupInfoCell.h
//  ShenWU
//
//  Created by Amy on 2024/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWGroupInfoCell : UITableViewCell
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) FGroupModel *model;
@property(nonatomic, copy) void(^refreshBlock)(void);
- (void)refreshCellWithData:(NSArray*)data;
@end

NS_ASSUME_NONNULL_END
