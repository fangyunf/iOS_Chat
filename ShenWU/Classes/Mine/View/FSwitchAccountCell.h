//
//  FSwitchAccountCell.h
//  Fiesta
//
//  Created by Amy on 2024/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSwitchAccountCell : UITableViewCell
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIImageView *avatarImgView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *idLabel;
@property(nonatomic, strong) UIButton *deleteBtn;
@property(nonatomic, strong) UILabel *tagLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) void (^deleteBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
