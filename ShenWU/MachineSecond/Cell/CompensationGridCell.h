//
//  CompensationGridCell.h
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import <UIKit/UIKit.h>
#import "MachineSecondManager.h"
@interface CompensationGridCell : UITableViewCell

@property (nonatomic, copy) void(^matrixUpdateBlock)(NSString *thunder, NSString *packet, NSString *value);

- (void)configureWithData:(NSDictionary *)data compensationMatrix:(NSDictionary *)matrix;

@end
