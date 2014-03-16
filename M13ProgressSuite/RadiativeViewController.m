//
//  RadiativeViewController.m
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 3/13/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "RadiativeViewController.h"

@interface RadiativeViewController ()

@end

@implementation RadiativeViewController

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
    _progressView.numberOfRipples = 37;
    _progressView.ripplesRadius = 75;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)progressChanged:(id)sender
{
    [_progressView setProgress:_progressSlider.value animated:NO];
}

- (void)indeterminateChanged:(id)sender
{
    [_progressView setIndeterminate:_indeterminateSwitch.on];
}

- (void)shapeChanged:(id)sender
{
    if (_shapeControl.selectedSegmentIndex == 0) {
        _progressView.shape = M13ProgressViewRadiativeShapeCircle;
    } else {
        _progressView.shape = M13ProgressViewRadiativeShapeSquare;
    }
}

- (void)numberOfRipplesChanged:(id)sender
{
    _progressView.numberOfRipples = ceilf(_numberOfRipplesSlider.value);
}

- (void)directionChanged:(id)sender
{
    _progressView.progressOutwards = _outwardSwitch.on;
}

- (void)animateProgress:(id)sender
{
    //Disable other controls
    _progressSlider.enabled = NO;
    _indeterminateSwitch.enabled = NO;
    
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
    [_progressView setProgress:0.0 animated:YES];
    //Enable other controls
    _progressSlider.enabled = YES;
    _indeterminateSwitch.enabled = YES;
}

@end
