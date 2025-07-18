/*
 * Copyright 2012 ZXing authors
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

#import "ZXResultPoint.h"

/**
 * Encapsulates a finder pattern, which are the three square patterns found in
 * the corners of QR Codes. It also encapsulates a count of similar finder patterns,
 * as a convenience to the finder's bookkeeping.
 */
@interface ZXQRCodeFinderPattern : ZXResultPoint

@property (nonatomic, assign, readonly) int count;
@property (nonatomic, assign, readonly) float estimatedModuleSize;

- (id)initWithPosX:(float)posX posY:(float)posY estimatedModuleSize:(float)estimatedModuleSize;

- (id)initWithPosX:(float)posX posY:(float)posY estimatedModuleSize:(float)estimatedModuleSize count:(int)count;

//- (void)incrementCount;

/**
 * Determines if this finder pattern "about equals" a finder pattern at the stated
 * position and size -- meaning, it is at nearly the same center with nearly the same size.
 */
- (BOOL)aboutEquals:(float)moduleSize i:(float)i j:(float)j;

/**
 * Combines this object's current estimate of a finder pattern position and module size
 * with a new estimate. It returns a new ZXFinderPattern containing a weighted average
 * based on count.
 */
- (ZXQRCodeFinderPattern *)combineEstimateI:(float)i j:(float)j newModuleSize:(float)newModuleSize;

@end
