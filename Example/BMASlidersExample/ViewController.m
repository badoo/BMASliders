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

#import "ViewController.h"
#import "BMALabeledSliderConfigurator.h"
#import <BMASliders/BMALabeledRangeSlider.h>
#import <BMASliders/BMALabeledSlider.h>
#import <BMASliders/BMASliderLiveRenderingStyle.h>

@interface ViewController ()
@property (nonatomic, retain) IBOutletCollection(UIView) NSArray *containers;
@property (weak, nonatomic) IBOutlet BMALabeledRangeSlider *labeledRangeSlider;
@property (weak, nonatomic) IBOutlet BMALabeledSlider *labeledSlider;
@property (weak, nonatomic) IBOutlet BMARangeSlider *rangeSlider;
@property (weak, nonatomic) IBOutlet BMASlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *rangeSliderLabel;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureContainers];
    [self configureSliders];
}

- (void)configureContainers {
    for (UIView *view in self.containers) {
        view.layer.cornerRadius = 5.;
        view.layer.borderWidth = 1.;
        view.layer.borderColor = [UIColor grayColor].CGColor;
    }
}

- (void)configureSliders {
    [BMALabeledSliderConfigurator configureSlider:self.labeledRangeSlider
                                            style:BMALabeledSliderTypeAge];
    [BMALabeledSliderConfigurator configureSlider:self.labeledSlider
                                            style:BMALabeledSliderTypeDistance];
    self.rangeSlider.style = [[BMASliderLiveRenderingStyle alloc] init];
    [self updateRangeSliderLabel];
    [self updateSliderLabel];
}

- (IBAction)rangeSliderDidChangeValue:(BMARangeSlider *)sender {
    [self updateRangeSliderLabel];
}

- (void)updateRangeSliderLabel {
    self.rangeSliderLabel.text = [NSString stringWithFormat:@"%@-%@", @(self.rangeSlider.currentLowerValue), @(self.rangeSlider.currentUpperValue)];
}

- (IBAction)sliderDidChangeValue:(id)sender {
    [self updateSliderLabel];
}

- (void)updateSliderLabel {
    self.sliderLabel.text = [NSString stringWithFormat:@"%@", @(self.slider.currentValue)];
}

@end
