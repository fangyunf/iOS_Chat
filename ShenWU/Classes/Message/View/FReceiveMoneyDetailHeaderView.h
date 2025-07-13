//
//  FReceiveMoneyDetailHeaderView.h
//  Fiesta
//
//  Created by Amy on 2024/6/1.
//

#import <UIKit/UIKit.h>
#import "FRedPacketDetailModel.h"
#import "ShenWU-Swift.h"
NS_ASSUME_NONNULL_BEGIN

@interface FReceiveMoneyDetailHeaderView : UIView
@property(nonatomic, assign) NSInteger customType;
@property(nonatomic, strong) NSString *fromUserId;
- (void)changeViewFrame:(NSString*)toUserId;
- (void)refreshViewWithData:(FRedPacketDetailModel*)model;
- (void)refreshTransferViewWithData:(NSDictionary*)data;
@end

NS_ASSUME_NONNULL_END
