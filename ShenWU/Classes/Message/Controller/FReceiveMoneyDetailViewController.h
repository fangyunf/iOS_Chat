//
//  FReceiveMoneyDetailViewController.h
//  Fiesta
//
//  Created by Amy on 2024/6/1.
//

#import "FBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ReceiveMoneyTypeLucky,
    ReceiveMoneyTypeLuckyFinish,
    ReceiveMoneyTypeExclusiveNoGet,
    ReceiveMoneyTypeExclusiveOtherGet,
    ReceiveMoneyTypeExclusiveMyGet,
} ReceiveMoneyType;

@interface FReceiveMoneyDetailViewController : FBaseViewController
@property(nonatomic, assign) ReceiveMoneyType type;
@property(nonatomic, assign) BOOL isLook;
@property(nonatomic, strong) NSDictionary *redPacketDict;
@end

NS_ASSUME_NONNULL_END
