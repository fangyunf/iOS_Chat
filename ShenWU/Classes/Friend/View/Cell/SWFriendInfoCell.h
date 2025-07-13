//
//  SWFriendInfoCell.h
//  ShenWU
//
//  Created by Amy on 2024/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SWFriendInfoCell;

@protocol SWFriendInfoCellDelegate <NSObject>

- (void)switchHandleAction:(SWFriendInfoCell*)cell;

@end

@interface SWFriendInfoCell : UITableViewCell
@property(nonatomic, weak) id<SWFriendInfoCellDelegate>delegate;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIButton *switchBtn;
@property(nonatomic, strong) UIImageView *arrowImgView;
@end

NS_ASSUME_NONNULL_END
