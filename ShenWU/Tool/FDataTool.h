//
//  FDataTool.h
//  Fiesta
//
//  Created by Amy on 2024/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDataTool : NSObject
+ (NSString *)getDateStringFromTimeInterval:(double)timeInterval formatterStr:(NSString *)formatterStr;
+ (NSString *)getUTCFormateDate:(NSString *)newsDate isList:(BOOL)isList;
+ (NSString *)convertToJsonData:(id)dict;
+ (NSMutableDictionary *)nullDicToDic:(NSDictionary *)dic;
+ (id)dictionaryWithJsonString:(NSString *)jsonString;
+ (BOOL)isNull:(id)object;
+ (BOOL)isStringContainABCandNumberWith:(NSString *)str;
+ (NSString*)getUnreadCount:(NSInteger)unreadCount;
+ (NSString * _Nonnull)handleTimeStamp:(NSInteger)timeStamp;
+ (NSString *)updataForNumberTimeYear:(NSString *)time formatter:(NSString*)formatter;
+ (NSArray*)getTransactionTypeDictionary;

/*** 存储图片到本地*/

+(void)storeImage:(NSData *)imageData withImageName:(NSString *)ImageName;

/*** 获取本地图片*/

+(NSData *)getImageWithImageName:(NSString *)ImageName;

/*** 删除本地图片*/

+(void)deleteImageWithImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
