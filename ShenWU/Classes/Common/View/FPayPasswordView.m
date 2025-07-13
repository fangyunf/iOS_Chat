//
//  FPayPasswordView.m
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

#import "FPayPasswordView.h"
#import <Masonry/Masonry.h>

@implementation FPayTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

@end

#define payViewHeight 194

@interface FPayPasswordView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *showView;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) FPayTextField *payTextField;

@property (nonatomic, strong) NSArray<UILabel *> *labelsArr;

@property (nonatomic, strong) void(^successEnterTextFieldBlock)(NSString *string);

@end

@implementation FPayPasswordView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self makeUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)makeUI {
    self.backgroundColor = RGBAlphaColor(0x000000, 0.5);
    UIView *showView = self.showView;
    UIImageView *backImgView = [[UIImageView alloc] init];
    backImgView.contentMode = UIViewContentModeScaleAspectFill;
    backImgView.image = [UIImage imageNamed:@"bg_password_label"];
    
    UILabel *stateLabel = [UILabel YXInitWithBlock:^(UILabel *x) {
        x.text = @"请输入支付密码";
        x.textAlignment = NSTextAlignmentCenter;
        x.textColor = RGBColor(0x000000);
        x.font = [UIFont boldFontWithSize:14];
    }];
    UIButton *closeBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_password_close"] target:self sel:@selector(closeBtnAction)];
    
    [self addSubview:showView];
    [showView addSubview:backImgView];
    [showView addSubview:closeBtn];
    [showView addSubview:stateLabel];
    [showView addSubview:self.priceLabel];
    [showView addSubview:self.payTextField];
    for (UILabel *label in self.labelsArr) {
        [showView addSubview:label];
    }
    
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self).mas_offset(0);
        make.height.mas_offset(payViewHeight);
    }];
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(showView).mas_offset(0);
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(showView).mas_offset(16);
        make.top.mas_equalTo(showView).mas_offset(27);
        make.size.mas_offset(CGSizeMake(14, 14));
    }];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(showView).mas_offset(0);
        make.top.mas_equalTo(showView).mas_offset(24);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(showView).mas_offset(0);
        make.top.mas_equalTo(stateLabel.mas_bottom).mas_offset(16);
    }];
    NSArray *centerArr = @[@(-120), @(-72), @(-24), @(24), @(72), @(120)];
    for (NSInteger index = 0; index < self.labelsArr.count; index ++) {
        NSInteger centerX = [centerArr[index] integerValue];
        UILabel *label = self.labelsArr[index];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.priceLabel.mas_bottom).mas_offset(16);
            make.centerX.mas_equalTo(showView).mas_offset(centerX);
            make.size.mas_offset(CGSizeMake(40, 40));
        }];
    }
    UILabel *firstL = self.labelsArr.firstObject;
    UILabel *lastL = self.labelsArr.lastObject;
    [self.payTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(firstL).mas_offset(0);
        make.right.mas_equalTo(lastL).mas_offset(0);
        make.height.mas_offset(0);
    }];
}

+ (void)showPayPrice:(NSString *)price success:(void (^)(NSString * _Nonnull))success {
    FPayPasswordView *payView = [[FPayPasswordView alloc] init];
    payView.priceLabel.text = [NSString stringWithFormat:@"¥%@",price];
    payView.successEnterTextFieldBlock = success;
    [[FControlTool keyWindow] addSubview:payView];
    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo([FControlTool keyWindow]).mas_offset(0);
    }];
    [payView.payTextField becomeFirstResponder];
}

#pragma  mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSInteger index = 0; index < self.labelsArr.count; index ++) {
            UILabel *label = self.labelsArr[index];
            if (index < textField.text.length) {
                label.text = @"●";
            }else {
                label.text = @"";
            }
        }
    });
    if (textField.text.length == 6 && self.successEnterTextFieldBlock) {
        self.successEnterTextFieldBlock(textField.text);
        [self removeFromSuperview];
    }
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.hidden == YES) {
        return;
    }
   
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        [self.showView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).mas_offset(-rect.size.height);
        }];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.hidden == YES) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.showView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).mas_offset(0);
        }];
    }];
}

#pragma mark - Action
- (void)closeBtnAction {
    [self removeFromSuperview];
}

- (void)labelTapAction {
    [self.payTextField becomeFirstResponder];
}

#pragma mark - lazy loading
- (UIView *)showView {
    if (!_showView) {
        _showView = [UIView YXInitWithBlock:^(UIView *x) {
            x.backgroundColor = UIColor.clearColor;
        }];
    }
    return _showView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel YXInitWithBlock:^(UILabel *x) {
            x.textColor = RGBColor(0x000000);
            x.font = [UIFont semiBoldFontWithSize:36];
            x.textAlignment = NSTextAlignmentCenter;
        }];
    }
    return _priceLabel;
}

- (FPayTextField *)payTextField {
    if (!_payTextField) {
        _payTextField = [[FPayTextField alloc] init];
        _payTextField.delegate = self;
        _payTextField.hidden = YES;
        _payTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _payTextField;
}

- (NSArray<UILabel *> *)labelsArr {
    if (!_labelsArr) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:6];
        for (NSInteger index = 0; index < 6; index ++) {
            UILabel *stateLabel = [FControlTool createLabel:@"" textColor:RGBColor(0x000000) font:[UIFont boldFontWithSize:18]];
            stateLabel.backgroundColor = RGBColor(0xF2F2F2);
            stateLabel.layer.masksToBounds = YES;
            stateLabel.layer.cornerRadius = 4;
            stateLabel.textAlignment = NSTextAlignmentCenter;
            stateLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapAction)];
            [stateLabel addGestureRecognizer:gesture];
            [arr addObject:stateLabel];
        }
        _labelsArr = [arr copy];
    }
    return _labelsArr;
}

@end
