//
//  SWWalletMessageModel.m
//  ShenWU
//
//  Created by Amy on 2025/2/27.
//

#import "SWWalletMessageModel.h"

@implementation SWWalletMessageItemModel

@end

@implementation SWWalletMessageModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{@"data"  : SWWalletMessageItemModel.class};
}
@end
