//
//  FanExplosionGroupManager.h
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import <Foundation/Foundation.h>

@interface FanExplosionGroupManager : NSObject

+ (instancetype)sharedManager;

// Group data management
- (void)saveGroupData:(NSDictionary *)groupData;
- (NSArray *)getAllSavedGroups;
- (NSArray *)getGroupsOfType:(NSString *)type;
- (void)deleteGroupData:(NSString *)groupId;
- (void)clearAllGroupData;

// Explosion process management
- (void)startExplosionForGroup:(NSDictionary *)groupData 
                  progressBlock:(void(^)(NSInteger current, NSInteger total))progressBlock 
                completionBlock:(void(^)(BOOL success, NSInteger addedCount))completionBlock;
- (void)stopCurrentExplosion;

// Validation
- (BOOL)canStartExplosion;
- (NSString *)getExplosionStatusMessage;

@end