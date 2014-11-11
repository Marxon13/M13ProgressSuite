//
//  SegmentedBarViewController.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SegmentedBarViewController.h"

@interface SegmentedBarViewController ()

@end

@implementation SegmentedBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //Set the orientations
    _progressViewVertical.progressDirection = M13ProgressViewSegmentedBarProgressDirectionBottomToTop;
    _progressViewHorizontal.progressDirection = M13ProgressViewSegmentedBarProgressDirectionLeftToRight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)progressChanged:(id)sender
{
    [_progressViewHorizontal setProgress:_progressSlider.value animated:NO];
    [_progressViewVertical setProgress:_progressSlider.value animated:NO];
}

- (void)directioChanged:(id)sender
{
    if (_directionControl.selectedSegmentIndex == 0) {
        [_progressViewHorizontal setProgressDirection:M13ProgressViewSegmentedBarProgressDirectionLeftToRight];
        [_progressViewVertical setProgressDirection:M13ProgressViewSegmentedBarProgressDirectionBottomToTop];
    } else {
        [_progressViewVertical setProgressDirection:M13ProgressViewSegmentedBarProgressDirectionTopToBottom];
        [_progressViewHorizontal setProgressDirection:M13ProgressViewSegmentedBarProgressDirectionRightToLeft];
    }
}

- (void)indeterminateChanged:(id)sender
{
    [_progressViewHorizontal setIndeterminate:_indeterminateSwitch.on];
    [_progressViewVertical setIndeterminate:_indeterminateSwitch.on];
}

- (void)animateProgress:(id)sender
{
    //Disable other controls
    _progressSlider.enabled = NO;
    _iconControl.enabled = NO;
    _indeterminateSwitch.enabled = NO;
    _directionControl.enabled = NO;
    
    [self performSelector:@selector(setQuarter) withObject:Nil afterDelay:1];
}

- (void)setQuarter
{
    [_progressViewHorizontal setProgress:.25 animated:YES];
    [_progressViewVertical setProgress:.25 animated:YES];
    [self performSelector:@selector(setTwoThirds) withObject:nil afterDelay:3];
}

- (void)setTwoThirds
{
    [_progressViewHorizontal setProgress:.66 animated:YES];
    [_progressViewVertical setProgress:.66 animated:YES];
    [self performSelector:@selector(setThreeQuarters) withObject:nil afterDelay:1];
}

- (void)setThreeQuarters
{
    [_progressViewHorizontal setProgress:.75 animated:YES];
    [_progressViewVertical setProgress:.75 animated:YES];
    [self performSelector:@selector(setOne) withObject:nil afterDelay:1.5];
}

- (void)setOne
{
    [_progressViewHorizontal setProgress:1.0 animated:YES];
    [_progressViewVertical setProgress:1.0 animated:YES];
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:_progressViewHorizontal.animationDuration + .1];
}

- (void)setComplete
{
    [_progressViewHorizontal performAction:M13ProgressViewActionSuccess animated:YES];
    [_progressViewVertical performAction:M13ProgressViewActionSuccess animated:YES];
    [self performSelector:@selector(reset) withObject:nil afterDelay:1.5];
}

- (void)reset
{
    [_progressViewHorizontal performAction:M13ProgressViewActionNone animated:YES];
    [_progressViewHorizontal setProgress:0 animated:YES];
    [_progressViewVertical performAction:M13ProgressViewActionNone animated:YES];
    [_progressViewVertical setProgress:0 animated:YES];
    //Enable other controls
    _progressSlider.enabled = YES;
    _iconControl.enabled = YES;
    _indeterminateSwitch.enabled = YES;
    _directionControl.enabled = YES;
}

- (void)iconChanged:(id)sender
{
    if (_iconControl.selectedSegmentIndex == 0) {
        [_progressViewHorizontal performAction:M13ProgressViewActionNone animated:YES];
        [_progressViewVertical performAction:M13ProgressViewActionNone animated:YES];
    } else if (_iconControl.selectedSegmentIndex == 1) {
        [_progressViewHorizontal performAction:M13ProgressViewActionSuccess animated:YES];
        [_progressViewVertical performAction:M13ProgressViewActionSuccess animated:YES];
    } else if (_iconControl.selectedSegmentIndex == 2) {
        [_progressViewHorizontal performAction:M13ProgressViewActionFailure animated:YES];
        [_progressViewVertical performAction:M13ProgressViewActionFailure animated:YES];
    }
}

