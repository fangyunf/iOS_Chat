//
//  SWEditNameView.h
//  ShenWU
//
//  Created by Amy on 2024/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWEditNameView : UIView
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSString *nickName;
@property (nonatomic,copy) void(^saveName)(NSString *name);
- (void)show;
@end

NS_ASSUME_NONNULL_END
