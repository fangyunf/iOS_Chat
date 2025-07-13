//
//  PSystomNotiModel.h
//  ShenWU
//
//  Created by Amy on 2024/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PSystomNotiModel : NSObject
@property(nonatomic,strong) NSString *notiId;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *createTime;
@property(nonatomic,assign) CGFloat contentHeight;
@end

NS_ASSUME_NONNULL_END
