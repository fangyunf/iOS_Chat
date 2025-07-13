//
//  FCustomAttachemtDecoder.m
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

#import "FCustomAttachemtDecoder.h"
#import "ShenWU-Swift.h"
@implementation FCustomAttachemtDecoder
// 所有的自定义消息都会调用这个解码方法，如有多种自定义消息请在该方法中扩展，并自行实现自定义消息类型判断和版本兼容。

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
    id<NIMCustomAttachment> attachment;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSInteger type = [dict[@"type"] integerValue];
            NSString *json = dict[@"data"];
            if (type == 10086) {
                FUserCardMessageModel *model = [FUserCardMessageModel modelWithJSON:json];
                model.customType = 10086;
                model.cellHeight = 104;
                attachment = model;
            }else if (type == 525) {
                TKEggExplodeMessageModel *model = [TKEggExplodeMessageModel modelWithJSON:json];
                model.customType = 525;
                model.cellHeight = 104;
                attachment = model;
                NSLog(@"xxx ===:%@ %@ %ld",dict,model.modelToJSONObject,model.customType);
            }else if (type == 21 || type == 22 || type == 23 || type == 28) {
                FRedPacketMessageModel *model = [FRedPacketMessageModel modelWithJSON:json];
                model.customType = type;
                model.cellHeight = 134;
                attachment = model;
            }
        }
    }
    return attachment;
}
@end
