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

#import "BMALabeledRangeSlider.h"

@interface BMALabeledRangeSlider ()

@property (weak, nonatomic) IBOutlet BMARangeSlider *rangeSlider;

@end

@implementation BMALabeledRangeSlider

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

- (void)setCurrentLowerValue:(CGFloat)currentLowerValue {
    self.rangeSlider.currentLowerValue = currentLowerValue;
    [self updateRangeDetailLabel];
}

- (CGFloat)currentLowerValue {
    return self.rangeSlider.currentLowerValue;
}

- (void)setCurrentUpperValue:(CGFloat)currentUpperValue {
    self.rangeSlider.currentUpperValue = currentUpperValue;
    [self updateRangeDetailLabel];
}

- (CGFloat)currentUpperValue {
    return self.rangeSlider.currentUpperValue;
}

- (void)setLowerBound:(CGFloat)lowerBound animated:(BOOL)animated {
    [self.rangeSlider setLowerBound:lowerBound animated:animated];
}

- (void)setUpperBound:(CGFloat)upperBound animated:(BOOL)animated {
    [self.rangeSlider setUpperBound:upperBound animated:animated];
}

- (void)setMinimumDistance:(CGFloat)minimumDistance {
    [self.rangeSlider setMinimumDistance:minimumDistance];
}

- (CGFloat)minimumDistance {
    return self.rangeSlider.minimumDistance;
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

- (BOOL)isUnderflow {
    return [self.rangeSlider isUnderflow];
}

#pragma mark - Detail formatting

- (void)setRangeFormatter:(id<BMARangeFormatter>)rangeFormatter {
    _rangeFormatter = rangeFormatter;
    [self updateRangeDetailLabel];
}

- (void)updateRangeDetailLabel {
    [self updateRangeFormatter];
    self.rangeDetailLabel.attributedText = self.rangeFormatter.formattedString;
}

- (void)updateRangeFormatter {
    self.rangeFormatter.hasLowerValue = YES;
    self.rangeFormatter.lowerValue = self.currentLowerValue;
    self.rangeFormatter.upperValue = self.currentUpperValue;
    self.rangeFormatter.overflow = self.overflow;
}

@end
