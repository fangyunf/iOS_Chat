//
//  TKEggListModel.m
//  ShenWU
//
//  Created by Amy on 2024/8/27.
//

#import "TKEggListModel.h"

@implementation TKEggListItemModel
+(NSDictionary*)modelCustomPropertyMapper{
    return @{@"eggId":@"id"};
}
@end

@implementation TKEggListModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{@"data"  : TKEggListItemModel.class};
}
@end
