//
//  UITableViewCell+CellRound.m
//  InsightReader
//
//  Created by Amy on 2024/8/16.
//

#import "UITableViewCell+CellRound.h"

@implementation UITableViewCell (CellRound)
- (void)radius:(CGFloat)radius color:(UIColor *)color indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    // 圆角角度
      // 设置cell 背景色为透明
      self.backgroundColor = UIColor.clearColor;
      // 创建两个layer
      CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
      CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
      // 获取显示区域大小
      CGRect bounds = CGRectInset(self.bounds, 0, 0);
      // 获取每组行数
      NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
      // 贝塞尔曲线
      UIBezierPath *bezierPath = nil;
   if (rowNum == 1) {
       // 一组只有一行（四个角全部为圆角）
       bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                          byRoundingCorners:UIRectCornerAllCorners
                                                cornerRadii:CGSizeMake(radius, radius)];
   } else {
       if (indexPath.row == 0) {
           // 每组第一行（添加左上和右上的圆角）
           bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                              byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                    cornerRadii:CGSizeMake(radius, radius)];
           
       } else if (indexPath.row == rowNum - 1) {
           // 每组最后一行（添加左下和右下的圆角）
           bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                              byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                                    cornerRadii:CGSizeMake(radius, radius)];
       } else {
           // 每组不是首位的行不设置圆角
           bezierPath = [UIBezierPath bezierPathWithRect:bounds];
       }
   }
   // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
   normalLayer.path = bezierPath.CGPath;
   selectLayer.path = bezierPath.CGPath;
   
   
   UIView *nomarBgView = [[UIView alloc] initWithFrame:bounds];
   // 设置填充颜色
   normalLayer.fillColor = color.CGColor;
   // 添加图层到nomarBgView中
   [nomarBgView.layer insertSublayer:normalLayer atIndex:0];
   nomarBgView.backgroundColor = UIColor.clearColor;
   self.backgroundView = nomarBgView;
}
@end
