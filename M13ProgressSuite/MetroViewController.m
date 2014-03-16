//
//  MetroViewController.m
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 3/8/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "MetroViewController.h"
#import "M13ProgressViewMetroDotPolygon.h"

@interface MetroViewController ()

@end

@implementation MetroViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    ((M13ProgressViewMetroDotPolygon *)_progressView.metroDot).numberOfSides = 2;
    ((M13ProgressViewMetroDotPolygon *)_progressView.metroDot).radius = 8;
    [self.progressView beginAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeShape:(id)sender
{
    if (_shapeControl.selectedSegmentIndex == 0) {
        _progressView.animationShape = M13ProgressViewMetroAnimationShapeEllipse;
        ((M13ProgressViewMetroDotPolygon *)_progressView.metroDot).radius = 8;
        _progressView.dotSize = CGSizeMake(20, 20);
    } else if (_shapeControl.selectedSegmentIndex == 1) {
        _progressView.animationShape = M13ProgressViewMetroAnimationShapeRectangle;
        ((M13ProgressViewMetroDotPolygon *)_progressView.metroDot).radius = 8;
        _progressView.dotSize = CGSizeMake(20, 20);
    } else {
        _progressView.animationShape = M13ProgressViewMetroAnimationShapeLine;
        ((M13ProgressViewMetroDotPolygon *)_progressView.metroDot).radius = 4;
        _progressView.dotSize = CGSizeMake(10, 10);
    }
}

- (void)changeDot:(id)sender
{
    if (_dotControl.selectedSegmentIndex == 0) {
        ((M13ProgressViewMetroDotPolygon *)_progressView.metroDot).numberOfSides = 2;
        [((M13ProgressViewMetro *)_progressView) stopAnimating];
        [((M13ProgressViewMetro *)_progressView) beginAnimating];
    } else {
        ((M13ProgressViewMetroDotPolygon *)_progressView.metroDot).numberOfSides = 4;
        [((M13ProgressViewMetro *)_progressView) stopAnimating];
        [((M13ProgressViewMetro *)_progressView) beginAnimating];
    }
}

- (void)changeNumberOfDots:(id)sender
{
    ((M13ProgressViewMetro *)_progressView).numberOfDots = ceilf(_numberOfDotsControl.value);
}

- (void)changeIcon:(id)sender
{
    if (_iconControl.selectedSegmentIndex == 0) {
        [_progressView performAction:M13ProgressViewActionNone animated:YES];
    } else if (_iconControl.selectedSegmentIndex == 1) {
        [_progressView performAction:M13ProgressViewActionSuccess animated:YES];
    } else {
        [_progressView performAction:M13ProgressViewActionFailure animated:YES];
    }
}

- (void)changeProgress:(id)sender
{
    [_progressView setProgress:_progressSlider.value animated:YES];
}

- (void)animateProgress:(id)sender
{
    //Disable other controls
    _progressSlider.enabled = NO;
    _iconControl.enabled = NO;
    
    [self performSelector:@selector(setQuarter) withObject:Nil afterDelay:1];
}

- (void)setQuarter
{
    [_progressView setProgress:.25 animated:YES];
    [self performSelector:@selector(setTwoThirds) withObject:nil afterDelay:3];
}

- (void)setTwoThirds
{
    [_progressView setProgress:.66 animated:YES];
    [self performSelector:@selector(setThreeQuarters) withObject:nil afterDelay:1];
}

- (void)setThreeQuarters
{
    [_progressView setProgress:.75 animated:YES];
    [self performSelector:@selector(setOne) withObject:nil afterDelay:1.5];
}

- (void)setOne
{
    [_progressView setProgress:1.0 animated:YES];
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:_progressView.animationDuration + .1];
}

- (void)setComplete
{
    [_progressView performAction:M13ProgressViewActionSuccess animated:YES];
    [self performSelector:@selector(reset) withObject:nil afterDelay:1.5];
}

- (void)reset
{
    [_progressView performAction:M13ProgressViewActionNone animated:YES];
    [_progressView setProgress:0 animated:YES];
    //Enable other controls
    _progressSlider.enabled = YES;
    _iconControl.enabled = YES;
}

@end
