//
//  FGroupModel.m
//  Fiesta
//
//  Created by Amy on 2024/6/8.
//

#import "FGroupModel.h"

@implementation FGroupUserInfoModel

@end

@implementation FGroupModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{@"members"  : FGroupUserInfoModel.class};
}
@end
