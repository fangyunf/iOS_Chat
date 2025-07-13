//
//  NSString+Extension.m
//  Assistant
//
//  Created by Amy on 2024/4/25.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (BOOL)isEmptyString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if([string isEqualToString:@"null"]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"None"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if (string.length == 0) {
        return YES;
    }
    return NO;
}

- (NSString *)mdSubstringToIndex:(NSInteger)index {
    if (self.length <= index) {
        return self;
    }
    NSRange rangeIndex = [self rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, index)];
    if (rangeIndex.length < self.length) {
        return [self substringWithRange:rangeIndex];
    }
    return self;
}

#pragma mark - 格式化的JSON格式的字符串转换成字典
- (NSDictionary *)dictionaryWithJsonString {
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        // DLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - 格式化的JSON格式的字符串转换成数组
- (NSArray *)arrWithJsonString {
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        // DLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

- (BOOL)matchSearch:(NSString*)content{
    NSString *pinyin = [self convertToPinyin];
    if ([self.lowercaseString containsString:content.lowercaseString] || [pinyin.lowercaseString containsString:content.lowercaseString]) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)convertToPinyin
{
    NSString * pinYinStr = [NSString string];
    if (self.length > 0){
        NSMutableString * pinYin = [[NSMutableString alloc]initWithString:self];
        //1.先转换为带声调的拼音
        if(CFStringTransform((__bridge CFMutableStringRef)pinYin, 0, kCFStringTransformMandarinLatin, NO)) {
            NSLog(@"pinyin: %@", pinYin);
        }
        //2.再转换为不带声调的拼音
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, 0, kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"pinyin: %@", pinYin);
            //3.去除掉首尾的空白字符和换行字符
            pinYinStr = [pinYin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //4.去除掉其它位置的空白字符和换行字符
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    }
    return pinYinStr;
}

@end
