//
//  FDataTool.m
//  Fiesta
//
//  Created by Amy on 2024/6/3.
//

#import "FDataTool.h"

static NSDateFormatter *dateFormatter = nil;

@implementation FDataTool

+ (NSString *)getDateStringFromTimeInterval:(double)timeInterval formatterStr:(NSString *)formatterStr{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)getUTCFormateDate:(NSString *)newsDate isList:(BOOL)isList
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSDate* current_date = [NSDate date];
    NSString * locationString = [dateFormatter stringFromDate:current_date];
    current_date = [dateFormatter dateFromString:locationString];
    
    
    [dateFormatter setDateFormat:@"MM"];
    NSInteger month = [[dateFormatter stringFromDate:newsDateFormatted] integerValue];
    NSInteger nowMonth = [[dateFormatter stringFromDate:current_date] integerValue];
    
    [dateFormatter setDateFormat:@"dd"];
    NSInteger day = [[dateFormatter stringFromDate:newsDateFormatted] integerValue];
    NSInteger nowDay = [[dateFormatter stringFromDate:current_date] integerValue];
    
    NSString *dateContent;
    
    NSString *hoursMinute = [newsDate substringFromIndex:6];
    if (nowMonth - month == 0) {
        if (nowDay - day == 0) {
            if(isList){
                dateContent = [NSString stringWithFormat:@"%@",hoursMinute];
            }else{
                dateContent = [NSString stringWithFormat:@"%@ %@",@"今天",hoursMinute];
            }
            
        }else  if (nowDay - day == 1) {
            if (isList) {
                dateContent = [newsDate substringToIndex:5];
            }else{
                dateContent = [NSString stringWithFormat:@"%@ %@",@"昨天",hoursMinute];
            }
        }else{
            if(isList){
                dateContent = [newsDate substringToIndex:5];
            }else{
                dateContent = newsDate;
            }
        }
    }else{
        if(isList){
            dateContent = [newsDate substringToIndex:5];
        }else{
            dateContent = newsDate;
        }
    }
    
    return dateContent;
}

+ (NSString *)convertToJsonData:(id)dict {
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

+ (NSMutableDictionary *)nullDicToDic:(NSDictionary *)dic {
    NSMutableDictionary *resultDic = [@{} mutableCopy];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return resultDic;
    }
    for (NSString *key in [dic allKeys]) {
        if ([(id)[dic objectForKey:key] isKindOfClass:[NSNull class]]) {
            [resultDic setValue:@"" forKey:key];
        }else{
            [resultDic setValue:[dic objectForKey:key] forKey:key];
        }
    }
    return resultDic;
}

+ (id)dictionaryWithJsonString:(NSString *)jsonString {
   if (jsonString == nil) {
       return nil;
   }

   NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
   NSError *err;
   id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                            options:NSJSONReadingAllowFragments
                                              error:nil];
   if(err)
   {
       NSLog(@"json解析失败：%@",err);
       return nil;
   }
   return dic;
}

+ (BOOL)isNull:(id)object
{
    if (([object isEqual:[NSNull null]]) || (object == nil) || (object == NULL)) {
        return YES;
    }
    if ([object isKindOfClass:[NSString class]]) {
        if(object==nil){
            return YES;
        }
        return [object isEqualToString:@""];
    }
    return NO;
}

+ (BOOL)isStringContainABCandNumberWith:(NSString *)str {
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];//count是str中包含[A-Za-z0-9]数字的个数，只要count>0，说明str中包含数字
    if(count > 0) {
        return YES;
    }
    return NO;
}

+ (NSString*)getUnreadCount:(NSInteger)unreadCount{
    if (unreadCount > 99) {
        return @"99+";
    }else if(unreadCount < 0){
        return nil;
    }else{
        return [NSString stringWithFormat:@"%ld",unreadCount];
    }
}

+ (NSString * _Nonnull)handleTimeStamp:(NSInteger)timeStamp{
    NSString *time = [NSString stringWithFormat:@"%ld", timeStamp / 1000];
    NSString *timeStr = [FDataTool updataForNumberTimeYear:time formatter:@"YYYY:MM:dd HH:mm:ss"];
    NSInteger timeIn = [FDataTool getTimeStampWithTheTimeString:timeStr AndTimeFormat:@"YYYY:MM:dd HH:mm:ss"];
    return [FDataTool compareCurrentTime:timeIn];
}

+ (NSString *)updataForNumberTimeYear:(NSString *)time formatter:(NSString*)formatter {
    //转换
    NSTimeInterval time1= [time integerValue];
    NSDate *detaildate =[NSDate dateWithTimeIntervalSince1970:time1];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *forMatterTime = [dateFormatter stringFromDate:detaildate];
    if (forMatterTime.length > 10) {
        [forMatterTime substringFromIndex:10];
    }
    return forMatterTime;
}

