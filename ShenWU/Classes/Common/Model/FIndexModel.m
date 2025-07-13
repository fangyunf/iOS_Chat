//
//  FIndexModel.m
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

#import "FIndexModel.h"

@implementation FIndexModel
#pragma mark - 单例
static FIndexModel *sharedManager;
+ (instancetype)shareModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[FIndexModel alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.uSwitch = YES;
        self.officialUrl = [self guanwangUrl];
        self.fwxyUrl = [self fwxyUrl];
        self.yszcUrl = [self yszcUrl];
        self.aboutUsStr = @"";
        self.downloadUrl = @"";
        self.keyword = @[];
    }
    return self;
}

- (NSString *)aboutUsStr {
    if (!_aboutUsStr || [_aboutUsStr isKindOfClass:[NSNull class]]) {
        return @"";
    }else {
        return _aboutUsStr;
    }
}

- (NSString *)guanwangUrl {
    return [self webUrl:@"pages/index/guanwang"];
}

- (NSString *)yszcUrl {
    return [self webUrl:@"pages/index/yszc"];
}

- (NSString *)fwxyUrl {
    return [self webUrl:@"pages/index/fwxy"];
}

- (NSString *)webUrl:(NSString *)str {
    return [NSString stringWithFormat:@"%@%@",webBaseUrl,str];
}

@end
