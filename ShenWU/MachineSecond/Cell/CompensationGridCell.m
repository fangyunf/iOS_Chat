//
//  CompensationGridCell.m
//  SettingsApp
//
//  Created by Developer on 2025/01/01.
//

#import "CompensationGridCell.h"
#import "FControlTool.h"
#import <YYKit/YYKit.h>

@interface CompensationGridCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *gridContainer;
@property (nonatomic, strong) NSMutableArray *headerLabels;
@property (nonatomic, strong) NSMutableArray *rowLabels;
@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, strong) NSDictionary *currentMatrix;
@property (nonatomic, strong) NSArray *thunderTypes;
@property (nonatomic, strong) NSArray *packetCounts;

@end

@implementation CompensationGridCell

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
    
    self.titleLabel = [FControlTool createLabel:@"赔付" 
                                  textColor:[UIColor whiteColor] 
                                       font:[UIFont boldSystemFontOfSize:16] 
                                  alignment:NSTextAlignmentCenter 
                                    lineNum:1];
    [self.containerView addSubview:self.titleLabel];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.containerView addSubview:self.scrollView];
    
    self.gridContainer = [[UIView alloc] init];
    [self.scrollView addSubview:self.gridContainer];
    
    self.headerLabels = [NSMutableArray array];
    self.rowLabels = [NSMutableArray array];
    self.textFields = [NSMutableArray array];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat containerHeight = self.contentView.frame.size.height - 2 * margin;
    self.containerView.frame = CGRectMake(margin, margin, self.contentView.frame.size.width - 2 * margin, containerHeight);
    
    self.titleLabel.frame = CGRectMake(0, 10, self.containerView.frame.size.width, 25);
    self.scrollView.frame = CGRectMake(10, 45, self.containerView.frame.size.width - 20, containerHeight - 55);
    
    [self layoutGrid];
}

- (void)layoutGrid {
    if (self.thunderTypes.count == 0 || self.packetCounts.count == 0) return;
    
    CGFloat cellWidth = 56;
    CGFloat cellHeight = 40;
    CGFloat headerHeight = 30;
    CGFloat rowLabelWidth = 60;
    
    // Calculate total grid size
    CGFloat totalWidth = rowLabelWidth + (self.packetCounts.count * cellWidth);
    CGFloat totalHeight = headerHeight + (self.thunderTypes.count * cellHeight);
    
    self.gridContainer.frame = CGRectMake(0, 0, totalWidth, totalHeight);
    self.scrollView.contentSize = CGSizeMake(totalWidth, totalHeight);
    
    // Layout header labels (packet counts)
    for (NSInteger i = 0; i < self.headerLabels.count; i++) {
        UILabel *label = self.headerLabels[i];
        label.frame = CGRectMake(rowLabelWidth + (i * cellWidth), 0, cellWidth, headerHeight);
    }
    
    // Layout row labels (thunder types)
    for (NSInteger i = 0; i < self.rowLabels.count; i++) {
        UILabel *label = self.rowLabels[i];
        label.frame = CGRectMake(0, headerHeight + (i * cellHeight), rowLabelWidth, cellHeight);
    }
    
    // Layout text fields
    for (NSInteger row = 0; row < self.thunderTypes.count; row++) {
        for (NSInteger col = 0; col < self.packetCounts.count; col++) {
            NSInteger index = row * self.packetCounts.count + col;
            if (index < self.textFields.count) {
                UITextField *textField = self.textFields[index];
                textField.frame = CGRectMake(rowLabelWidth + (col * cellWidth) + 2, 
                                           headerHeight + (row * cellHeight) + 2, 
                                           cellWidth - 4, 
                                           cellHeight - 4);
            }
        }
    }
}

- (void)configureWithData:(NSDictionary *)data compensationMatrix:(NSDictionary *)matrix {
    self.currentMatrix = matrix;
    self.thunderTypes = data[@"thunderTypes"];
    self.packetCounts = data[@"packetCounts"];
    
    [self createGridElements];
    [self populateGridWithMatrix];
    [self setNeedsLayout];
}

