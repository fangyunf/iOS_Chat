//
//  FAccountSafeModel.h
//  Fiesta
//
//  Created by Amy on 2024/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FAccountSafeModel : NSObject
@property(nonatomic, assign) BOOL check;
@property(nonatomic, assign) BOOL phoneAdd;
@property(nonatomic, assign) BOOL idAdd;
@property(nonatomic, assign) BOOL cardAdd;
@property(nonatomic, assign) BOOL qrAdd;
@property(nonatomic, assign) BOOL addState;
@property(nonatomic, assign) BOOL addGroupState;
@end

NS_ASSUME_NONNULL_END
