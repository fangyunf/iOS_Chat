//
//  SWSearchView.m
//  ShenWU
//
//  Created by Amy on 2024/6/20.
//

#import "SWSearchView.h"

@interface SWSearchView ()<UITextFieldDelegate>
@property(nonatomic, strong) UITextField *searchTextField;
@property(nonatomic, assign) BOOL isEdit;
@end

@implementation SWSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self rounded:12 width:1 color:RGBColor(0xC6C0B4)];
        self.layer.masksToBounds = YES;
        
        UIButton *searchBtn = [FControlTool createButtonWithImage:[UIImage imageNamed:@"btn_search"] target:self sel:@selector(searchBtnAction)];
        searchBtn.frame = CGRectMake(10, (self.height - 20)/2, 20, 20);
        [self addSubview:searchBtn];
        
        self.searchTextField = [[UITextField alloc] init];
        self.searchTextField.frame = CGRectMake(44, 0, self.width - 50 - 15, self.height);
        NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSForegroundColorAttributeName:RGBColor(0x8E8E93),NSFontAttributeName:[UIFont boldFontWithSize:14]}];
        self.searchTextField.font = [UIFont boldFontWithSize:14];
        self.searchTextField.textColor = UIColor.blackColor;
        self.searchTextField.attributedPlaceholder = placeholderString;
        self.searchTextField.delegate = self;
        self.searchTextField.returnKeyType = UIReturnKeySearch;
        [self addSubview:self.searchTextField];
    }
    return self;
}

- (void)searchBtnAction{
    [self.searchTextField resignFirstResponder];
    if (self.searchBlock) {
        self.searchBlock(self.searchTextField.text);
    }
}

- (void)endSearchContent{
    [self.searchTextField resignFirstResponder];
    self.searchTextField.text = @"";
    if (self.endSearchBlock) {
        self.endSearchBlock();
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:RGBColor(0x8E8E93),NSFontAttributeName:[UIFont fontWithSize:16]}];
    self.searchTextField.attributedPlaceholder = placeholderString;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_isEdit) {
        return YES;
    }
    self.isEdit = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isEdit = NO;
    });
    NSMutableString *changedString = [[NSMutableString alloc] initWithString:textField.text];
    [changedString replaceCharactersInRange:range withString:string];
    
    NSLog(@"changedString:%@ textField:%@ string:%@",changedString,textField.text,string);
    if (changedString.length == 0) {
        if (self.endSearchBlock) {
            self.endSearchBlock();
        }
        return YES;
    }
    if ([string isEqualToString:@"\n"]) {
        NSLog(@"Search_Search");
        [self.searchTextField resignFirstResponder];
        if (self.searchBlock) {
            self.searchBlock(self.searchTextField.text);
        }
        return NO;
    }else{
        if (self.searchBlock) {
            self.searchBlock(changedString);
        }
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
