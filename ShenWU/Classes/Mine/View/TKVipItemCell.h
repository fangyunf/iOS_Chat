//
//  TKVipItemCell.h
//  ShenWU
//
//  Created by Amy on 2024/9/19.
//

#import "KJBannerViewCell.h"
#import "TKMemberListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TKVipItemCell : KJBannerViewCell
@property(nonatomic, strong) UIImageView *icnImgView;
- (void)refreshCellWithData:(TKMemberItemModel*)data;
@end

NS_ASSUME_NONNULL_END
