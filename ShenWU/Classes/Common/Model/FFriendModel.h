//
//  FFriendModel.h
//  Fiesta
//
//  Created by Amy on 2024/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFriendModel : NSObject
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *remark;
@property(nonatomic, strong) NSString *memberCode;
@property(nonatomic, strong) NSString *qrCode;
@property(nonatomic, assign) NSInteger grade;
@property(nonatomic, assign) NSInteger friend;
@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, assign) BOOL isGroupSelected;
@end

NS_ASSUME_NONNULL_END
