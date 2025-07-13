//
//  NSString+Extension.h
//  Assistant
//
//  Created by Amy on 2024/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)
+ (BOOL)isEmptyString:(NSString *)string;
- (NSString *)mdSubstringToIndex:(NSInteger)index;

#pragma mark - 格式化的JSON格式的字符串转换成字典
- (NSDictionary *)dictionaryWithJsonString;

#pragma mark - 格式化的JSON格式的字符串转换成数组
- (NSArray *)arrWithJsonString;

- (BOOL)matchSearch:(NSString*)content;
@end

NS_ASSUME_NONNULL_END
