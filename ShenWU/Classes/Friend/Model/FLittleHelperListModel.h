//
//  FLittleHelperListModel.h
//  Fiesta
//
//  Created by Amy on 2024/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLittleHelperModel : NSObject
@property(nonatomic, strong) NSString *helperId;
@property(nonatomic, strong) NSString *userId;
/// 金额
@property(nonatomic, assign) NSInteger money;
/**
 *     SYS_NEWS(101,"小助手消息"),
 *     RECHARGE(102,"充值成功"),
 *     AUDIT(103,"提现审核"),
 *     WITHDRAW_SUCCESS(104,"提现成功"),
 *     WITHDRAW_ERR(105,"提现失败"),
 *     RED_BACK(106,"红包退回"),
       SYS_MSG(107,"系统消息"),
  */
@property(nonatomic, assign) NSInteger state;
/// 收款方式
@property(nonatomic, strong) NSString *payTerm;
/// 交易状态
@property(nonatomic, strong) NSString *payMsg;
/// 系统消息
@property(nonatomic, strong) NSString *msg;
@property(nonatomic, strong) NSString *createTime;
@end

@interface FLittleHelperListModel : NSObject
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, assign) NSInteger pages;
@property(nonatomic, strong) NSArray<FLittleHelperModel*> *data;
@end

NS_ASSUME_NONNULL_END
