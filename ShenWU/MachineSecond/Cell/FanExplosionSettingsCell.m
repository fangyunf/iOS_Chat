//
//  FanExplosionSettingsCell.m
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import "FanExplosionSettingsCell.h"
#import "FControlTool.h"
#import <YYKit/YYKit.h>

@interface FanExplosionSettingsCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *explosionButton;
@property (nonatomic, strong) UIButton *switchControl;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *statusIndicator;
@property (nonatomic, strong) NSDictionary *currentData;

@end

@implementation FanExplosionSettingsCell

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
    
    self.explosionButton = [FControlTool createButton:@"" 
                                             font:[UIFont systemFontOfSize:14] 
                                        textColor:[UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0] 
                                           target:self 
                                              sel:@selector(explosionButtonTapped)];
    self.explosionButton.backgroundColor = [UIColor whiteColor];
    self.explosionButton.layer.cornerRadius = 6;
    self.explosionButton.layer.borderWidth = 1;
    self.explosionButton.layer.borderColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0].CGColor;
    [self.containerView addSubview:self.explosionButton];
    
    self.switchControl = [FControlTool createButtonWithImage:[UIImage imageNamed:@"icn_second_off"] target:self sel:@selector(switchChanged:)];
    [self.switchControl setImage:[UIImage imageNamed:@"icn_second_on"] forState:UIControlStateSelected];
    [self.containerView addSubview:self.switchControl];
    
    self.statusIndicator = [[UIView alloc] init];
    self.statusIndicator.backgroundColor = [UIColor greenColor];
    self.statusIndicator.layer.cornerRadius = 4;
    self.statusIndicator.hidden = YES;
    [self.containerView addSubview:self.statusIndicator];
    
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
    
    if ([type isEqualToString:@"explosionMode"]) {
        [self layoutExplosionModeCell:containerHeight];
    } else if ([type isEqualToString:@"switch"]) {
        [self layoutSwitchCell:containerHeight];
    } else if ([type isEqualToString:@"description"]) {
        [self layoutDescriptionCell:containerHeight];
    }
}

- (void)layoutExplosionModeCell:(CGFloat)containerHeight {
    self.iconImageView.frame = CGRectMake(15, (containerHeight - 24) / 2, 24, 24);
    self.titleLabel.frame = CGRectMake(50, 5, self.containerView.frame.size.width - 200, 25);
    self.explosionButton.frame = CGRectMake(50, 35, self.containerView.frame.size.width - 80, 25);
    self.statusIndicator.frame = CGRectMake(self.containerView.frame.size.width - 20, 10, 8, 8);
    
    [self hideAllExcept:@[@"iconImageView", @"titleLabel", @"explosionButton", @"statusIndicator"]];
}

- (void)layoutSwitchCell:(CGFloat)containerHeight {
    self.iconImageView.frame = CGRectMake(15, (containerHeight - 20) / 2, 20, 20);
    self.titleLabel.frame = CGRectMake(45, 0, self.containerView.frame.size.width - 110, containerHeight);
    self.switchControl.frame = CGRectMake(self.containerView.frame.size.width - 65, (containerHeight - 26) / 2, 50, 26);
    
    [self hideAllExcept:@[@"iconImageView", @"titleLabel", @"switchControl"]];
}

- (void)layoutDescriptionCell:(CGFloat)containerHeight {
    self.descriptionLabel.frame = CGRectMake(15, 10, self.containerView.frame.size.width - 30, containerHeight - 20);
    
    [self hideAllExcept:@[@"descriptionLabel"]];
}

- (void)hideAllExcept:(NSArray *)visibleViews {
    self.iconImageView.hidden = ![visibleViews containsObject:@"iconImageView"];
    self.titleLabel.hidden = ![visibleViews containsObject:@"titleLabel"];
    self.explosionButton.hidden = ![visibleViews containsObject:@"explosionButton"];
    self.switchControl.hidden = ![visibleViews containsObject:@"switchControl"];
    self.statusIndicator.hidden = ![visibleViews containsObject:@"statusIndicator"];
    self.descriptionLabel.hidden = ![visibleViews containsObject:@"descriptionLabel"];
}

