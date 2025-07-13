//
//  FRedPacketDetailModel.m
//  Fiesta
//
//  Created by Amy on 2024/6/13.
//

#import "FRedPacketDetailModel.h"

@implementation FRedPacketUserModel
+(NSDictionary*)modelCustomPropertyMapper{
    return @{@"detailId":@"id"};
}
@end


@implementation FRedPacketDetailModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{@"vos"  : FRedPacketUserModel.class};
}
@end
