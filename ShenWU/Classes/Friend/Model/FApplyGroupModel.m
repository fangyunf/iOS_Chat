//
//  FApplyGroupModel.m
//  Fiesta
//
//  Created by Amy on 2024/6/14.
//

#import "FApplyGroupModel.h"

@implementation FApplyGroupModel
+(NSDictionary*)modelCustomPropertyMapper{
    return @{@"applyId":@"id"};
}
@end

@implementation FApplyGroupListModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{@"data"  : FApplyGroupModel.class};
}
@end
