//
//  FFriendApplyListModel.m
//  Fiesta
//
//  Created by Amy on 2024/6/6.
//

#import "FFriendApplyListModel.h"

@implementation FFriendApplyModel
+(NSDictionary*)modelCustomPropertyMapper{
    return @{@"applyId":@"id"};
}
@end

@implementation FFriendApplyListModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{@"data"  : FFriendApplyModel.class};
}
@end
