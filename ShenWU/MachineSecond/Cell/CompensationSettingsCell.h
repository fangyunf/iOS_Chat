//
//  CompensationGridCell.h
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import <UIKit/UIKit.h>
#import "MachineSecondManager.h"
@interface CompensationSettingsCell : UITableViewCell
@property (nonatomic, copy) void(^valueChangedBlock)(id value);
-(void)configureWithData:(NSDictionary *)data;
@end
