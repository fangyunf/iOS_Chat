//
//  FDatePickerView.m
//  Fiesta
//
//  Created by Amy on 2024/6/13.
//

#import "FDatePickerView.h"

@interface FDatePickerView ()
{
    NSString *_dateStr;
}
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation FDatePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = RGBAlphaColor(0x000000, 0.65);
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 359);
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.bgView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(12, 12)];
    [self addSubview:self.bgView];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(15, 17, 24, 24);
    [closeBtn setImage:[UIImage imageNamed:@"icn_password_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:closeBtn];
    
    UILabel *titleLabel = [FControlTool createLabel:@"时间选择" textColor:RGBColor(0x333333) font:[UIFont boldFontWithSize:18]];
    titleLabel.frame = CGRectMake(16, 20, kScreenWidth - 32, 18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:titleLabel];
    
    self.datePicker = [[UIDatePicker alloc] init];
    if (@available(iOS 13.4, *)) {
        self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker setDate:[NSDate date]];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.datePicker.locale = locale;
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.bgView addSubview:self.datePicker];
    
    self.datePicker.frame = CGRectMake(16, titleLabel.bottom +27, kScreenWidth - 32, 250);
    [self.datePicker setMinimumDate:[[NSDate date] initWithTimeIntervalSinceNow:-(60*60*24*365*12)]];
    [self.datePicker setMaximumDate:[NSDate date]];
    
    UIButton *okBtn = [[UIButton alloc] init];
    okBtn.frame = CGRectMake(kScreenWidth - 50, 20, 30, 18);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont fontWithSize:14];
    [okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:okBtn];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    _dateStr = [dateFormatter stringFromDate:[NSDate date]];
}

- (void)setTime:(NSString *)time{
    _time = time;
    _dateStr = time;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-01",time]];
    if(date){
        [self.datePicker setDate:date];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM"];
        _dateStr = [dateFormatter stringFromDate:[NSDate date]];
    }
    
}

- (void)showView{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBAlphaColor(0x000000, 0.65);
        self.bgView.frame = CGRectMake(0, kScreenHeight - self.bgView.height, kScreenWidth, self.bgView.height);
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBAlphaColor(0x000000, 0);
        self.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth,self.bgView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)datePickerValueChanged:(UIDatePicker*)datePicker{
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    _dateStr = [dateFormatter stringFromDate:date];
}

- (void)okBtnAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(getSelectDate:)]){
        [self.delegate getSelectDate:_dateStr];
    }
    [self dismiss];
}

#pragma mark - 方法重新
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (!CGRectContainsPoint(self.bgView.frame, [touch locationInView:self])) {
        [self dismiss];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



