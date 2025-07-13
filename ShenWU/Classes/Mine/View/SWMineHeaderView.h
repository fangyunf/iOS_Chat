//
//  SWMineHeaderView.h
//  ShenWU
//
//  Created by Amy on 2024/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWMineHeaderView : UIView
@property(nonatomic, strong) UILabel *balanceLabel;
- (void)refreshView;
@end

NS_ASSUME_NONNULL_END
