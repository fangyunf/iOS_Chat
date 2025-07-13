//
//  FReceiveTransferViewController.h
//  ShenWU
//
//  Created by Amy on 2024/10/10.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FReceiveTransferViewController : FBaseViewController
@property(nonatomic, strong) NSString *sendUserId;
@property(nonatomic, strong) NSDictionary *redPacketDict;
@end

NS_ASSUME_NONNULL_END
