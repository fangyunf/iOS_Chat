//
//  SWAddressModel.h
//  ShenWU
//
//  Created by Amy on 2024/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWAddressModel : NSObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *detail;
@property(nonatomic, assign) BOOL isDefault;
@end

NS_ASSUME_NONNULL_END
