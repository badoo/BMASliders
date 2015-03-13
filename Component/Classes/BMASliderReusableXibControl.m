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

#import "BMASliderReusableXibControl.h"

@implementation BMASliderReusableXibControl

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class])
                                                               owner:self
                                                             options:nil] firstObject];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class])
                                                               owner:self
                                                             options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

/**
 *  Check: http://cocoanuts.mobi/2014/03/26/reusable/
 */
- (instancetype)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    if ([self.subviews count] > 0) {
        return self;
    }

    NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
    NSArray *loadedViews = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    UIView *loadedView = [loadedViews firstObject];

    loadedView.frame = self.frame;
    loadedView.autoresizingMask = self.autoresizingMask;
    loadedView.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;

    for (NSLayoutConstraint *constraint in self.constraints) {
        id firstItem = constraint.firstItem == self ? loadedView : constraint.firstItem;
        id secondItem = constraint.secondItem == self ? loadedView : constraint.secondItem;
        [loadedView addConstraint:[NSLayoutConstraint constraintWithItem:firstItem
                                                               attribute:constraint.firstAttribute
                                                               relatedBy:constraint.relation
                                                                  toItem:secondItem
                                                               attribute:constraint.secondAttribute
                                                              multiplier:constraint.multiplier
                                                                constant:constraint.constant]];
    }

    return (id)loadedView;
}

@end
