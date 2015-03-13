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

#import "BMASlider.h"
#import "BMASliderLiveRenderingStyle.h"

@interface BMASlider ()

@property (nonatomic, strong) UIView *slidingView;
@property (nonatomic, strong) UIImageView *selectedRangeImageView;
@property (nonatomic, strong) UIImageView *backgroundRangeImageView;
@property (nonatomic, strong) UIImageView *handler;
@property (nonatomic) UIEdgeInsets touchEdgeInsets;
@property (nonatomic, readwrite, getter=isOverflow) BOOL overflow;

@end

@implementation BMASlider

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self setUpDefaultStyle];
    [self setUpDefaultValues];
    [self setUpViews];
}

- (void)setUpDefaultStyle {
    _style = [[BMASliderLiveRenderingStyle alloc] init];
}

- (void)setUpDefaultValues {
    _continuous = YES;
    _minimumValue = 0.;
    _maximumValue = 100.;
    _currentValue = 50.;
}

- (void)setUpViews {
    self.backgroundColor = [UIColor clearColor];
    CGPoint center = CGPointMake(self.bounds.size.width / 2., self.bounds.size.height / 2.);

    _handler = [[UIImageView alloc] init];
    _handler.center = center;

    _backgroundRangeImageView = [[UIImageView alloc] init];
    [self updateView:_backgroundRangeImageView frameChange:^(CGRect *frame) {
        frame->size.width = self.bounds.size.width;
    }];
    _backgroundRangeImageView.center = center;
    _backgroundRangeImageView.frame = CGRectIntegral(_backgroundRangeImageView.frame);
    _backgroundRangeImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    _slidingView = [[UIView alloc] init];
    _slidingView.userInteractionEnabled = NO;

    _selectedRangeImageView = [[UIImageView alloc] init];
    _selectedRangeImageView.center = CGPointMake(0, center.y);
    _selectedRangeImageView.frame = CGRectIntegral(_selectedRangeImageView.frame);
    _selectedRangeImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    [self addSubview:self.slidingView];
    [self addSubview:self.backgroundRangeImageView];
    [self addSubview:self.selectedRangeImageView];
    [self addSubview:self.handler];

    [self updateStyle];
}

- (void)setStyle:(id<BMASliderStyling>)style {
    _style = style;
    [self updateStyle];
}

- (void)updateStyle {
    self.handler.image = [self handlerImage];
    self.backgroundRangeImageView.image = [self unselectedLineImage];
    self.selectedRangeImageView.image = [self selectedLineImage];

    [self updateView:self.handler frameChange:^(CGRect *frame) {
        frame->size = [self handlerImage].size;
    }];

    [self updateView:self.selectedRangeImageView frameChange:^(CGRect *frame) {
        frame->size.height = [self lineHeight];
    }];

    [self updateView:self.backgroundRangeImageView frameChange:^(CGRect *frame) {
        frame->size.height = [self lineHeight];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateUI];
}

- (void)updateUI {
    [self updateSlidingView];
    [self updateSelectedRange];
    [self placeHandler];
}

- (void)updateSlidingView {
    self.slidingView.frame = UIEdgeInsetsInsetRect(_backgroundRangeImageView.frame, [self slidingViewEdgeInsets]);
}

- (void)updateSelectedRange {
    CGFloat width = [self selectedRangeNormalizedLength] * self.backgroundRangeImageView.bounds.size.width;
    [self updateView:self.selectedRangeImageView frameChange:^(CGRect *frame) {
        frame->size.width = width;
    }];
}

- (void)placeHandler {
    CGFloat centerX = self.slidingView.frame.origin.x + [self selectedRangeNormalizedLength] * self.slidingView.bounds.size.width;
    self.handler.center = CGPointMake(centerX, self.backgroundRangeImageView.center.y);
}

#pragma mark - Convenience accessors

- (CGFloat)selectedRangeNormalizedLength {
    return (self.currentValue - self.minimumValue) / (self.maximumValue - self.minimumValue);
}

#pragma mark - User interaction

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];

    if (CGRectContainsPoint(UIEdgeInsetsInsetRect(self.handler.frame, self.touchEdgeInsets), touchPoint)) {
        self.handler.highlighted = YES;
    }

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (!self.handler.highlighted) {
        return YES;
    }

    CGPoint touchPoint = [touch locationInView:self.slidingView];
    CGFloat newValue = (touchPoint.x / [self rangeWidth]) * (self.maximumValue - self.minimumValue) + self.minimumValue;

    if (self.handler.highlighted) {
        [self setCurrentValue:newValue animated:YES];
    }

    if (self.continuous) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }

    [self setNeedsLayout];

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.handler.highlighted = NO;

    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - Styling

