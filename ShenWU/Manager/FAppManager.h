//
//  FAppManager.h
//  Fiesta
//
//  Created by Amy on 2024/5/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FAppManager : NSObject
@property(nonatomic, assign) CGFloat fontSize;
+ (instancetype)sharedManager;
- (float)readCacheSize;
- (void)clearFile;
@end

NS_ASSUME_NONNULL_END
