//
//  LetterpressViewController.m
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 4/28/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "LetterpressViewController.h"

@interface LetterpressViewController ()

@end

@implementation LetterpressViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gridPointsXChanged:(id)sender
{
    UIStepper *stepper = sender;
    CGPoint temp = _progressView.numberOfGridPoints;
    temp.x = stepper.value;
    _progressView.numberOfGridPoints = temp;
}

- (void)gridPointsYChanged:(id)sender
{
    UIStepper *stepper = sender;
    CGPoint temp = _progressView.numberOfGridPoints;
    temp.y = stepper.value;
    _progressView.numberOfGridPoints = temp;
}

- (void)pointShapeChanged:(id)sender
{
    UISegmentedControl *segemented = sender;
    if (segemented.selectedSegmentIndex == 0) {
        _progressView.pointShape = M13ProgressViewLetterpressPointShapeCircle;
        _progressView.pointSpacing = 0.0;
    } else {
        _progressView.pointShape = M13ProgressViewLetterpressPointShapeSquare;
        _progressView.pointSpacing = .15;
    }
}

- (void)notchSizeXChanged:(id)sender
{
    UIStepper *stepper = sender;
    CGSize temp = _progressView.notchSize;
    temp.width = stepper.value;
    _progressView.notchSize = temp;
}

- (void)notchSizeYChanged:(id)sender
{
    UIStepper *stepper = sender;
    CGSize temp = _progressView.notchSize;
    temp.height = stepper.value;
    _progressView.notchSize = temp;
}

- (void)progressChanged:(id)sender
{
    [_progressView setProgress:_progressSlider.value animated:NO];
}

- (void)animateProgress:(id)sender
{
    //Disable other controls
    _progressSlider.enabled = NO;
    
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
}

@end
