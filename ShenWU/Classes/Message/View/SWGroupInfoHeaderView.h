//
//  SWGroupInfoHeaderView.h
//  ShenWU
//
//  Created by Amy on 2024/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    GroupSettingTypeHost = 1,
    GroupSettingTypeManage,
    GroupSettingTypeCommon,
} GroupSettingType;

@interface SWGroupInfoHeaderView : UIView
@property(nonatomic, strong) UILabel *announcementDetailLabel;
@property(nonatomic, strong) UILabel *introDetailLabel;
@property (nonatomic, copy) void (^reloadBlock)(void);
- (instancetype)initWithFrame:(CGRect)frame type:(GroupSettingType)type;
- (void)refreshViewWithData:(FGroupModel*)model;
- (void)editBtnAction;
@end

NS_ASSUME_NONNULL_END
