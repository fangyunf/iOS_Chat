//
//  SWMessageConfigDelegate.m
//  ShenWU
//
//  Created by Amy on 2024/7/5.
//

#import "SWMessageConfigDelegate.h"
#import "ShenWU-Swift.h"
@implementation SWMessageConfigDelegate
- (BOOL)shouldIgnoreMessage:(NIMMessage *)message {
    /// 专属红包，非发送者和领取者不可见
    if (message.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *object = message.messageObject;
        if ([object.attachment isKindOfClass:[FRedPacketMessageModel class]]) {
            FRedPacketMessageModel *model = (FRedPacketMessageModel *)object.attachment;
            if (model.customType == 21) {
                if ([model.fromUserId isEqualToString:[FUserModel sharedUser].userID] || [model.toUserId isEqualToString:[FUserModel sharedUser].userID]) {
                    return NO;
                }else {
                    BOOL isAdmin = NO;
                    for (NSNumber *adminId in model.adminIds) {
                        if ([adminId integerValue] == [[FUserModel sharedUser].userID integerValue]) {
                            isAdmin = YES;
                            break;
                        }
                    }
                    return !isAdmin;
                }
            }
        }
        if ([object.attachment isKindOfClass:[TKEggExplodeMessageModel class]]) {
            NSLog(@"TKEggExplodeMessageModel---- TKEggExplodeMessageModel");
        }
    }
    if (message.messageType == NIMMessageTypeTip) {
        if ([message.text containsString:@"sendUserId"] && [message.text containsString:@"receiveUserId"]) {
            NSString *jsonStr = message.text;
            NSDictionary *dict = [FDataTool dictionaryWithJsonString:jsonStr];
            if ([FUserModel.sharedUser.userID isEqualToString:dict[@"sendUserId"]] || [FUserModel.sharedUser.userID isEqualToString:dict[@"receiveUserId"]]) {
                return NO;
            }
        }
        NSString *senderId = [message valueForKey:@"ext"];
        if ([message.from isEqualToString:[FUserModel sharedUser].userID] || [senderId isEqualToString:[FUserModel sharedUser].userID]) {
            return NO;
        }
        NSString *jsonStr = message.rawAttachContent;
        NSDictionary *dict = [FDataTool dictionaryWithJsonString:jsonStr];
        if (dict && [dict.allKeys count] != 0) {
            if ([dict[@"type"] integerValue] == 41) {
                NSString *contentStr = dict[@"content"];
                NSDictionary *contentDict = [FDataTool dictionaryWithJsonString:contentStr];
                if (contentDict) {
                    if ([contentDict[@"sendUserId"] integerValue] == [[FUserModel sharedUser].userID integerValue]) {
                        return NO;
                    }
                }
            }else if ([dict[@"type"] integerValue] == 17) {
                NSArray *adminsArr = dict[@"content"][@"admins"];
                if (adminsArr && adminsArr.count != 0) {
                    for (NSString *userId in adminsArr) {
                        if ([userId isEqualToString:[FUserModel sharedUser].userID]) {
                            return NO;
                        }
                    }
                }
            }
        }
        return YES;
    }
    return NO;
}


@end
