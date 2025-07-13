//
//  PackageSettingsCell.m
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import "PackageSettingsCell.h"
#import "FControlTool.h"
#import <YYKit/YYKit.h>

@interface PackageSettingsCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *switchControl;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) NSDictionary *currentData;

@end

@implementation PackageSettingsCell

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
    
    self.switchControl = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_second_off"] target:self sel:@selector(switchChanged:)];
    [self.switchControl setImage:[UIImage imageNamed:@"icn_second_on"] forState:UIControlStateSelected];
    [self.containerView addSubview:self.switchControl];
    
    self.segmentedControl = [[UISegmentedControl alloc] init];
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.selectedSegmentTintColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0];
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
        self.titleLabel.frame = CGRectMake(15, 0, 120, containerHeight);
        self.textField.frame = CGRectMake(145, 10, self.containerView.frame.size.width - 160, containerHeight - 20);
        [self hideAllExcept:@[@"titleLabel", @"textField"]];
    } else if ([type isEqualToString:@"switch"]) {
        self.titleLabel.frame = CGRectMake(15, 0, self.containerView.frame.size.width - 80, containerHeight);
        self.switchControl.frame = CGRectMake(self.containerView.frame.size.width - 65, (containerHeight - 26) / 2, 50, 26);
        [self hideAllExcept:@[@"titleLabel", @"switchControl"]];
    } else if ([type isEqualToString:@"textFieldWithSwitch"]) {
        self.titleLabel.frame = CGRectMake(15, 0, 80, containerHeight);
        self.textField.frame = CGRectMake(105, 10, self.containerView.frame.size.width - 175, containerHeight - 20);
        self.switchControl.frame = CGRectMake(self.containerView.frame.size.width - 65, (containerHeight - 26) / 2, 50, 26);
        [self hideAllExcept:@[@"titleLabel", @"textField", @"switchControl"]];
    } else if ([type isEqualToString:@"segmentWithSwitch"]) {
        self.titleLabel.frame = CGRectMake(15, 5, 80, 30);
        self.segmentedControl.frame = CGRectMake(15, 35, self.containerView.frame.size.width - 80, 30);
        self.switchControl.frame = CGRectMake(self.containerView.frame.size.width - 65, (containerHeight - 26) / 2, 50, 26);
        [self hideAllExcept:@[@"titleLabel", @"segmentedControl", @"switchControl"]];
    } else if ([type isEqualToString:@"description"]) {
        self.descriptionLabel.frame = CGRectMake(15, 10, self.containerView.frame.size.width - 30, containerHeight - 20);
        [self hideAllExcept:@[@"descriptionLabel"]];
    }
}

- (void)hideAllExcept:(NSArray *)visibleViews {
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
    }
    
    [self setNeedsLayout];
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
    if ([title isEqualToString:@"自动发包间隔"] || [title isEqualToString:@"红包个数"] || [title isEqualToString:@"输入金额"]) {
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        NSCharacterSet *characterSetFromString = [NSCharacterSet characterSetWithCharactersInString:string];
        return [numbersOnly isSupersetOfSet:characterSetFromString];
    }
    
    return YES;
}

@end
