//
//  SWBlackListCell.h
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWBlackListCell : UITableViewCell
@property(nonatomic, strong) UIButton *addBtn;
@property(nonatomic, strong) UIButton *removeBtn;
@property(nonatomic, assign) BOOL isGroup;
@property (nonatomic, copy) void (^removeBlackBlock)(void);
- (void)refreshCellWithData:(NIMUser*)model;
- (void)refreshCellWithModel:(FFriendModel*)model;
@end

NS_ASSUME_NONNULL_END
