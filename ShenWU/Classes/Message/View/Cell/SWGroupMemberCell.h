//
//  SWGroupMemberCell.h
//  ShenWU
//
//  Created by Amy on 2024/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWGroupMemberCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *tagLabel;
@property(nonatomic, strong) UILabel *nameLabel;
- (void)refreshCellWithData:(FGroupUserInfoModel*)model;
@end

NS_ASSUME_NONNULL_END
