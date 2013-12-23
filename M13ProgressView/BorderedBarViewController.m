//
//  BorderedBarViewController.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "BorderedBarViewController.h"

@interface BorderedBarViewController ()

@end

@implementation BorderedBarViewController

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
    _progressViewVertical.progressDirection = M13ProgressViewBorderedBarProgressDirectionBottomToTop;
    _progressViewHorizontal.progressDirection = M13ProgressViewBorderedBarProgressDirectionLeftToRight;

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
        [_progressViewHorizontal setProgressDirection:M13ProgressViewBorderedBarProgressDirectionLeftToRight];
        [_progressViewVertical setProgressDirection:M13ProgressViewBorderedBarProgressDirectionBottomToTop];
    } else {
        [_progressViewVertical setProgressDirection:M13ProgressViewBorderedBarProgressDirectionTopToBottom];
        [_progressViewHorizontal setProgressDirection:M13ProgressViewBorderedBarProgressDirectionRightToLeft];
    }
}

- (void)indeterminateChanged:(id)sender
{
    [_progressViewHorizontal setIndeterminate:_indeterminateSwitch.on];
    [_progressViewVertical setIndeterminate:_indeterminateSwitch.on];
}

- (void)cornerTypeChanged:(id)sender
{
    if (_cornerTypeControl.selectedSegmentIndex == 0) {
        _progressViewHorizontal.cornerType = M13ProgressViewBorderedBarCornerTypeSquare;
        _progressViewVertical.cornerType = M13ProgressViewBorderedBarCornerTypeSquare;
    } else if (_cornerTypeControl.selectedSegmentIndex == 1) {
        _progressViewVertical.cornerType = M13ProgressViewBorderedBarCornerTypeRounded;
        _progressViewHorizontal.cornerType = M13ProgressViewBorderedBarCornerTypeRounded;
    } else if (_cornerTypeControl.selectedSegmentIndex == 2) {
        _progressViewHorizontal.cornerType = M13ProgressViewBorderedBarCornerTypeCircle;
        _progressViewVertical.cornerType = M13ProgressViewBorderedBarCornerTypeCircle;
    }
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

@end
