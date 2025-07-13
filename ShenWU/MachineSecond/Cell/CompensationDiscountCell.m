//
//  CompensationDiscountCell.m
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import "CompensationDiscountCell.h"
#import "FControlTool.h"
#import <YYKit/YYKit.h>

@interface CompensationDiscountCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) NSMutableArray *leftTextFields;
@property (nonatomic, strong) NSMutableArray *rightTextFields;
@property (nonatomic, strong) NSMutableArray *equalsLabels;
@property (nonatomic, strong) NSDictionary *currentMatrix;

@end

@implementation CompensationDiscountCell

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
    
    self.titleLabel = [FControlTool createLabel:@"打折 A=B" 
                                  textColor:[UIColor whiteColor] 
                                       font:[UIFont boldSystemFontOfSize:16] 
                                  alignment:NSTextAlignmentCenter 
                                    lineNum:1];
    [self.containerView addSubview:self.titleLabel];
    
    self.noteLabel = [FControlTool createLabel:@"" 
                                 textColor:[UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0] 
                                      font:[UIFont systemFontOfSize:10] 
                                 alignment:NSTextAlignmentLeft 
                                   lineNum:0];
    [self.containerView addSubview:self.noteLabel];
    
    self.leftTextFields = [NSMutableArray array];
    self.rightTextFields = [NSMutableArray array];
    self.equalsLabels = [NSMutableArray array];
    
    [self createDiscountRows];
}

- (void)createDiscountRows {
    // Create 6 rows of discount equations (3 columns x 2 rows)
    for (int i = 0; i < 12; i++) {
        // Left text field
        UITextField *leftField = [[UITextField alloc] init];
        leftField.backgroundColor = [UIColor whiteColor];
        leftField.font = [UIFont systemFontOfSize:12];
        leftField.textColor = [UIColor blackColor];
        leftField.textAlignment = NSTextAlignmentCenter;
        leftField.layer.cornerRadius = 4;
        leftField.layer.borderWidth = 1;
        leftField.layer.borderColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor;
        leftField.delegate = self;
        leftField.tag = i * 10 + 1; // Left field tag: i*10 + 1
        leftField.placeholder = @"A";
        leftField.keyboardType = UIKeyboardTypeDecimalPad;
        
        // Add toolbar
        leftField.inputAccessoryView = [self createToolbar];
        [leftField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [self.containerView addSubview:leftField];
        [self.leftTextFields addObject:leftField];
        
        // Equals label
        UILabel *equalsLabel = [FControlTool createLabel:@"=" 
                                           textColor:[UIColor whiteColor] 
                                                font:[UIFont boldSystemFontOfSize:16] 
                                           alignment:NSTextAlignmentCenter 
                                             lineNum:1];
        [self.containerView addSubview:equalsLabel];
        [self.equalsLabels addObject:equalsLabel];
        
        // Right text field
        UITextField *rightField = [[UITextField alloc] init];
        rightField.backgroundColor = [UIColor whiteColor];
        rightField.font = [UIFont systemFontOfSize:12];
        rightField.textColor = [UIColor blackColor];
        rightField.textAlignment = NSTextAlignmentCenter;
        rightField.layer.cornerRadius = 4;
        rightField.layer.borderWidth = 1;
        rightField.layer.borderColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor;
        rightField.delegate = self;
        rightField.tag = i * 10 + 2; // Right field tag: i*10 + 2
        rightField.placeholder = @"B";
        rightField.keyboardType = UIKeyboardTypeDecimalPad;
        
        // Add toolbar
        rightField.inputAccessoryView = [self createToolbar];
        [rightField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [self.containerView addSubview:rightField];
        [self.rightTextFields addObject:rightField];
    }
}

- (UIToolbar *)createToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                target:self 
                                                                                action:@selector(dismissKeyboard)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                               target:nil 
                                                                               action:nil];
    toolbar.items = @[flexSpace, doneButton];
    return toolbar;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat containerHeight = self.contentView.frame.size.height - 2 * margin;
    self.containerView.frame = CGRectMake(margin, margin, self.contentView.frame.size.width - 2 * margin, containerHeight);
    
    self.titleLabel.frame = CGRectMake(0, 10, self.containerView.frame.size.width, 25);
    
    // Layout discount equation rows (3 columns x 2 rows)
    CGFloat containerWidth = self.containerView.frame.size.width;
    CGFloat fieldWidth = (containerWidth - 90) / 4; // 3 equations per row, 2 fields per equation
    CGFloat fieldHeight = 30;
    CGFloat rowHeight = 40;
    CGFloat startY = 45;
    
    for (int i = 0; i < 12; i++) {
        int row = i / 2; // 0 or 1
        int col = i % 2; // 0, 1, or 2
        
        CGFloat baseX = 15 + col * (fieldWidth * 2 + 20 + 10); // Space for 2 fields + equals + margin
        CGFloat y = startY + row * rowHeight;
        
        // Left field
        UITextField *leftField = self.leftTextFields[i];
        leftField.frame = CGRectMake(baseX, y, fieldWidth, fieldHeight);
        
        // Equals label
        UILabel *equalsLabel = self.equalsLabels[i];
        equalsLabel.frame = CGRectMake(baseX + fieldWidth + 5, y, 20, fieldHeight);
        
        // Right field
        UITextField *rightField = self.rightTextFields[i];
        rightField.frame = CGRectMake(baseX + fieldWidth + 25, y, fieldWidth, fieldHeight);
    }
    
    // Note label at bottom
    self.noteLabel.frame = CGRectMake(15, startY + 230, containerWidth - 30, 60);
}

