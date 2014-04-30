//
//  M13ProgressViewBarNavigationControllerViewController.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressViewBarNavigationControllerViewController.h"
#import "UINavigationController+M13ProgressViewBar.h"

@interface M13ProgressViewBarNavigationControllerViewController ()

@end

@implementation M13ProgressViewBarNavigationControllerViewController

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
    [self.navigationController showProgress];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)progressChanged:(id)sender
{
    [self.navigationController setProgress:_progressSlider.value animated:NO];
}

- (void)indeterminateChanged:(id)sender
{
    [self.navigationController setIndeterminate:_indeterminateSwitch.on];
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
    [self.navigationController setProgress:.25 animated:YES];
    [self performSelector:@selector(setTwoThirds) withObject:nil afterDelay:3];
}

- (void)setTwoThirds
{
    [self.navigationController setProgress:.66 animated:YES];
    [self performSelector:@selector(setThreeQuarters) withObject:nil afterDelay:1];
}

- (void)setThreeQuarters
{
    [self.navigationController setProgress:.75 animated:YES];
    [self performSelector:@selector(setOne) withObject:nil afterDelay:1.5];
}

- (void)setOne
{
    [self.navigationController setProgress:1.0 animated:YES];
    [self performSelector:@selector(setComplete) withObject:nil afterDelay:.5];
}

- (void)setComplete
{
    [self.navigationController finishProgress];
}

- (void)titleChanged:(id)sender
{
    if (_titleSwitch.on) {
        [self.navigationController setProgressTitle:@"Processing..."];
    } else {
        [self.navigationController setProgressTitle:nil];
    }
}

- (void)finish:(id)sender
{
    [self.navigationController finishProgress];
}

- (void)cancel:(id)sender
{
    [self.navigationController cancelProgress];
}

- (void)primaryColorChanged:(id)sender
{
    CGFloat red = (float)arc4random_uniform(256)/255.0;
    CGFloat green = (float)arc4random_uniform(256)/255.0;
    CGFloat blue = (float)arc4random_uniform(256)/255.0;
    [self.navigationController setPrimaryColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
}

- (void)secondaryColorChanged:(id)sender
{
    CGFloat red = (float)arc4random_uniform(256)/255.0;
    CGFloat green = (float)arc4random_uniform(256)/255.0;
    CGFloat blue = (float)arc4random_uniform(256)/255.0;
    [self.navigationController setSecondaryColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0]];
}

@end
