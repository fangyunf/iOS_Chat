//
//  FBankCardModel.m
//  Fiesta
//
//  Created by Amy on 2024/6/14.
//

#import "FBankCardModel.h"

@implementation FBankCardModel
+(NSDictionary*)modelCustomPropertyMapper{
    return @{@"cardId":@"id"};
}
@end
