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

#import "BMALabeledSlider.h"

@interface BMALabeledSlider ()
@property (weak, nonatomic) IBOutlet BMASlider *rangeSlider;
@end

@implementation BMALabeledSlider

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self.rangeSlider addTarget:self action:@selector(handleValueChange) forControlEvents:UIControlEventValueChanged];
    [self.rangeSlider addTarget:self action:@selector(handleEditingDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    [self updateRangeDetailLabel];
}

- (void)setTitle:(NSAttributedString *)title {
    _title = [title copy];
    self.titleLabel.attributedText = title;
}

#pragma mark - Slider forwarding

- (void)setCurrentValue:(CGFloat)value {
    self.rangeSlider.currentValue = value;
    [self updateRangeDetailLabel];
}

- (void)setCurrentValue:(CGFloat)value animated:(BOOL)animated {
    [self.rangeSlider setCurrentValue:value animated:animated];
}

- (CGFloat)currentValue {
    return self.rangeSlider.currentValue;
}

- (void)setMaximumValue:(CGFloat)maximumValue {
    self.rangeSlider.maximumValue = maximumValue;
}

- (CGFloat)maximumValue {
    return self.rangeSlider.maximumValue;
}

- (void)setMinimumValue:(CGFloat)minimumValue {
    self.rangeSlider.minimumValue = minimumValue;
}

- (CGFloat)minimumValue {
    return self.rangeSlider.minimumValue;
}

- (void)setStyle:(id<BMASliderStyling>)style {
    self.rangeSlider.style = style;
}

- (id<BMASliderStyling>)style {
    return self.rangeSlider.style;
}

- (void)handleValueChange {
    [self updateRangeDetailLabel];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)handleEditingDidEnd {
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

- (void)setStep:(CGFloat)step {
    self.rangeSlider.step = step;
}

- (CGFloat)step {
    return self.rangeSlider.step;
}

- (void)setContinuous:(BOOL)continuous {
    self.rangeSlider.continuous = continuous;
}

- (BOOL)continuous {
    return self.rangeSlider.continuous;
}

- (BOOL)isOverflow {
    return [self.rangeSlider isOverflow];
}

#pragma mark - Range formatting

#pragma mark - Detail formatting

- (void)setRangeFormatter:(id<BMARangeFormatter>)rangeFormatter {
    _rangeFormatter = rangeFormatter;
    [self updateRangeDetailLabel];
}

- (void)updateRangeDetailLabel {
    [self updateRangeFormatter];
    NSAssert(!self.rangeFormatter || [self.rangeFormatter.formattedString isKindOfClass:[NSAttributedString class]], @"kk");

    self.rangeDetailLabel.attributedText = self.rangeFormatter.formattedString;
}

- (void)updateRangeFormatter {
    self.rangeFormatter.hasLowerValue = NO;
    self.rangeFormatter.upperValue = self.currentValue;
    self.rangeFormatter.overflow = self.overflow;
}

@end
