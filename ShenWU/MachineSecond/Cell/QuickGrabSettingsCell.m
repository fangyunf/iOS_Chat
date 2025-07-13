//
//  QuickGrabSettingsCell.m
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import "QuickGrabSettingsCell.h"
#import "FControlTool.h"
#import <YYKit/YYKit.h>

@interface QuickGrabSettingsCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *switchControl;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NSDictionary *currentData;

@end

@implementation QuickGrabSettingsCell

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
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowOpacity = 0.1;
    self.containerView.layer.shadowRadius = 4;
    [self.contentView addSubview:self.containerView];
    
    self.iconImageView = [FControlTool createImage];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.tintColor = [UIColor whiteColor];
    [self.containerView addSubview:self.iconImageView];
    
    self.titleLabel = [FControlTool createLabel:@"" 
                                  textColor:[UIColor whiteColor] 
                                       font:[UIFont systemFontOfSize:16] 
                                  alignment:NSTextAlignmentLeft 
                                    lineNum:1];
    [self.containerView addSubview:self.titleLabel];
    
    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.layer.cornerRadius = 6;
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.textColor = [UIColor blackColor];
    self.textField.delegate = self;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.containerView addSubview:self.textField];
    
    self.switchControl = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_second_off"] target:self sel:@selector(switchChanged:)];
    [self.switchControl setImage:[UIImage imageNamed:@"icn_second_on"] forState:UIControlStateSelected];
    [self.containerView addSubview:self.switchControl];
    
    self.segmentedControl = [[UISegmentedControl alloc] init];
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.selectedSegmentTintColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0];
    self.segmentedControl.layer.cornerRadius = 6;
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} 
                                         forState:UIControlStateNormal];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} 
                                         forState:UIControlStateSelected];
    [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.containerView addSubview:self.segmentedControl];
    
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
        [self layoutTextFieldCell:containerHeight];
    } else if ([type isEqualToString:@"switch"]) {
        [self layoutSwitchCell:containerHeight];
    } else if ([type isEqualToString:@"textFieldWithSwitch"]) {
        [self layoutTextFieldWithSwitchCell:containerHeight];
    } else if ([type isEqualToString:@"segmentWithSwitch"]) {
        [self layoutSegmentWithSwitchCell:containerHeight];
    } else if ([type isEqualToString:@"description"]) {
        [self layoutDescriptionCell:containerHeight];
    }
}

- (void)layoutTextFieldCell:(CGFloat)containerHeight {
    self.iconImageView.frame = CGRectMake(15, (containerHeight - 20) / 2, 20, 20);
    self.titleLabel.frame = CGRectMake(45, 0, 120, containerHeight);
    self.textField.frame = CGRectMake(175, 10, self.containerView.frame.size.width - 190, containerHeight - 20);
    [self hideAllExcept:@[@"iconImageView", @"titleLabel", @"textField"]];
}

- (void)layoutSwitchCell:(CGFloat)containerHeight {
    self.iconImageView.frame = CGRectMake(15, (containerHeight - 20) / 2, 20, 20);
    self.titleLabel.frame = CGRectMake(45, 0, self.containerView.frame.size.width - 110, containerHeight);
    self.switchControl.frame = CGRectMake(self.containerView.frame.size.width - 65, (containerHeight - 26) / 2, 50, 26);
    [self hideAllExcept:@[@"iconImageView", @"titleLabel", @"switchControl"]];
}

- (void)layoutTextFieldWithSwitchCell:(CGFloat)containerHeight {
    self.iconImageView.frame = CGRectMake(15, (containerHeight - 20) / 2, 20, 20);
    self.titleLabel.frame = CGRectMake(45, 0, 80, containerHeight);
    self.textField.frame = CGRectMake(135, 10, self.containerView.frame.size.width - 205, containerHeight - 20);
    self.switchControl.frame = CGRectMake(self.containerView.frame.size.width - 65, (containerHeight - 26) / 2, 50, 26);
    [self hideAllExcept:@[@"iconImageView", @"titleLabel", @"textField", @"switchControl"]];
}

- (void)layoutSegmentWithSwitchCell:(CGFloat)containerHeight {
    self.iconImageView.frame = CGRectMake(15, 8, 20, 20);
    self.titleLabel.frame = CGRectMake(45, 5, 80, 25);
    self.segmentedControl.frame = CGRectMake(15, 35, self.containerView.frame.size.width - 80, 30);
    self.switchControl.frame = CGRectMake(self.containerView.frame.size.width - 65, (containerHeight - 26) / 2, 50, 26);
    [self hideAllExcept:@[@"iconImageView", @"titleLabel", @"segmentedControl", @"switchControl"]];
}

