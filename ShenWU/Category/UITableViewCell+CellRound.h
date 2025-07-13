//
//  UITableViewCell+CellRound.h
//  InsightReader
//
//  Created by Amy on 2024/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (CellRound)
- (void)radius:(CGFloat)radius color:(UIColor *)color indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
