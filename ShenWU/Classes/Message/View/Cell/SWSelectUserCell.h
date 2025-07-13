//
//  SWSelectUserCell.h
//  ShenWU
//
//  Created by Amy on 2024/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SWSelectUserCell;

@protocol SWSelectUserCellDelegate <NSObject>
@optional
- (void)selectFriend:(SWSelectUserCell*)cell;
- (void)prohibitFriend:(SWSelectUserCell*)cell;
@end

@interface SWSelectUserCell : UITableViewCell
@property(nonatomic, weak) id <SWSelectUserCellDelegate>delegate;
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIButton *selectBtn;
@property(nonatomic, strong) UIButton *prohibitBtn;
@property(nonatomic, assign) BOOL isProhibit;
- (void)selectBtnAction;
@end

NS_ASSUME_NONNULL_END
