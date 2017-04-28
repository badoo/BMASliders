/*
 The MIT License (MIT)
 
 Copyright (c) 2015-present Badoo Trading Limited.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

@import UIKit;
#import "BMASliderStyling.h"

@protocol BMARangeSlider <NSObject>

@property (nonatomic) id<BMASliderStyling> style;

@property (nonatomic) CGFloat minimumValue;
@property (nonatomic) CGFloat maximumValue;

@property (nonatomic) CGFloat currentLowerValue;
@property (nonatomic) CGFloat currentUpperValue;

@property (nonatomic) CGFloat minimumDistance;

/**
 *  if YES, indicates the user is (significantly) touching beyond the maximumValue
 */
@property (nonatomic, readonly, getter=isOverflow) BOOL overflow;

/**
 *  if YES, indicates the user is (significantly) touching beyond the minimumValue
 */
@property (nonatomic, readonly, getter=isUnderflow) BOOL underflow;

- (void)setLowerBound:(CGFloat)value animated:(BOOL)animated;
- (void)setUpperBound:(CGFloat)value animated:(BOOL)animated;

/**
 *  if > 0, values are discretized as k*Step.
 */
@property (nonatomic) CGFloat step;

/**
 *  if NO, notifies of changes once user finish interaction. Default is YES
 */
@property (nonatomic, getter=isContinuous) BOOL continuous;

@end

IB_DESIGNABLE
@interface BMARangeSlider : UIControl <BMARangeSlider>

@property (nonatomic) id<BMASliderStyling> style UI_APPEARANCE_SELECTOR;  // Default is BMASliderLiveRenderingStyle
@property (nonatomic) IBInspectable CGFloat minimumValue;
@property (nonatomic) IBInspectable CGFloat maximumValue;
@property (nonatomic) IBInspectable CGFloat currentLowerValue;
@property (nonatomic) IBInspectable CGFloat currentUpperValue;
@property (nonatomic) IBInspectable CGFloat step;
@property (nonatomic) IBInspectable CGFloat minimumDistance;
@property (nonatomic, getter=isContinuous) IBInspectable BOOL continuous;

@end
