//
//  UITableView+Empty.h
//  lpop
//
//  Created by Amy on 2022/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Empty)
- (void)showEmptyWtihFrame:(CGRect)frame imageName:(NSString*)imageName title:(NSString*)title;
- (void)showEmptyWtihFrame:(CGRect)frame imageName:(NSString*)imageName title:(NSString*)title titleColor:(UIColor*)titleColor;
- (void)hiddenEmpty;
@end

NS_ASSUME_NONNULL_END
