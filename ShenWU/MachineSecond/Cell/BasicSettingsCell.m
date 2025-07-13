//
//  BasicSettingsCell.m
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import "BasicSettingsCell.h"
#import "FControlTool.h"
#import <YYKit/YYKit.h>

@interface BasicSettingsCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIButton *switchControl;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) NSDictionary *currentData;

@end

@implementation BasicSettingsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    self.containerView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.containerView];
    
    self.titleLabel = [FControlTool createLabel:@"" 
                                  textColor:[UIColor whiteColor] 
                                       font:[UIFont systemFontOfSize:16] 
                                  alignment:NSTextAlignmentLeft 
                                    lineNum:1];
    [self.containerView addSubview:self.titleLabel];
    
    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.layer.cornerRadius = 4;
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.textColor = [UIColor blackColor];
    self.textField.delegate = self;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.containerView addSubview:self.textField];
    
    self.actionButton = [FControlTool createButton:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] target:self sel:@selector(actionButtonTapped)];
    self.actionButton.backgroundColor = [UIColor whiteColor];
    self.actionButton.layer.cornerRadius = 4;
    [self.containerView addSubview:self.actionButton];
    
    self.switchControl = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_second_off"] target:self sel:@selector(switchChanged:)];
    [self.switchControl setImage:[UIImage imageNamed:@"icn_second_on"] forState:UIControlStateSelected];
    [self.containerView addSubview:self.switchControl];
    
    self.descriptionLabel = [FControlTool createLabel:@"" 
                                        textColor:[UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0] 
                                             font:[UIFont systemFontOfSize:12] 
                                        alignment:NSTextAlignmentLeft 
                                          lineNum:0];
    [self.containerView addSubview:self.descriptionLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat containerHeight = self.contentView.frame.size.height - 2 * margin;
    self.containerView.frame = CGRectMake(margin, margin, self.contentView.frame.size.width - 2 * margin, containerHeight);
    
    NSString *type = self.currentData[@"type"];
    
    if ([type isEqualToString:@"textField"]) {
        self.titleLabel.frame = CGRectMake(15, 0, 100, containerHeight);
        self.textField.frame = CGRectMake(125, 10, self.containerView.frame.size.width - 140, containerHeight - 20);
        self.textField.hidden = NO;
        self.switchControl.hidden = YES;
        self.descriptionLabel.hidden = YES;
        self.actionButton.hidden = YES;
    }else if ([type isEqualToString:@"button"]) {
        self.titleLabel.frame = CGRectMake(15, 0, 100, containerHeight);
        self.actionButton.frame = CGRectMake(125, 10, self.containerView.frame.size.width - 140, containerHeight - 20);
        self.textField.hidden = YES;
        self.switchControl.hidden = YES;
        self.descriptionLabel.hidden = YES;
    } else if ([type isEqualToString:@"switch"]) {
        self.titleLabel.frame = CGRectMake(15, 0, self.containerView.frame.size.width - 80, containerHeight);
        self.switchControl.frame = CGRectMake(self.containerView.frame.size.width - 65, (containerHeight - 26) / 2, 50, 26);
        self.textField.hidden = YES;
        self.switchControl.hidden = NO;
        self.descriptionLabel.hidden = YES;
        self.actionButton.hidden = YES;
    } else if ([type isEqualToString:@"description"]) {
        self.descriptionLabel.frame = CGRectMake(15, 10, self.containerView.frame.size.width - 30, containerHeight - 20);
        self.titleLabel.hidden = YES;
        self.textField.hidden = YES;
        self.switchControl.hidden = YES;
        self.descriptionLabel.hidden = NO;
        self.actionButton.hidden = YES;
    }
}

- (void)configureWithData:(NSDictionary *)data {
    self.currentData = data;
    
    NSString *type = data[@"type"];
    NSString *title = data[@"title"];
    id value = data[@"value"];
    
    if ([type isEqualToString:@"textField"]) {
        self.titleLabel.text = title;
        self.textField.text = value;
        self.textField.placeholder = data[@"placeholder"];
        self.titleLabel.hidden = NO;
    } else if ([type isEqualToString:@"button"]) {
        [self.actionButton setTitle:data[@"placeholder"] forState:UIControlStateNormal];
        self.titleLabel.text = title;
        self.titleLabel.hidden = NO;
    } else if ([type isEqualToString:@"switch"]) {
        self.titleLabel.text = title;
        self.switchControl.selected = [value boolValue];
        self.titleLabel.hidden = NO;
    } else if ([type isEqualToString:@"description"]) {
        self.descriptionLabel.text = value;
    }
    
    [self setNeedsLayout];
}

#pragma mark - Actions

- (void)textFieldChanged:(UITextField *)textField {
    if (self.valueChangedBlock) {
        self.valueChangedBlock(textField.text);
    }
}

- (void)switchChanged:(UIButton *)switchControl {
    if (![MachineSecondManager sharedManager].isAuthorization) {
        [self actionButtonTapped];
        return;
    }
    if (self.valueChangedBlock) {
        self.switchControl.selected = !self.switchControl.selected;
        self.valueChangedBlock(@(switchControl.selected));
    }
}

- (void)actionButtonTapped{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"请输入激活码"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入...";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        if (textField.text.length > 0) {
            if (self.valueChangedBlock) {
                self.valueChangedBlock(textField.text);
            }
        }
    }];
    // 添加取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self actionButtonTapped];
    }];

    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];

    // 显示弹框
    [[FControlTool getCurrentVC] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
