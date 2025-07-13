//
//  SWSearchView.h
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWSearchView : UIView
@property (nonatomic, copy) void (^searchBlock)(NSString *content);
@property (nonatomic, copy) void (^endSearchBlock)(void);
@property (nonatomic, strong) NSString *placeholder;
- (void)endSearchContent;
@end

NS_ASSUME_NONNULL_END
