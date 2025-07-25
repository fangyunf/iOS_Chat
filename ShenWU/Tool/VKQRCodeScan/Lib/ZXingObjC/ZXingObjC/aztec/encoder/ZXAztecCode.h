/*
 * Copyright 2013 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>

@class ZXBitMatrix;

/**
 * Aztec 2D code representation
 */
@interface ZXAztecCode : NSObject

/**
 * Number of data codewords
 */
@property (nonatomic, assign) int codeWords;

/**
 * Compact or full symbol indicator
 */
@property (nonatomic, assign, getter = isCompact) BOOL compact;

/**
 * Number of levels
 */
@property (nonatomic, assign) int layers;

/**
 * The symbol image
 */
@property (nonatomic, strong) ZXBitMatrix *matrix;

/**
 * Size in pixels (width and height)
 */
@property (nonatomic, assign) int size;

@end
