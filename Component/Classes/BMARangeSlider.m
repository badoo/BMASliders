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

#import "BMARangeSlider.h"
#import "BMASliderLiveRenderingStyle.h"

typedef NS_ENUM(NSUInteger, BMARangeSliderHandler) {
    BMARangeSliderHandlerNone,
    BMARangeSliderHandlerLower,
    BMARangeSliderHandlerUpper
};

@interface BMARangeSlider ()

@property (nonatomic, strong) UIView *slidingView;
@property (nonatomic, strong) UIImageView *selectedRangeImageView;
@property (nonatomic, strong) UIImageView *backgroundRangeImageView;
@property (nonatomic, strong) UIImageView *lowerHandler;
@property (nonatomic, strong) UIImageView *upperHandler;
@property (nonatomic) UIEdgeInsets touchEdgeInsets;
@property (nonatomic, readwrite, getter=isUnderflow) BOOL underflow;
@property (nonatomic, readwrite, getter=isOverflow) BOOL overflow;

@end

@implementation BMARangeSlider

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
    _maximumValue = 100.;
    _minimumValue = 0.;
    _currentLowerValue = 30.;
    _currentUpperValue = 70.;
    _step = 1.;
    _continuous = YES;
}

- (void)setUpViews {
    self.backgroundColor = [UIColor clearColor];
    CGPoint center = CGPointMake(self.bounds.size.width / 2., self.bounds.size.height / 2.);

    _lowerHandler = [[UIImageView alloc] init];
    _lowerHandler.center = center;

    _upperHandler = [[UIImageView alloc] init];
    _upperHandler.center = center;

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
    _selectedRangeImageView.center = center;
    _selectedRangeImageView.frame = CGRectIntegral(_selectedRangeImageView.frame);
    _selectedRangeImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    [self addSubview:_slidingView];
    [self addSubview:_backgroundRangeImageView];
    [self addSubview:_selectedRangeImageView];
    [self addSubview:_lowerHandler];
    [self addSubview:_upperHandler];

    [self updateStyle];
}

- (void)setStyle:(id<BMASliderStyling>)style {
    _style = style;
    [self updateStyle];
}

