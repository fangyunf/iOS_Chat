//
//  TKMemberListModel.h
//  ShenWU
//
//  Created by Amy on 2024/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKMemberItemConfigModel : NSObject
@property(nonatomic, strong) NSString *itemId;
@property(nonatomic, strong) NSString *memberLevel;
@property(nonatomic, strong) NSString *personNumGroup;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *productName;
@end

@interface TKMemberItemModel : NSObject
@property(nonatomic, strong) NSArray<NSString*> *memberCode;
@property(nonatomic, strong) TKMemberItemConfigModel *memberConfig;
@end

@interface TKMemberListModel : NSObject
@property(nonatomic, strong) NSArray<TKMemberItemModel*> *list;
@end

NS_ASSUME_NONNULL_END
