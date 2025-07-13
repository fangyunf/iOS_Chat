//
//  FMyCollectCell.h
//  Fiesta
//
//  Created by Amy on 2024/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMyCollectCell : UITableViewCell
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIImageView *contentImgView;
- (void)updateViewFrame:(BOOL)isImage;
@end

NS_ASSUME_NONNULL_END