- (void)updateStyle {
    self.lowerHandler.image = [self handlerImage];
    self.upperHandler.image = [self handlerImage];
    self.backgroundRangeImageView.image = [self unselectedLineImage];
    self.selectedRangeImageView.image = [self selectedLineImage];

    [self updateView:self.lowerHandler frameChange:^(CGRect *frame) {
        frame->size = [self handlerImage].size;
    }];

    [self updateView:self.upperHandler frameChange:^(CGRect *frame) {
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
    [self placeHandlers];
}

- (void)updateSlidingView {
    self.slidingView.frame = UIEdgeInsetsInsetRect(_backgroundRangeImageView.frame, [self slidingViewEdgeInsets]);
}

- (void)updateSelectedRange {
    CGFloat width = [self selectedRangeNormalizedLength] * self.slidingView.bounds.size.width;
    CGFloat originX = [self selectedRangeNormalizedOrigin] * self.slidingView.bounds.size.width + self.slidingView.frame.origin.x;

    [self updateView:self.selectedRangeImageView frameChange:^(CGRect *frame) {
        frame->size.width = width;
        frame->origin.x = originX;
    }];
}

- (void)placeHandlers {
    self.lowerHandler.center = CGPointMake(self.selectedRangeImageView.frame.origin.x, self.backgroundRangeImageView.center.y);
    self.upperHandler.center = CGPointMake(CGRectGetMaxX(self.selectedRangeImageView.frame), self.backgroundRangeImageView.center.y);
}

#pragma mark - Convenience accessors

- (CGFloat)selectedRangeNormalizedLength {
    return (self.currentUpperValue - self.currentLowerValue) / (self.maximumValue - self.minimumValue);
}

- (CGFloat)selectedRangeNormalizedOrigin {
    return (self.currentLowerValue - self.minimumValue) / (self.maximumValue - self.minimumValue);
}

#pragma mark - User interaction

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BMARangeSliderHandler targetHandler = [self targetHandlerWithTouch:touch];

    if (targetHandler == BMARangeSliderHandlerLower) {
        self.lowerHandler.highlighted = YES;
        [self bringSubviewToFront:self.lowerHandler];
    } else if (targetHandler == BMARangeSliderHandlerUpper) {
        self.upperHandler.highlighted = YES;
        [self bringSubviewToFront:self.upperHandler];
    }

    return YES;
}

- (BMARangeSliderHandler)targetHandlerWithTouch:(UITouch *)touch {
    BMARangeSliderHandler targetHandler = BMARangeSliderHandlerNone;

    CGPoint touchPoint = [touch locationInView:self];
    BOOL touchesLowerHandler = CGRectContainsPoint(UIEdgeInsetsInsetRect(self.lowerHandler.frame, self.touchEdgeInsets), touchPoint);
    BOOL touchesUpperHandler = CGRectContainsPoint(UIEdgeInsetsInsetRect(self.upperHandler.frame, self.touchEdgeInsets), touchPoint);

    if (touchesLowerHandler && !touchesUpperHandler) {
        targetHandler = BMARangeSliderHandlerLower;
    } else if (touchesUpperHandler && !touchesLowerHandler) {
        targetHandler = BMARangeSliderHandlerUpper;
    } else if (touchesLowerHandler && touchesUpperHandler) {
        if ([self normFromPoint:touchPoint toPoint:self.lowerHandler.center] < [self normFromPoint:touchPoint toPoint:self.upperHandler.center]) {
            targetHandler = BMARangeSliderHandlerLower;
        } else {
            targetHandler = BMARangeSliderHandlerUpper;
        }
    }

    return targetHandler;
}

- (CGFloat)normFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2 {
    CGFloat vx = p2.x - p1.x;
    CGFloat vy = p2.y - p1.y;
    return vx * vx + vy * vy;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (!self.lowerHandler.highlighted && !self.upperHandler.highlighted) {
        return YES;
    }

    CGPoint touchPoint = [touch locationInView:self.slidingView];
    CGFloat newValue = (touchPoint.x / [self rangeWidth]) * (self.maximumValue - self.minimumValue) + self.minimumValue;

    if (self.lowerHandler.highlighted) {
        [self setLowerBound:newValue animated:YES];
        if (!self.isOverflow)
            [self setUpperBound:MAX(_currentUpperValue, self.currentLowerValue + self.minimumDistance) animated:YES];
    } else if (self.upperHandler.highlighted) {
        [self setUpperBound:newValue animated:YES];
        [self setLowerBound:MIN(_currentLowerValue, self.currentUpperValue - self.minimumDistance) animated:YES];
    }

    if (self.continuous) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }

    [self setNeedsLayout];

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.lowerHandler.highlighted = NO;
    self.upperHandler.highlighted = NO;

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

- (void)setCurrentLowerValue:(CGFloat)value {
    [self setLowerBound:value animated:NO];
}

- (void)setLowerBound:(CGFloat)value animated:(BOOL)animated {
    [self executeBlock:^{
        self.underflow = value < [self underflowThresholdValue];
        _currentLowerValue = [self sanitizeValue:value withAdditionalMinimum:0. additionalMaximum:self.minimumDistance];
        
        if (_currentLowerValue > self.currentUpperValue) {
            self.currentUpperValue = _currentLowerValue;
        }
    } animated:animated];
}

- (void)setCurrentUpperValue:(CGFloat)value {
    [self setUpperBound:value animated:NO];
}

- (void)setUpperBound:(CGFloat)value animated:(BOOL)animated {
    [self executeBlock:^{
        self.overflow = value > [self overflowThresholdValue];
        _currentUpperValue = [self sanitizeValue:value withAdditionalMinimum:self.minimumDistance additionalMaximum:0.];
        if (_currentUpperValue < self.currentLowerValue) {
            self.currentLowerValue = _currentUpperValue;
        }
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

- (CGFloat)sanitizeValue:(CGFloat)value withAdditionalMinimum:(CGFloat)additionalMinimum additionalMaximum:(CGFloat)additionalMaximum {
    value = [self stepValue:value];
    value = MIN(value, self.maximumValue - additionalMaximum);
    value = MAX(value, self.minimumValue + additionalMinimum);
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
    // Make handlers to be tangential with end of background.

    return UIEdgeInsetsMake(0., (self.lowerHandler.bounds.size.width / 2.) - 1., 0., (self.lowerHandler.bounds.size.width / 2.) - 1.);
}

- (CGFloat)overflowThresholdValue {
    CGFloat thresholdValue = self.maximumValue + [self overflowDistance] * (self.maximumValue - self.minimumValue) / [self rangeWidth];

    if (!isfinite(thresholdValue)) {
        thresholdValue = self.maximumValue;
    }
    
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
