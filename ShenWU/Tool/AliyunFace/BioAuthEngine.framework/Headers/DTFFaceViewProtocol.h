//
//  DTFFaceViewProtocol.h
//  BioAuthEngine
//
//  Created by mengbingchuan on 2022/8/29.
//  Copyright © 2022   DTF. All rights reserved.
//

#import <UIKit/UIkit.h>
#import <AVFoundation/AVFoundation.h>
#import <ToygerService/ToygerFaceFrame.h>

@protocol DTFFaceViewProtocol;

@protocol DTFFaceViewDelegate <NSObject>

- (void)viewExit:(id<DTFFaceViewProtocol>)view;

- (void)playBtn:(UIButton *)btn;

@end

@protocol DTFFaceViewProtocol <NSObject>

@property(nonatomic, weak) id<DTFFaceViewDelegate> delegate;

- (void)setPreviewLayer:(AVCaptureVideoPreviewLayer *)previewLayer;

- (void)setScreenRotation:(BOOL)isRotation;

- (void)setPlayBtnIcon;

- (void)handleFaceStateChange:(ToygerMessage)state
                    stateTips:(NSString *)tips
                  actionGuide:(NSString *)guide
                     progress:(CGFloat)progress;

- (UIView *)view;

@optional

/**
 * color 炫彩时，设置View的背景色
 */
- (void)setPhotinusColor:(UIColor *)color;

/**
 * 设置是否开启适老化
 */
- (void)setSuitableType:(BOOL)isSuitable;
/**
 * image 模糊化的人脸图，用于做结束时loading
 */
- (void)showBlurImage:(UIImage *)image;

@end

