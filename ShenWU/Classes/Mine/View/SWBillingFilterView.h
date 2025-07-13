//
//  SWBillingFilterView.h
//  ShenWU
//
//  Created by Amy on 2024/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWBillingFilterView : UIView
@property(nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy) void(^selectBlock)(NSInteger index);
@property (nonatomic, copy) void(^dismissBlock)(void);
@end

NS_ASSUME_NONNULL_END
