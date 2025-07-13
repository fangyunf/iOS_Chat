//
//  FVerifyAlertView.m
//  Fiesta
//
//  Created by Amy on 2024/6/6.
//

#import "FVerifyAlertView.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>
@interface FVerifyAlertView ()<UITextFieldDelegate>

/// 展示View
@property (nonatomic, strong) UIView *showView;

@property (nonatomic, strong) UIImageView *smsImgView;

@property (nonatomic, strong) UITextField *verifyCodeTF;

@end

@implementation FVerifyAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = RGBAlphaColor(0x000000, 0.5);
        [self makeUI];
        self.userInteractionEnabled = YES;
        self.showView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnBackGrayView)];
        [self addGestureRecognizer:gesture];
        UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeholderViewAction)];
        [self.showView addGestureRecognizer:gesture1];
    }
    return self;
}

- (void)makeUI {
    UIImageView *backImgView = [UIImageView YXInitWithBlock:^(UIImageView *x) {
        x.contentMode = UIViewContentModeScaleAspectFill;
        x.image = [UIImage imageNamed:@"UUTalk_Root_SmsCodeAlertView_Background"];
    }];
    UILabel *stateLabel = [UILabel YXInitWithBlock:^(UILabel *x) {
        x.text = @"图形验证码";
        x.textAlignment = NSTextAlignmentLeft;
        x.textColor = RGBColor(0x000000);
        x.font = [UIFont fontWithSize:18];
    }];
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage imageNamed:@"UUTalk_Root_SmsCodeAlertView_refreshBtn"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(clickOnRefreshAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *tfView = [UIView YXInitWithBlock:^(UIView *x) {
        x.layer.masksToBounds = YES;
        x.layer.cornerRadius = 8;
        x.backgroundColor = RGBColor(0xF2F2F2);
    }];
    UILabel *verifyLabel = [UILabel YXInitWithBlock:^(UILabel *x) {
        x.textColor = RGBColor(0x000000);
        x.font = [UIFont fontWithSize:16];
        x.text = @"验证码";
    }];
    UIButton *sureBtn = [FControlTool createCommonButtonWithText:@"完成" target:self sel:@selector(clickOnSureAction)];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldFontWithSize:16];
    
    [self addSubview:self.showView];
    [self.showView addSubview:backImgView];
    [self.showView addSubview:stateLabel];
    [self.showView addSubview:refreshBtn];
    [self.showView addSubview:self.smsImgView];
    [self.showView addSubview:tfView];
    [tfView addSubview:verifyLabel];
    [tfView addSubview:self.verifyCodeTF];
    [self.showView addSubview:sureBtn];
    
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self).mas_offset(0);
        make.width.mas_equalTo(self).mas_offset(-32);
    }];
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.mas_equalTo(self.showView).mas_offset(0);
    }];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.showView).mas_offset(16);
        make.top.mas_equalTo(self.showView).mas_offset(28);
    }];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.showView).mas_offset(-16);
        make.centerY.mas_equalTo(stateLabel).mas_offset(0);
        make.size.mas_offset(CGSizeMake(18, 15));
    }];
    [self.smsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stateLabel).mas_offset(0);
        make.right.mas_equalTo(refreshBtn).mas_offset(0);
        make.top.mas_equalTo(stateLabel.mas_bottom).mas_offset(8);
        make.height.mas_offset(53);
    }];
    [tfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.smsImgView).mas_offset(0);
        make.top.mas_equalTo(self.smsImgView.mas_bottom).mas_offset(12);
        make.height.mas_equalTo(self.smsImgView).mas_offset(0);
    }];
    [verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tfView).mas_offset(0);
        make.left.mas_equalTo(tfView).mas_offset(14);
        make.width.mas_offset(50);
    }];
    [self.verifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(verifyLabel).mas_offset(0);
        make.left.mas_equalTo(verifyLabel.mas_right).mas_offset(5);
        make.right.mas_equalTo(tfView).mas_offset(-14);
        make.height.mas_equalTo(tfView).mas_offset(0);
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(tfView).mas_offset(0);
        make.height.mas_offset(44);
        make.top.mas_equalTo(tfView.mas_bottom).mas_offset(12);
        make.bottom.mas_equalTo(self.showView).mas_offset(-12);
    }];
}

#pragma mark - Action
- (void)clickOnRefreshAction {
    if (self.clickOnRefreshBtn) {
        self.clickOnRefreshBtn();
    }
}

- (void)clickOnSureAction {
    if (self.verifyCodeTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (self.clickOnSureBtn) {
        self.clickOnSureBtn(self.verifyCodeTF.text);
    }
}

- (void)clickOnBackGrayView {
    [self removeFromSuperview];
}

- (void)placeholderViewAction {
    NSLog(@"无效");
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return NO;
}

#pragma mark - set
- (void)setSmsImgUrl:(NSString *)smsImgUrl {
    _smsImgUrl = smsImgUrl;
    @weakify(self);
    [[SDImageCache sharedImageCache] removeImageForKey:smsImgUrl withCompletion:^{
        @strongify(self);
        [self.smsImgView sd_setImageWithURL:[NSURL URLWithString:smsImgUrl] placeholderImage:[[UIImage alloc] init] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error == nil) {
                self.smsImgView.image = image;
                self.verifyCodeTF.text = @"";
            }else {
                self.verifyCodeTF.text = @"网络图片加载失败，请尝试手动刷新";
            }
        }];
        [self.verifyCodeTF becomeFirstResponder];
    }];
}

#pragma mark - lazy loading
- (UIView *)showView {
    if (!_showView) {
        _showView = [UIView YXInitWithBlock:^(UIView *x) {
            x.backgroundColor = [UIColor clearColor];
        }];
    }
    return _showView;
}

- (UIImageView *)smsImgView {
    if (!_smsImgView) {
        _smsImgView = [UIImageView YXInitWithBlock:^(UIImageView *x) {
            x.contentMode = UIViewContentModeScaleToFill;
            x.layer.masksToBounds = YES;
            x.layer.cornerRadius = 8;
            x.backgroundColor = RGBColor(0xF2F2F2);
        }];
    }
    return _smsImgView;
}

- (UITextField *)verifyCodeTF {
    if (!_verifyCodeTF) {
        _verifyCodeTF = [UITextField YXInitWithBlock:^(UITextField *x) {
            x.keyboardType = UIKeyboardTypeASCIICapable;
            x.font = [UIFont fontWithSize:16];
            x.placeholder = @"请输入验证码";
            x.returnKeyType = UIReturnKeyDone;
            x.delegate = self;
        }];
    }
    return _verifyCodeTF;
}

@end