- (void)configureWithData:(NSDictionary *)data {
    self.currentData = data;
    
    NSString *type = data[@"type"];
    NSString *title = data[@"title"];
    id value = data[@"value"];
    
    // Set system icons based on title
    [self setSystemIconForTitle:title];
    
    if ([type isEqualToString:@"explosionMode"]) {
        self.titleLabel.text = title;
        [self.explosionButton setTitle:value forState:UIControlStateNormal];
        
        // Set button style based on mode
        NSString *mode = data[@"mode"];
        if ([mode isEqualToString:@"normal"]) {
            self.explosionButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.5 alpha:1.0];
            [self.explosionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else if ([mode isEqualToString:@"precise"]) {
            self.explosionButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
            [self.explosionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else if ([mode isEqualToString:@"custom"]) {
            self.explosionButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.2 alpha:1.0];
            [self.explosionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        // Show status indicator if data exists
        BOOL hasData = [self checkIfModeHasData:mode];
        self.statusIndicator.hidden = !hasData;
        self.statusIndicator.backgroundColor = hasData ? [UIColor greenColor] : [UIColor redColor];
        
    } else if ([type isEqualToString:@"switch"]) {
        self.titleLabel.text = title;
        self.switchControl.selected = [value boolValue];
    } else if ([type isEqualToString:@"description"]) {
        // Create attributed text with numbered styling
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:value];
        [attributedText addAttribute:NSForegroundColorAttributeName 
                               value:[UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0] 
                               range:NSMakeRange(0, attributedText.length)];
        
        // Highlight numbers and important text
        NSRegularExpression *numberRegex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" 
                                                                                     options:0 
                                                                                       error:nil];
        NSArray *numberMatches = [numberRegex matchesInString:value options:0 range:NSMakeRange(0, ((NSString*)value).length)];
        for (NSTextCheckingResult *match in numberMatches) {
            [attributedText addAttribute:NSForegroundColorAttributeName 
                                   value:[UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0] 
                                   range:match.range];
            [attributedText addAttribute:NSFontAttributeName 
                                   value:[UIFont boldSystemFontOfSize:12] 
                                   range:match.range];
        }
        
        // Highlight key phrases
        NSArray *keyPhrases = @[@"普通人群", @"精准人群", @"大小号切换", @"平台限制"];
        for (NSString *phrase in keyPhrases) {
            NSRange range = [value rangeOfString:phrase];
            if (range.location != NSNotFound) {
                [attributedText addAttribute:NSForegroundColorAttributeName 
                                       value:[UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0] 
                                       range:range];
                [attributedText addAttribute:NSFontAttributeName 
                                       value:[UIFont boldSystemFontOfSize:12] 
                                       range:range];
            }
        }
        
        self.descriptionLabel.attributedText = attributedText;
    }
    
    [self setNeedsLayout];
}

- (void)setSystemIconForTitle:(NSString *)title {
    UIImage *iconImage = nil;
    
    if ([title containsString:@"普通人群"]) {
        iconImage = [UIImage systemImageNamed:@"person.3.fill"];
    } else if ([title containsString:@"精准人群"]) {
        iconImage = [UIImage systemImageNamed:@"target"];
    } else if ([title containsString:@"自选人群"]) {
        iconImage = [UIImage systemImageNamed:@"person.crop.circle.badge.checkmark"];
    } else if ([title containsString:@"添加精准人群"]) {
        iconImage = [UIImage systemImageNamed:@"plus.circle.fill"];
    } else {
        iconImage = [UIImage systemImageNamed:@"gear"];
    }
    
    self.iconImageView.image = iconImage;
}

- (BOOL)checkIfModeHasData:(NSString *)mode {
    // Check UserDefaults for saved group data
    NSArray *savedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"FanExplosionGroupData"];
    if (!savedData) return NO;
    
    for (NSDictionary *groupData in savedData) {
        if ([groupData[@"type"] isEqualToString:mode]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Actions

- (void)explosionButtonTapped {
    // Add visual feedback
    [UIView animateWithDuration:0.1 animations:^{
        self.explosionButton.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.explosionButton.transform = CGAffineTransformIdentity;
        }];
    }];
    
    if (self.explosionModeSelectedBlock) {
        NSString *mode = self.currentData[@"mode"];
        self.explosionModeSelectedBlock(mode);
    }
}

- (void)switchChanged:(UIButton *)switchControl {
    if (self.valueChangedBlock) {
        self.switchControl.selected = !self.switchControl.selected;
        self.valueChangedBlock(@(switchControl.selected));
    }
    
    // Add haptic feedback
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [feedbackGenerator impactOccurred];
    }
}

@end
