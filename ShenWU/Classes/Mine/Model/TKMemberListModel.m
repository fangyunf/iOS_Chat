//
//  TKMemberListModel.m
//  ShenWU
//
//  Created by Amy on 2024/9/19.
//

#import "TKMemberListModel.h"

@implementation TKMemberItemConfigModel
+(NSDictionary*)modelCustomPropertyMapper{
    return @{@"itemId":@"id"};
}
@end

@implementation TKMemberItemModel

@end

@implementation TKMemberListModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{@"list"  : TKMemberItemModel.class};
}
@end
