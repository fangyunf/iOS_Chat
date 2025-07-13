//
//  TKEggListModel.h
//  ShenWU
//
//  Created by Amy on 2024/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKEggListItemModel : NSObject
@property(nonatomic, assign) NSInteger price;
@property(nonatomic, assign) NSInteger amount;
@property(nonatomic, assign) NSInteger state;
@property(nonatomic, assign) NSInteger groupLs;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *eggId;
@property(nonatomic, assign) NSInteger num;
@property(nonatomic, strong) NSString *groupName;
@property(nonatomic, strong) NSString *fafId;
@end

@interface TKEggListModel : NSObject
@property(nonatomic, strong) NSArray<TKEggListItemModel*> *data;
@end

NS_ASSUME_NONNULL_END