+ (NSTimeInterval)getTimeStampWithTheTimeString:(NSString *)time AndTimeFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss")
    //----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:time]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]*1000] integerValue];
    return timeSp;
}

+ (NSString * _Nonnull)compareCurrentTime:(NSTimeInterval)compareDate {
    
    NSDate *confromTimesp        = [NSDate dateWithTimeIntervalSince1970:compareDate/1000];
    
    NSTimeInterval  timeInterval = [confromTimesp timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    
    NSCalendar *calendar     = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents*referenceComponents=[calendar components:unitFlags fromDate:confromTimesp];
    NSInteger referenceHour  =referenceComponents.hour;
    
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp= timeInterval/60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = timeInterval/3600) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if ((temp = timeInterval/3600/24)==1)
    {
        result = [NSString stringWithFormat:@"昨天%ld时",(long)referenceHour];
    }
    else if ((temp = timeInterval/3600/24)==2)
    {
        result = [NSString stringWithFormat:@"前天%ld时",(long)referenceHour];
    }
    
    else if((temp = timeInterval/3600/24) <31){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = timeInterval/3600/24/30) <12){
        result = [NSString stringWithFormat:@"%ld个月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}

+ (NSArray*)getTransactionTypeDictionary{
    NSArray *arr = @[@{@"title":@"全部",@"type":@(-1),@"imageName":@""},
                     @{@"title":@"发送群红包",@"type":@(23),@"imageName":@"icn_send_red_packet"},
                     @{@"title":@"领取群红包",@"type":@(26),@"imageName":@"icn_re_red_packet"},
                     @{@"title":@"发送专属红包",@"type":@(21),@"imageName":@"icn_send_red_packet"},
                     @{@"title":@"领取专属红包",@"type":@(24),@"imageName":@"icn_re_red_packet"},
                     @{@"title":@"发送个人红包",@"type":@(22),@"imageName":@"icn_send_red_packet"},
                     @{@"title":@"领取个人红包",@"type":@(25),@"imageName":@"icn_re_red_packet"},
                     @{@"title":@"充值",@"type":@(0),@"imageName":@"icn_detail_pay"},
                     @{@"title":@"提现",@"type":@(1),@"imageName":@"icn_detail_pay"},
                     @{@"title":@"红包退回",@"type":@(27),@"imageName":@"icn_detail_pay"},
                     @{@"title":@"提现驳回",@"type":@(5),@"imageName":@"icn_detail_pay"},
                     @{@"title":@"抽奖",@"type":@(80),@"imageName":@"icn_detail_pay"},
                     @{@"title":@"买靓号",@"type":@(78),@"imageName":@"icn_detail_pay"},
                     @{@"title":@"买副号",@"type":@(91),@"imageName":@"icn_detail_pay"},
                     @{@"title":@"购买彩蛋",@"type":@(92),@"imageName":@"icn_detail_pay"},
                     @{@"title":@"获得彩蛋",@"type":@(93),@"imageName":@"icn_detail_pay"},
                     @{@"title":@"群升级",@"type":@(141),@"imageName":@"icn_detail_pay"},
                     @{@"title":@"转账",@"type":@(28),@"imageName":@"icn_send_red_packet"},
                     @{@"title":@"转账",@"type":@(503),@"imageName":@"icn_send_red_packet"}];
    return arr;
}

/***图片存储到本地Document目录下，ImageName是图片的唯一标识符*/

+(void)storeImage:(NSData *)imageData withImageName:(NSString *)ImageName {
    if (imageData && ImageName.length > 0 && ImageName) {

        NSFileManager *fileManage=[NSFileManager defaultManager];
        //把图片存储在沙盒中，首先获取沙盒路径

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];//Documents目录
        //在Documents下面创建一个Image的文件夹的路径
        NSString *createPath = [NSString stringWithFormat:@"%@/Images",documentsDirectory];
        //没有这个文件夹的话就创建这个文件夹
        if(![fileManage fileExistsAtPath:createPath]){
            [fileManage createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
            NSLog(@"已创建文件夹");
        }
        //把数据以.png的形式存储在沙盒中，路径为可变路径
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpg",createPath,ImageName];
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:imageData attributes:nil];
    }
}

+(NSData *)getImageWithImageName:(NSString *)ImageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSString *filePath = [NSString stringWithFormat:@"%@/Images/%@.jpg",documentsDirectory,ImageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *imageData;
    //如果存在存储图片的文件，则根据路径取出图片
    if ([fileManager fileExistsAtPath:filePath]) {
        imageData = [NSData dataWithContentsOfFile:filePath];
    }
    return imageData;
}

+(void)deleteImageWithImageName:(NSString *)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSString *filePath = [NSString stringWithFormat:@"%@/Images/%@.jpg",documentsDirectory,imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
}

@end
