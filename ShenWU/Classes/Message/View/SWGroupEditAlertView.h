//
//  SWGroupEditAlertView.h
//  ShenWU
//
//  Created by Amy on 2024/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SWGroupEditAlertViewDelegate <NSObject>

- (void)editGroupName;

- (void)editGroupAnnouncement;

- (void)editGroupAvatar;

@end

@interface SWGroupEditAlertView : UIView
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, weak) id<SWGroupEditAlertViewDelegate>delegate;
- (void)show;
@end

NS_ASSUME_NONNULL_END
