//
//  FLittleHelperListModel.m
//  Fiesta
//
//  Created by Amy on 2024/6/18.
//

#import "FLittleHelperListModel.h"

@implementation FLittleHelperModel
+(NSDictionary*)modelCustomPropertyMapper{
    return @{@"helperId":@"id"};
}
@end

@implementation FLittleHelperListModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{@"data"  : FLittleHelperModel.class};
}
@end