- (UIImage *)unselectedLineImage {
    return [self.style unselectedLineImage];
}

- (UIImage *)selectedLineImage {
    return [self.style selectedLineImage];
}

- (UIImage *)handlerImage {
    return [self.style handlerImage];
}

- (CGFloat)lineHeight {
    return [self unselectedLineImage].size.height;
}

#pragma mark - Convenience accessors
- (CGFloat)rangeWidth {
    return self.slidingView.bounds.size.width;
}

#pragma mark - Setters

- (void)setCurrentValue:(CGFloat)value {
    [self setCurrentValue:value animated:NO];
}

- (void)setCurrentValue:(CGFloat)value animated:(BOOL)animated {
    [self executeBlock:^{
        self.overflow = value > [self overflowThresholdValue];
        _currentValue = [self sanitizeValue:value];
    } animated:animated];
}

- (void)executeBlock:(void (^)(void))block animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:[self animationDuration]
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             block();
                             [self updateUI];
                         }
                         completion:nil];
    } else {
        block();
        [self setNeedsLayout];
    }
}

- (CGFloat)sanitizeValue:(CGFloat)value {
    value = [self stepValue:value];
    value = MIN(value, self.maximumValue);
    value = MAX(value, self.minimumValue);
    return value;
}

- (CGFloat)stepValue:(CGFloat)value {
    if (self.step > 0.) {
        CGFloat lowerSteppedValue = (CGFloat)floor((value - self.minimumValue) / self.step) * self.step + self.minimumValue;
        CGFloat upperSteppedValue = lowerSteppedValue + self.step;
        value = (value - lowerSteppedValue < upperSteppedValue - value) ? lowerSteppedValue : upperSteppedValue;
    }
    return value;
}

- (void)setMaximumValue:(CGFloat)maximumValue {
    _maximumValue = maximumValue;
    [self setNeedsLayout];
}

- (void)setMinimumValue:(CGFloat)minimumValue {
    _minimumValue = minimumValue;
    [self setNeedsLayout];
}

- (NSTimeInterval)animationDuration {
    return 0.10;
}

- (UIEdgeInsets)touchEdgeInsets {
    return UIEdgeInsetsMake(-10., -10., -10., -10.);
}

- (UIEdgeInsets)slidingViewEdgeInsets {
    // Make handler to be tangential with end of background.
    return UIEdgeInsetsMake(0., (self.handler.bounds.size.width / 2.) - 1., 0., (self.handler.bounds.size.width / 2.) - 1.);
}

- (CGFloat)overflowThresholdValue {
    CGFloat thresholdValue = self.maximumValue + [self overflowDistance] * (self.maximumValue - self.minimumValue) / [self rangeWidth];

    return thresholdValue;
}

- (CGFloat)underflowThresholdValue {
    CGFloat thresholdValue = self.minimumValue - [self overflowDistance] * (self.maximumValue - self.minimumValue) / [self rangeWidth];

    return thresholdValue;
}

- (CGFloat)overflowDistance {
    return 20.;
}

- (void)updateView:(UIView *)view frameChange:(void (^)(CGRect *frame))frameChange {
    CGRect frame = view.frame;
    frameChange(&frame);
    view.frame = frame;
}

@end
