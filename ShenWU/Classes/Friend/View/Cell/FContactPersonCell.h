//
//  FContactPersonCell.h
//  Fiesta
//
//  Created by Amy on 2024/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FContactPersonCell;

@protocol FContactPersonCellDelegate <NSObject>

- (void)selectFriend:(FContactPersonCell*)cell;
- (void)prohibitFriend:(FContactPersonCell*)cell;
@end

@interface FContactPersonCell : UITableViewCell
@property(nonatomic, weak) id <FContactPersonCellDelegate>delegate;
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *numLabel;
@property(nonatomic, strong) UIButton *selectBtn;
@property(nonatomic, strong) UIButton *prohibitBtn;
@property(nonatomic, assign) BOOL isProhibit;
- (void)selectBtnAction;
@end

NS_ASSUME_NONNULL_END
