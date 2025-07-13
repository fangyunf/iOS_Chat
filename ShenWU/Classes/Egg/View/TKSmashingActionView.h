//
//  TKSmashingActionView.h
//  ShenWU
//
//  Created by Amy on 2024/8/10.
//

#import <UIKit/UIKit.h>
#import "TKEggListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TKSmashingActionView : UIView
@property(nonatomic, copy) void(^clickOnCloseBtn)(void);
- (instancetype)initWithFrame:(CGRect)frame isSuccess:(BOOL)isSuccess;
- (void)refreshViewWithData:(TKEggListItemModel*)data;
- (void)refreshSuccessViewWithData:(NSDictionary *)data;
- (void)removeTimer;
@end

NS_ASSUME_NONNULL_END
