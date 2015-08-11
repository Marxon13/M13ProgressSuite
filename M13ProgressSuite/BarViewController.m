//
//  BarViewController.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "BarViewController.h"

@interface BarViewController ()

@end

@implementation BarViewController

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
    _progressViewVertical.progressDirection = M13ProgressViewBarProgressDirectionBottomToTop;
    _progressViewHorizontal.progressDirection = M13ProgressViewBarProgressDirectionLeftToRight;
    //Set the percentage position
    _progressViewVertical.percentagePosition = M13ProgressViewBarPercentagePositionTop;
    _progressViewHorizontal.percentagePosition = M13ProgressViewBarPercentagePositionTop;
    
    // Remove corner radius
    _progressViewVertical.progressBarCornerRadius = 0.0;
    _progressViewHorizontal.progressBarCornerRadius = 0.0;
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

- (void)percentagePositionChangeed:(id)sender
{
    if (_positionControl.selectedSegmentIndex == 0) {
        [_progressViewHorizontal setPercentagePosition:M13ProgressViewBarPercentagePositionTop];
        [_progressViewVertical setPercentagePosition:M13ProgressViewBarPercentagePositionTop];
    } else if (_positionControl.selectedSegmentIndex == 1) {
        [_progressViewVertical setPercentagePosition:M13ProgressViewBarPercentagePositionBottom];
        [_progressViewHorizontal setPercentagePosition:M13ProgressViewBarPercentagePositionBottom];
    } else if (_positionControl.selectedSegmentIndex == 2) {
        [_progressViewHorizontal setPercentagePosition:M13ProgressViewBarPercentagePositionLeft];
        [_progressViewVertical setPercentagePosition:M13ProgressViewBarPercentagePositionLeft];
    } else if (_positionControl.selectedSegmentIndex == 3) {
        [_progressViewVertical setPercentagePosition:M13ProgressViewBarPercentagePositionRight];
        [_progressViewHorizontal setPercentagePosition:M13ProgressViewBarPercentagePositionRight];
    }
}

- (void)showPercentage:(id)sender
{
    [_progressViewHorizontal setShowPercentage:_showPercentageSwitch.on];
    [_progressViewVertical setShowPercentage:_showPercentageSwitch.on];
}

- (void)directioChanged:(id)sender
{
    if (_directionControl.selectedSegmentIndex == 0) {
        [_progressViewHorizontal setProgressDirection:M13ProgressViewBarProgressDirectionLeftToRight];
        [_progressViewVertical setProgressDirection:M13ProgressViewBarProgressDirectionBottomToTop];
    } else {
        [_progressViewVertical setProgressDirection:M13ProgressViewBarProgressDirectionTopToBottom];
        [_progressViewHorizontal setProgressDirection:M13ProgressViewBarProgressDirectionRightToLeft];
    }
}

- (void)indeterminateChanged:(id)sender
{
    [_progressViewHorizontal setIndeterminate:_indeterminateSwitch.on];
    [_progressViewVertical setIndeterminate:_indeterminateSwitch.on];
}

- (IBAction)cornerRadiusChanged:(id)sender
{
    [_progressViewHorizontal setProgressBarCornerRadius:_cornerRadiusSwitch.on ? _progressViewHorizontal.progressBarThickness / 2.0 : 0.0];
    [_progressViewVertical setProgressBarCornerRadius:_cornerRadiusSwitch.on ? _progressViewVertical.progressBarThickness / 2.0 : 0.0];
}

- (void)animateProgress:(id)sender
{
    //Disable other controls
    _progressSlider.enabled = NO;
    _iconControl.enabled = NO;
    _indeterminateSwitch.enabled = NO;
    _showPercentageSwitch.enabled = NO;
    _directionControl.enabled = NO;
    _positionControl.enabled = NO;
    
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
    _showPercentageSwitch.enabled = YES;
    _directionControl.enabled = YES;
    _positionControl.enabled = YES;
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

@end
