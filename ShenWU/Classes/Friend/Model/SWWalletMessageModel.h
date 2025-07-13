//
//  SWWalletMessageModel.h
//  ShenWU
//
//  Created by Amy on 2025/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWWalletMessageItemModel : NSObject
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *amount;
@property(nonatomic,strong) NSString *remitAmount;
@property(nonatomic,strong) NSString *state;
@property(nonatomic,strong) NSString *balance;
@property(nonatomic,strong) NSString *createTime;
@property(nonatomic,strong) NSString *callBackTime;
@property(nonatomic,strong) NSString *orderCode;
@property(nonatomic,assign) CGFloat contentHeight;
@end

@interface SWWalletMessageModel : NSObject
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, assign) NSInteger pages;
@property(nonatomic,strong) NSArray<SWWalletMessageItemModel*> *data;
@end

NS_ASSUME_NONNULL_END