- (void)shapeChanged:(id)sender
{
    if (_shapeControl.selectedSegmentIndex == 0) {
        [_progressViewHorizontal setSegmentShape:M13ProgressViewSegmentedBarSegmentShapeRectangle];
        [_progressViewVertical setSegmentShape:M13ProgressViewSegmentedBarSegmentShapeRectangle];
    } else if (_shapeControl.selectedSegmentIndex == 1) {
        [_progressViewHorizontal setSegmentShape:M13ProgressViewSegmentedBarSegmentShapeRoundedRect];
        [_progressViewVertical setSegmentShape:M13ProgressViewSegmentedBarSegmentShapeRoundedRect];
    } else if (_shapeControl.selectedSegmentIndex == 2) {
        [_progressViewHorizontal setSegmentShape:M13ProgressViewSegmentedBarSegmentShapeCircle];
        [_progressViewVertical setSegmentShape:M13ProgressViewSegmentedBarSegmentShapeCircle];
    }
}

- (void)colorizeChanged:(id)sender
{
    if (_colorizeSwitch.on) {
        NSArray *foregroundColors = @[[UIColor colorWithRed:0.12 green:0.98 blue:0.33 alpha:1],
                                      [UIColor colorWithRed:0.12 green:0.98 blue:0.33 alpha:1],
                                      [UIColor colorWithRed:0.12 green:0.98 blue:0.33 alpha:1],
                                      [UIColor colorWithRed:0.12 green:0.98 blue:0.33 alpha:1],
                                      [UIColor colorWithRed:0.12 green:0.98 blue:0.33 alpha:1],
                                      [UIColor colorWithRed:0.12 green:0.98 blue:0.33 alpha:1],
                                      [UIColor colorWithRed:0.12 green:0.98 blue:0.33 alpha:1],
                                      [UIColor colorWithRed:0.12 green:0.98 blue:0.33 alpha:1],
                                      [UIColor colorWithRed:1 green:0.96 blue:0.32 alpha:1],
                                      [UIColor colorWithRed:1 green:0.96 blue:0.32 alpha:1],
                                      [UIColor colorWithRed:1 green:0.96 blue:0.32 alpha:1],
                                      [UIColor colorWithRed:1 green:0.96 blue:0.32 alpha:1],
                                      [UIColor colorWithRed:1 green:0.12 blue:0.12 alpha:1],
                                      [UIColor colorWithRed:1 green:0.12 blue:0.12 alpha:1],
                                      [UIColor colorWithRed:1 green:0.12 blue:0.12 alpha:1],
                                      [UIColor colorWithRed:1 green:0.12 blue:0.12 alpha:1]];
        
        NSArray *backgroundColors = @[[UIColor colorWithRed:0.07 green:0.44 blue:0.14 alpha:1],
                                      [UIColor colorWithRed:0.07 green:0.44 blue:0.14 alpha:1],
                                      [UIColor colorWithRed:0.07 green:0.44 blue:0.14 alpha:1],
                                      [UIColor colorWithRed:0.07 green:0.44 blue:0.14 alpha:1],
                                      [UIColor colorWithRed:0.07 green:0.44 blue:0.14 alpha:1],
                                      [UIColor colorWithRed:0.07 green:0.44 blue:0.14 alpha:1],
                                      [UIColor colorWithRed:0.07 green:0.44 blue:0.14 alpha:1],
                                      [UIColor colorWithRed:0.07 green:0.44 blue:0.14 alpha:1],
                                      [UIColor colorWithRed:0.82 green:0.79 blue:0.25 alpha:1],
                                      [UIColor colorWithRed:0.82 green:0.79 blue:0.25 alpha:1],
                                      [UIColor colorWithRed:0.82 green:0.79 blue:0.25 alpha:1],
                                      [UIColor colorWithRed:0.82 green:0.79 blue:0.25 alpha:1],
                                      [UIColor colorWithRed:0.69 green:0.07 blue:0.1 alpha:1],
                                      [UIColor colorWithRed:0.69 green:0.07 blue:0.1 alpha:1],
                                      [UIColor colorWithRed:0.69 green:0.07 blue:0.1 alpha:1],
                                      [UIColor colorWithRed:0.69 green:0.07 blue:0.1 alpha:1]];
        
        _progressViewHorizontal.primaryColors = foregroundColors;
        _progressViewHorizontal.secondaryColors = backgroundColors;
        _progressViewVertical.primaryColors = foregroundColors;
        _progressViewVertical.secondaryColors = backgroundColors;
    } else {
        _progressViewHorizontal.primaryColors = nil;
        _progressViewHorizontal.secondaryColors = nil;
        _progressViewVertical.primaryColors = nil;
        _progressViewVertical.secondaryColors = nil;
    }
}

@end