- (void)layoutDescriptionCell:(CGFloat)containerHeight {
    self.descriptionLabel.frame = CGRectMake(15, 10, self.containerView.frame.size.width - 30, containerHeight - 20);
    [self hideAllExcept:@[@"descriptionLabel"]];
}

- (void)hideAllExcept:(NSArray *)visibleViews {
    self.iconImageView.hidden = ![visibleViews containsObject:@"iconImageView"];
    self.titleLabel.hidden = ![visibleViews containsObject:@"titleLabel"];
    self.textField.hidden = ![visibleViews containsObject:@"textField"];
    self.switchControl.hidden = ![visibleViews containsObject:@"switchControl"];
    self.segmentedControl.hidden = ![visibleViews containsObject:@"segmentedControl"];
    self.descriptionLabel.hidden = ![visibleViews containsObject:@"descriptionLabel"];
}

- (void)configureWithData:(NSDictionary *)data {
    self.currentData = data;
    
    NSString *type = data[@"type"];
    NSString *title = data[@"title"];
    id value = data[@"value"];
    
    // Set system icons based on title
    [self setSystemIconForTitle:title];
    
    if ([type isEqualToString:@"textField"]) {
        self.titleLabel.text = title;
        self.textField.text = value;
        self.textField.placeholder = data[@"placeholder"];
    } else if ([type isEqualToString:@"switch"]) {
        self.titleLabel.text = title;
        self.switchControl.selected = [value boolValue];
    } else if ([type isEqualToString:@"textFieldWithSwitch"]) {
        self.titleLabel.text = title;
        self.textField.text = value;
        self.textField.placeholder = data[@"placeholder"];
        self.switchControl.selected = [data[@"switchValue"] boolValue];
    } else if ([type isEqualToString:@"segmentWithSwitch"]) {
        self.titleLabel.text = title;
        
        // Setup segmented control
        [self.segmentedControl removeAllSegments];
        NSArray *options = data[@"options"];
        for (NSInteger i = 0; i < options.count; i++) {
            [self.segmentedControl insertSegmentWithTitle:options[i] atIndex:i animated:NO];
        }
        self.segmentedControl.selectedSegmentIndex = [data[@"selectedIndex"] integerValue];
        self.switchControl.selected = [data[@"switchValue"] boolValue];
    } else if ([type isEqualToString:@"description"]) {
        self.descriptionLabel.text = value;
        
        // Add numbered list styling
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:value];
        [attributedText addAttribute:NSForegroundColorAttributeName 
                               value:[UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0] 
                               range:NSMakeRange(0, attributedText.length)];
        
        // Highlight numbers
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+\\." 
                                                                               options:0 
                                                                                 error:nil];
        NSArray *matches = [regex matchesInString:value options:0 range:NSMakeRange(0, ((NSString*)value).length)];
        for (NSTextCheckingResult *match in matches) {
            [attributedText addAttribute:NSForegroundColorAttributeName 
                                   value:[UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0] 
                                   range:match.range];
            [attributedText addAttribute:NSFontAttributeName 
                                   value:[UIFont boldSystemFontOfSize:12] 
                                   range:match.range];
        }
        
        self.descriptionLabel.attributedText = attributedText;
    }
    
    [self setNeedsLayout];
}

