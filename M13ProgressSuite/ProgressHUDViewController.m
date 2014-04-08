//
//  ProgressHUDViewController.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "ProgressHUDViewController.h"
#import "M13ProgressHUD.h"
#import "M13ProgressViewRing.h"
#import "AppDelegate.h"

@interface ProgressHUDViewController ()

@end

@implementation ProgressHUDViewController
{
    M13ProgressHUD *HUD;
}

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
    _imageView.image = [UIImage imageNamed:@"Galaxy.jpg"];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.contentSize = CGSizeMake(320, 750);
    HUD = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];
    HUD.progressViewSize = CGSizeMake(60.0, 60.0);
    HUD.animationPoint = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [window addSubview:HUD];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _scrollView.contentSize = CGSizeMake(320, 750);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)progressChanged:(id)sender
{
    [HUD setProgress:_progressSlider.value animated:NO];
}

- (void)indeterminateChanged:(id)sender
{
    [HUD setIndeterminate:_indeterminateSwitch.on];
}

- (void)animateProgress:(id)sender
{
    //Disable other controls
    _progressSlider.enabled = NO;
    _iconControl.enabled = NO;
    _indeterminateSwitch.enabled = NO;
    _maskTypeControl.enabled = NO;
    _superviewControl.enabled = NO;
    HUD.status = @"Loading";
    
    [HUD show:YES];
    [self performSelector:@selector(setQuarter) withObject:Nil afterDelay:1];
}

- (void)setQuarter
{
    [HUD setProgress:.25 animated:YES];
    HUD.status = @"Processing";
    [self performSelector:@selector(setTwoThirds) withObject:nil afterDelay:3];
}

- (void)setTwoThirds
{
    [HUD setProgress:.66 animated:YES];
    [self performSelector:@selector(setThreeQuarters) withObject:nil afterDelay:1];
}

- (void)setThreeQuarters
{
    HUD.status = @"Finishing Processing";
    [HUD setProgress:.75 animated:YES];
    [self performSelector:@selector(setOne) withObject:nil afterDelay:1.5];
}

- (void)setOne
{
    [HUD setProgress:1.0 animated:YES];
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:HUD.animationDuration + .1];
}

- (void)setComplete
{
    [HUD performAction:M13ProgressViewActionSuccess animated:YES];
    [self performSelector:@selector(reset) withObject:nil afterDelay:1.5];
}

- (void)reset
{
    [HUD hide:YES];
    [HUD performAction:M13ProgressViewActionNone animated:NO];
    //Enable other controls
    _iconControl.enabled = YES;
    _indeterminateSwitch.enabled = YES;
    _maskTypeControl.enabled = YES;
    _superviewControl.enabled = YES;
}

- (void)iconChanged:(id)sender
{
    if (_iconControl.selectedSegmentIndex == 0) {
        [HUD performAction:M13ProgressViewActionNone animated:YES];
    } else if (_iconControl.selectedSegmentIndex == 1) {
        [HUD performAction:M13ProgressViewActionSuccess animated:YES];
    } else if (_iconControl.selectedSegmentIndex == 2) {
        [HUD performAction:M13ProgressViewActionFailure animated:YES];
    }
}

- (void)blurChanged:(id)sender
{
    [HUD setApplyBlurToBackground:_blurSwitch.on];
}

- (void)statusPositionChanged:(id)sender
{
    if (_statusPositionControl.selectedSegmentIndex == 0) {
        [HUD setStatusPosition:M13ProgressHUDStatusPositionBelowProgress];
    } else if (_statusPositionControl.selectedSegmentIndex == 1) {
        [HUD setStatusPosition:M13ProgressHUDStatusPositionAboveProgress];
    } else if (_statusPositionControl.selectedSegmentIndex == 2) {
        [HUD setStatusPosition:M13ProgressHUDStatusPositionLeftOfProgress];
    } else if (_statusPositionControl.selectedSegmentIndex == 3) {
        [HUD setStatusPosition:M13ProgressHUDStatusPositionRightOfProgress];
    }
}

- (void)maskTypeChanged:(id)sender
{
    if (_maskTypeControl.selectedSegmentIndex == 0) {
        [HUD setMaskType:M13ProgressHUDMaskTypeNone];
    } else if (_maskTypeControl.selectedSegmentIndex == 1) {
        [HUD setMaskType:M13ProgressHUDMaskTypeSolidColor];
    } else if (_maskTypeControl.selectedSegmentIndex == 2) {
        [HUD setMaskType:M13ProgressHUDMaskTypeGradient];
    } else if (_maskTypeControl.selectedSegmentIndex == 3) {
        [HUD setMaskType:M13ProgressHUDMaskTypeIOS7Blur];
    }
}

- (void)superviewChanged:(id)sender
{
    if (_superviewControl.selectedSegmentIndex == 0) {
        [HUD removeFromSuperview];
        UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        [window addSubview:HUD];
    } else {
        [HUD removeFromSuperview];
        [_imageView addSubview:HUD];
    }

}
@end
