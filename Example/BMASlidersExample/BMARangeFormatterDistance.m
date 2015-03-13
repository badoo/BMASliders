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

#import "BMARangeFormatterDistance.h"

@implementation BMARangeFormatterDistance
@synthesize hasLowerValue;
@synthesize lowerValue;
@synthesize upperValue;
@synthesize overflow;

- (BMADistanceUnit)distanceUnit {
    if (_distanceUnit == BMADistanceUnitDefault) {
        NSLocale *locale = [NSLocale currentLocale];
        BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
        _distanceUnit = isMetric ? BMADistanceUnitMetric : BMADistanceUnitImperial;
    }
    return _distanceUnit;
}

- (NSString *)distanceUnitString {
    switch (self.distanceUnit) {
        case BMADistanceUnitDefault:
            NSAssert(NO, @"Should not reach this");
            break;
        case BMADistanceUnitMetric:
            return NSLocalizedString(@"Km", nil);
            break;

        case BMADistanceUnitImperial:
            return NSLocalizedString(@"mi", nil);
            break;
    }
    return nil;
}

- (NSAttributedString *)formattedString {
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", @(self.upperValue), [self distanceUnitString]]];
}

@end
