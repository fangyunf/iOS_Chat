//
//  FDatePickerView.h
//  Fiesta
//
//  Created by Amy on 2024/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FDatePickerViewDelegate <NSObject>

- (void)getSelectDate:(NSString*)selectDate;

@end

@interface FDatePickerView : UIView
@property(nonatomic, weak) id<FDatePickerViewDelegate>delegate;
@property(nonatomic, strong) NSString *time;
- (void)showView;
@end

NS_ASSUME_NONNULL_END