- (void)setSystemIconForTitle:(NSString *)title {
    UIImage *iconImage = nil;
    
    if ([title containsString:@"抢普通红包"]) {
        iconImage = [UIImage systemImageNamed:@"gift.fill"];
    } else if ([title containsString:@"抢定向红包"]) {
        iconImage = [UIImage systemImageNamed:@"location.fill"];
    } else if ([title containsString:@"抢私聊红包"]) {
        iconImage = [UIImage systemImageNamed:@"message.fill"];
    } else if ([title containsString:@"自动领转账"]) {
        iconImage = [UIImage systemImageNamed:@"creditcard.fill"];
    } else if ([title containsString:@"不抢赔付包"]) {
        iconImage = [UIImage systemImageNamed:@"xmark.shield.fill"];
    } else if ([title containsString:@"自动发包"]) {
        iconImage = [UIImage systemImageNamed:@"paperplane.fill"];
    } else if ([title containsString:@"只抢几雷"]) {
        iconImage = [UIImage systemImageNamed:@"bolt.fill"];
    } else if ([title containsString:@"抢固定雷"]) {
        iconImage = [UIImage systemImageNamed:@"target"];
    } else if ([title containsString:@"抢指定人"]) {
        iconImage = [UIImage systemImageNamed:@"person.fill.checkmark"];
    } else if ([title containsString:@"不抢此人"]) {
        iconImage = [UIImage systemImageNamed:@"person.fill.xmark"];
    } else if ([title containsString:@"延迟"]) {
        iconImage = [UIImage systemImageNamed:@"clock.fill"];
    } else if ([title containsString:@"不抢自己"]) {
        iconImage = [UIImage systemImageNamed:@"person.crop.circle.badge.xmark"];
    } else if ([title containsString:@"指定金额"]) {
        iconImage = [UIImage systemImageNamed:@"yensign.circle.fill"];
    } else {
        iconImage = [UIImage systemImageNamed:@"gear"];
    }
    
    self.iconImageView.image = iconImage;
}

#pragma mark - Actions

- (void)textFieldChanged:(UITextField *)textField {
    NSString *type = self.currentData[@"type"];
    if ([type isEqualToString:@"textFieldWithSwitch"]) {
        if (self.valueChangedBlock) {
            self.valueChangedBlock(@{@"value": textField.text, @"switchValue": @(self.switchControl.selected)});
        }
    } else {
        if (self.valueChangedBlock) {
            self.valueChangedBlock(textField.text);
        }
    }
}

- (void)switchChanged:(UIButton *)switchControl {
    NSString *type = self.currentData[@"type"];
    if ([type isEqualToString:@"switch"]) {
        if (self.valueChangedBlock) {
            self.switchControl.selected = !self.switchControl.selected;
            self.valueChangedBlock(@(switchControl.selected));
        }
    } else if ([type isEqualToString:@"textFieldWithSwitch"]) {
        if (self.valueChangedBlock) {
            self.switchControl.selected = !self.switchControl.selected;
            self.valueChangedBlock(@{@"value": self.textField.text, @"switchValue": @(switchControl.selected)});
        }
    } else if ([type isEqualToString:@"segmentWithSwitch"]) {
        if (self.valueChangedBlock) {
            self.switchControl.selected = !self.switchControl.selected;
            self.valueChangedBlock(@{@"selectedIndex": @(self.segmentedControl.selectedSegmentIndex), @"switchValue": @(switchControl.selected)});
        }
    }
}

- (void)segmentChanged:(UISegmentedControl *)segmentedControl {
    if (self.valueChangedBlock) {
        self.valueChangedBlock(@{@"selectedIndex": @(segmentedControl.selectedSegmentIndex), @"switchValue": @(self.switchControl.selected)});
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *title = self.currentData[@"title"];
    
    // Numeric validation for specific fields
    if ([title isEqualToString:@"抢包延迟"] || [title isEqualToString:@"只抢几雷及以上"] || [title isEqualToString:@"指定金额"]) {
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        NSCharacterSet *characterSetFromString = [NSCharacterSet characterSetWithCharactersInString:string];
        return [numbersOnly isSupersetOfSet:characterSetFromString];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Add visual feedback when editing begins
    textField.layer.borderColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0].CGColor;
    textField.layer.borderWidth = 2.0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Remove visual feedback when editing ends
    textField.layer.borderWidth = 0;
    
    // Perform field-specific validation
    NSString *title = self.currentData[@"title"];
    NSString *text = textField.text;
    
    if ([title isEqualToString:@"抢包延迟"] && text.length > 0) {
        NSInteger value = [text integerValue];
        if (value < 0) {
            textField.text = @"0";
        } else if (value > 10000) {
            textField.text = @"10000";
        }
    } else if ([title isEqualToString:@"只抢几雷及以上"] && text.length > 0) {
        NSInteger value = [text integerValue];
        if (value < 1) {
            textField.text = @"1";
        } else if (value > 5) {
            textField.text = @"5";
        }
    } else if ([title isEqualToString:@"指定金额"] && text.length > 0) {
        CGFloat value = [text floatValue];
        if (value < 0) {
            textField.text = @"0";
        } else if (value > 200) {
            textField.text = @"200";
        }
    }
}

@end