- (void)createGridElements {
    // Clear existing elements
    [self.headerLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.rowLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.textFields makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.headerLabels removeAllObjects];
    [self.rowLabels removeAllObjects];
    [self.textFields removeAllObjects];
    
    // Create header labels (packet counts)
    for (NSString *packetCount in self.packetCounts) {
        UILabel *label = [FControlTool createLabel:packetCount 
                                     textColor:[UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0] 
                                          font:[UIFont boldSystemFontOfSize:12] 
                                     alignment:NSTextAlignmentCenter 
                                       lineNum:1];
        label.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor;
        [self.gridContainer addSubview:label];
        [self.headerLabels addObject:label];
    }
    
    // Create row labels (thunder types)
    for (NSString *thunderType in self.thunderTypes) {
        UILabel *label = [FControlTool createLabel:thunderType 
                                     textColor:[UIColor colorWithRed:0.8 green:0.6 blue:0.4 alpha:1.0] 
                                          font:[UIFont boldSystemFontOfSize:12] 
                                     alignment:NSTextAlignmentCenter 
                                       lineNum:1];
        label.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        label.layer.borderWidth = 1;
        label.layer.borderColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor;
        [self.gridContainer addSubview:label];
        [self.rowLabels addObject:label];
    }
    
    // Create text fields for the grid
    for (NSInteger row = 0; row < self.thunderTypes.count; row++) {
        for (NSInteger col = 0; col < self.packetCounts.count; col++) {
            UITextField *textField = [[UITextField alloc] init];
            textField.backgroundColor = [UIColor whiteColor];
            textField.font = [UIFont systemFontOfSize:11];
            textField.textColor = [UIColor blackColor];
            textField.textAlignment = NSTextAlignmentCenter;
            textField.layer.borderWidth = 1;
            textField.layer.borderColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor;
            textField.delegate = self;
            textField.tag = row * 1000 + col; // Encode row and column in tag
            textField.placeholder = @"0";
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            
            // Add toolbar with done button
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                        target:self 
                                                                                        action:@selector(dismissKeyboard)];
            UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                                       target:nil 
                                                                                       action:nil];
            toolbar.items = @[flexSpace, doneButton];
            textField.inputAccessoryView = toolbar;
            
            [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            
            [self.gridContainer addSubview:textField];
            [self.textFields addObject:textField];
        }
    }
}

- (void)populateGridWithMatrix {
    for (NSInteger row = 0; row < self.thunderTypes.count; row++) {
        NSString *thunderType = self.thunderTypes[row];
        NSDictionary *thunderDict = self.currentMatrix[thunderType];
        
        for (NSInteger col = 0; col < self.packetCounts.count; col++) {
            NSString *packetCount = self.packetCounts[col];
            NSString *value = thunderDict[packetCount] ?: @"";
            
            NSInteger index = row * self.packetCounts.count + col;
            if (index < self.textFields.count) {
                UITextField *textField = self.textFields[index];
                textField.text = value;
                
                // Color code based on value
                if (value.length > 0) {
                    textField.backgroundColor = [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:1.0];
                } else {
                    textField.backgroundColor = [UIColor whiteColor];
                }
            }
        }
    }
}

- (void)dismissKeyboard {
    [self endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldChanged:(UITextField *)textField {
    NSInteger row = textField.tag / 1000;
    NSInteger col = textField.tag % 1000;
    
    if (row < self.thunderTypes.count && col < self.packetCounts.count) {
        NSString *thunderType = self.thunderTypes[row];
        NSString *packetCount = self.packetCounts[col];
        NSString *value = textField.text;
        
        // Update visual feedback
        if (value.length > 0) {
            textField.backgroundColor = [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:1.0];
        } else {
            textField.backgroundColor = [UIColor whiteColor];
        }
        
        // Notify parent controller
        if (self.matrixUpdateBlock) {
            self.matrixUpdateBlock(thunderType, packetCount, value);
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Allow numbers, decimal point, and basic operators
    NSCharacterSet *allowedChars = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.+-*/()"];
    NSCharacterSet *stringChars = [NSCharacterSet characterSetWithCharactersInString:string];
    return [allowedChars isSupersetOfSet:stringChars];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Scroll to make the text field visible
    CGRect textFieldFrame = [self.gridContainer convertRect:textField.frame toView:self.scrollView];
    [self.scrollView scrollRectToVisible:textFieldFrame animated:YES];
    
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
