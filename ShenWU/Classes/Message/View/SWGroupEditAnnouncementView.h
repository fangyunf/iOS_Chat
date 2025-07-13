//
//  SWGroupEditAnnouncementView.h
//  ShenWU
//
//  Created by Amy on 2024/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWGroupEditAnnouncementView : UIView
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextView *inputTextView;
@property(nonatomic, strong) FGroupModel *model;
@property (nonatomic,copy) void(^saveName)(NSString *name);
- (void)show;
@end

NS_ASSUME_NONNULL_END
