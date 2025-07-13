//
//  FMoreActionView.h
//  Fiesta
//
//  Created by Amy on 2024/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FMoreActionViewDelegate <NSObject>



@end

@interface FMoreActionView : UIView
@property(nonatomic, weak) id<FMoreActionViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
