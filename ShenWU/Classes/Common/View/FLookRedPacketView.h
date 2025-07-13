//
//  FRedPacketView.h
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RedPacketTypeStart,
    RedPacketTypeFinish,
    RedPacketTypeExclusiveStart,
    RedPacketTypeExclusiveFinish,
} RedPacketStatus;

@interface FLookRedPacketView : UIView
@property(nonatomic, assign) RedPacketStatus type;
@property(nonatomic, strong) NSString *sessionId;
- (void)loadData:(NSDictionary*)data modelDict:(NSDictionary*)modelDict success:(void(^)(NSDictionary *response))success;
@end

NS_ASSUME_NONNULL_END
