//
//  FFriendApplyListModel.h
//  Fiesta
//
//  Created by Amy on 2024/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFriendApplyModel : NSObject
@property(nonatomic, strong) NSString *applyId;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSString *name;
//申请状态 0:未处理 1:同意 2:拒绝
@property(nonatomic, assign) NSInteger applyState;
@property(nonatomic, assign) NSInteger readState;
@property(nonatomic, strong) NSString *leaveMessage;
@property(nonatomic, strong) NSString *createTime;
@property(nonatomic, strong) NSString *memberCode;
@property(nonatomic, strong) NSString *applyUserId;
@end

@interface FFriendApplyListModel : NSObject
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, assign) NSInteger pages;
@property(nonatomic, strong) NSArray<FFriendApplyModel*> *data;
@end

NS_ASSUME_NONNULL_END
