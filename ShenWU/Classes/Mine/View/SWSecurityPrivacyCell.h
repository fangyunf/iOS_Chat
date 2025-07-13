//
//  SWSecurityPrivacyCell.h
//  ShenWU
//
//  Created by Amy on 2024/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SWSecurityPrivacyCell;

@protocol SWSecurityPrivacyCellDelegate <NSObject>

- (void)switchHandleAction:(SWSecurityPrivacyCell*)cell;

@end

@interface SWSecurityPrivacyCell : UITableViewCell
@property(nonatomic, weak) id<SWSecurityPrivacyCellDelegate> delegate;
@property(nonatomic, strong) UIImageView *icnImgView;;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIButton *switchBtn;
@property(nonatomic, strong) UIImageView *arrowImgView;
@end

NS_ASSUME_NONNULL_END
