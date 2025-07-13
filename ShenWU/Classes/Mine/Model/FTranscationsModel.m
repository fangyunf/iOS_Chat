//
//  FTranscationsModel.m
//  Fiesta
//
//  Created by Amy on 2024/6/13.
//

#import "FTranscationsModel.h"

@implementation FTranscationsModel
+(NSDictionary*)modelCustomPropertyMapper{
    return @{@"transcationId":@"id"};
}
@end
