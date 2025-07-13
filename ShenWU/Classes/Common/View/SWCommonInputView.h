//
//  SWCommonInputView.h
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWCommonInputView : UIView
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextField *inputTextField;
@property(nonatomic, strong) NSString *placeholder;
@property(nonatomic, strong) UIView *inputBgView;
@end

NS_ASSUME_NONNULL_END