- (void)configureWithData:(NSDictionary *)data discountMatrix:(NSDictionary *)matrix {
    self.currentMatrix = matrix;
    
    NSString *note = data[@"note"];
    if (note) {
        self.noteLabel.text = note;
        
        // Style the note text
        NSMutableAttributedString *attributedNote = [[NSMutableAttributedString alloc] initWithString:note];
        [attributedNote addAttribute:NSForegroundColorAttributeName 
                               value:[UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0] 
                               range:NSMakeRange(0, attributedNote.length)];
        
        // Highlight important parts
        NSArray *highlights = @[@"注意", @"组合红包语", @"金额", @"雷值"];
        for (NSString *highlight in highlights) {
            NSRange range = [note rangeOfString:highlight];
            if (range.location != NSNotFound) {
                [attributedNote addAttribute:NSForegroundColorAttributeName 
                                       value:[UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0] 
                                       range:range];
                [attributedNote addAttribute:NSFontAttributeName 
                                       value:[UIFont boldSystemFontOfSize:10] 
                                       range:range];
            }
        }
        
        self.noteLabel.attributedText = attributedNote;
    }
    
    [self populateDiscountFields];
    [self setNeedsLayout];
}

- (void)populateDiscountFields {
    for (int i = 0; i < 12; i++) {
        NSDictionary *row = self.currentMatrix[@(i)];
        if (row) {
            NSString *leftValue = row[@"left"] ?: @"";
            NSString *rightValue = row[@"right"] ?: @"";
            
            UITextField *leftField = self.leftTextFields[i];
            UITextField *rightField = self.rightTextFields[i];
            
            leftField.text = leftValue;
            rightField.text = rightValue;
            
            // Visual feedback for filled fields
            leftField.backgroundColor = leftValue.length > 0 ? 
                [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:1.0] : [UIColor whiteColor];
            rightField.backgroundColor = rightValue.length > 0 ? 
                [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:1.0] : [UIColor whiteColor];
        }
    }
}

- (void)dismissKeyboard {
    [self endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldChanged:(UITextField *)textField {
    NSInteger row = textField.tag / 10;
    BOOL isLeftField = (textField.tag % 10) == 1;
    
    NSString *value = textField.text;
    
    // Visual feedback
    textField.backgroundColor = value.length > 0 ? 
        [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:1.0] : [UIColor whiteColor];
    
    // Get current values
    UITextField *leftField = self.leftTextFields[row];
    UITextField *rightField = self.rightTextFields[row];
    
    NSString *leftValue = leftField.text;
    NSString *rightValue = rightField.text;
    
    // Notify parent controller
    if (self.discountUpdateBlock) {
        self.discountUpdateBlock(row, leftValue, rightValue);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Allow numbers and decimal point only
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *stringChars = [NSCharacterSet characterSetWithCharactersInString:string];
    return [numbersOnly isSupersetOfSet:stringChars];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Add visual feedback
    textField.layer.borderColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0].CGColor;
    textField.layer.borderWidth = 2;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Remove visual feedback
    textField.layer.borderColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor;
    textField.layer.borderWidth = 1;
}

@end
