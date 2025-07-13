//
//  SWNewFriendCell.h
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import <UIKit/UIKit.h>
#import "FFriendApplyListModel.h"
#import "FApplyGroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SWNewFriendCell : UITableViewCell
@property(nonatomic, strong) UIButton *lookBtn;
@property(nonatomic, strong) UILabel *statusLabel;
@property(nonatomic, assign) BOOL isGroup;
- (void)refreshCellWithData:(FFriendApplyModel*)data;
- (void)refreshCellWithGroupData:(FApplyGroupModel*)data;
@end

NS_ASSUME_NONNULL_END
