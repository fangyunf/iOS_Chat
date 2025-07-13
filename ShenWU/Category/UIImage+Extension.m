//
//  UIImage+Extension.m
//  MenstrualDiary
//
//  Created by Amy on 2023/10/15.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)getCommonGradienImage:(CGSize)size cornerRadius:(CGFloat)cornerRadius{
    if(cornerRadius == size.height/4){
        cornerRadius = size.height/2;
    }
    NSArray *contentColors = @[(__bridge id)RGBColor(0x83FF00).CGColor,(__bridge id)RGBColor(0xFFF600).CGColor];
    NSArray *boardColors = @[(__bridge id)RGBColor(0x83FF00).CGColor,(__bridge id)RGBColor(0xFFF600).CGColor];

    CAGradientLayer *boadrLayer = [CAGradientLayer layer];
    boadrLayer.frame = CGRectMake(0, 0, size.width, size.height);
    boadrLayer.colors = boardColors;
    boadrLayer.locations = @[@0.0, @1.0];
    boadrLayer.startPoint = CGPointMake(0, 0.5);
    boadrLayer.cornerRadius = cornerRadius;
    boadrLayer.endPoint = CGPointMake(1, 0.5);

    CAGradientLayer *contentLayer = [CAGradientLayer layer];
    contentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    contentLayer.colors = contentColors;
    contentLayer.locations = @[@0.0, @1.0];
    contentLayer.startPoint = CGPointMake(0,0.5);
    contentLayer.endPoint = CGPointMake(1, 0.5);
    contentLayer.cornerRadius = cornerRadius;
    [boadrLayer addSublayer:contentLayer];
    
    return [UIImage imageWithLayer:boadrLayer cornerRadius:cornerRadius];
}


+ (UIImage *)imageWithLayer:(CALayer *)layer cornerRadius:(CGFloat)radius {
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:layer.bounds.size];
        return [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            UIBezierPath *path = [self pathWithCornerRadius:radius size:layer.bounds.size];
            CGContextAddPath(rendererContext.CGContext, path.CGPath);
            [layer renderInContext:rendererContext.CGContext];
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIBezierPath *path = [self pathWithCornerRadius:radius size:layer.bounds.size];;
        CGContextAddPath(context, path.CGPath);
        [layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

+ (UIBezierPath *)pathWithCornerRadius:(CGFloat)radius size:(CGSize)size {
    CGFloat imgW = size.width;
    CGFloat imgH = size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if(radius != size.height/2){
        [path moveToPoint:CGPointMake(radius, 0)];
        [path addLineToPoint:CGPointMake(imgW - radius, 0)];
        [path addQuadCurveToPoint:CGPointMake(imgW, radius) controlPoint:CGPointMake(imgW, 0)];
        [path addLineToPoint:CGPointMake(imgW, imgH - radius)];
        [path addQuadCurveToPoint:CGPointMake(imgW-radius, imgH) controlPoint:CGPointMake(imgW, imgH)];
        [path addLineToPoint:CGPointMake(radius, imgH)];
        [path addQuadCurveToPoint:CGPointMake(0, imgH - radius) controlPoint:CGPointMake(0, imgH)];
        [path addLineToPoint:CGPointMake(0, radius)];
        [path addQuadCurveToPoint:CGPointMake(radius, 0) controlPoint:CGPointMake(0, 0)];
    }else{
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [path addArcWithCenter:CGPointMake(radius, imgH - radius) radius:radius startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
        [path addArcWithCenter:CGPointMake(imgW - radius, radius) radius:radius startAngle:M_PI_2 * 3 endAngle:0 clockwise:YES];
        [path addArcWithCenter:CGPointMake(imgW - radius, imgH - radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    }
    
    
    
    [path closePath];
    [path addClip];
    return path;
}

@end
