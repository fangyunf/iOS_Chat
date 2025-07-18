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

#import "ZXAbstractExpandedDecoder.h"

extern const int ZX_AI01_GTIN_SIZE;

@interface ZXAI01decoder : ZXAbstractExpandedDecoder

- (void)encodeCompressedGtin:(NSMutableString *)buf currentPos:(int)currentPos;
- (void)encodeCompressedGtinWithoutAI:(NSMutableString *)buf currentPos:(int)currentPos initialBufferPosition:(int)initialBufferPosition;

@end
