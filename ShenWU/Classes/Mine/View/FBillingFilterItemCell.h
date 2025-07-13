//
//  FBillingFilterItemCell.h
//  Fiesta
//
//  Created by Amy on 2024/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBillingFilterItemCell : UICollectionViewCell
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
