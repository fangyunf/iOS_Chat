//
//  FTranscationsModel.h
//  Fiesta
//
//  Created by Amy on 2024/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTranscationsModel : NSObject
@property(nonatomic, assign) NSInteger amount;
@property(nonatomic, assign) NSInteger balance;
@property(nonatomic, strong) NSString *createTime;
@property(nonatomic, assign) BOOL deleted;
@property(nonatomic, strong) NSString *transcationId;
@property(nonatomic, assign) NSInteger moduleType;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *redpacketId;
@property(nonatomic, strong) NSString *remark;
@property(nonatomic, assign) NSInteger rowVersion;
@property(nonatomic, strong) NSString *traceId;
@property(nonatomic, strong) NSString *updateTime;
@property(nonatomic, strong) NSString *userId;
@end

NS_ASSUME_NONNULL_END
