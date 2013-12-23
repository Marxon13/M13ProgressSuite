//
//  ConsoleViewController.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "ConsoleViewController.h"

@interface ConsoleViewController ()

@end

@implementation ConsoleViewController
{
    float progress;
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
    _console.prefix = @"$ ";
    _console.progressType = M13ProgressConsoleProgressTypePercentage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prefixChanged:(id)sender
{
    if (_prefixSwitch.on) {
        _console.prefix = @"$ ";
    } else {
        _console.prefix = nil;
    }
}

- (void)progressTypeChanged:(id)sender
{
    if (_progressType.selectedSegmentIndex == 0) {
        _console.progressType = M13ProgressConsoleProgressTypePercentage;
    } else if (_progressType.selectedSegmentIndex == 1) {
        _console.progressType = M13ProgressConsoleProgressTypeDots;
    } else if (_progressType.selectedSegmentIndex == 2) {
        _console.progressType = M13ProgressConsoleProgressTypeBarOfDots;
    }
}

- (void)animate:(id)sender
{
    _animateButton.enabled = NO;
    _progressType.enabled = NO;
    _prefixSwitch.enabled = NO;
    
    progress = 0;
    [_console addNewLineWithString:@"Downloading Index"];
    [self runThroughProgress];
    [self performSelector:@selector(stepOne) withObject:nil afterDelay:3.0];
}

- (void)stepOne
{
    [_console addNewLineWithString:@"Complete!"];
    progress = 0;
    [_console addNewLineWithString:@"Downloading file 1/2"];
    [self runThroughProgress];
    [self performSelector:@selector(stepTwo) withObject:nil afterDelay:3.0];
}

- (void)stepTwo
{
    progress = 0;
    [_console setCurrentLine:@"Downloading file 2/2"];
    [self runThroughProgress];
    [self performSelector:@selector(stepThree) withObject:nil afterDelay:3.0];
}

- (void)stepThree
{
    [_console addNewLineWithString:@"Processing Data"];
    [_console setIndeterminate:YES];
    [self performSelector:@selector(finished) withObject:nil afterDelay:5.0];
}

- (void)finished
{
    _animateButton.enabled = YES;
    _progressType.enabled = YES;
    _prefixSwitch.enabled = YES;
    [_console addNewLineWithString:@"Finished Downloading"];
    [_console clear];
}

- (void)runThroughProgress
{
    if (progress < 1) {
        progress += .02;
        [_console setProgress:progress];
        [self performSelector:@selector(runThroughProgress) withObject:nil afterDelay:.05];
    }
}


@end
