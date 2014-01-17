//
//  FilteredImageViewController.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "FilteredImageViewController.h"

@implementation CIFilter (M13ProgressViewFilteredImage)

- (void)setStartPropertyValues:(NSDictionary *)startPropertyValues
{
    
}

@end

@interface FilteredImageViewController ()

@end

@implementation FilteredImageViewController

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
    //Set the image
    [_progressView setProgressImage:[UIImage imageNamed:@"Striped_apple_logo.png"]];
    //Set default filters
    //Blur filter
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    //Set properties
    NSArray *parameters = @[
                            @{@"inputRadius" :
                                  @{kM13ProgressViewFilteredImageCIFilterStartValuesKey : @100.0, kM13ProgressViewFilteredImageCIFilterEndValuesKey : @0.0
                                    }
                             }
                            ];
    _progressView.filterParameters = parameters;
    [_progressView setFilters:@[blurFilter]];
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

- (void)filterChanged:(id)sender
{
    if (_filterControl.selectedSegmentIndex == 0) {
        //Blur filter
        CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [blurFilter setDefaults];
        //Set properties
        NSArray *parameters = @[
                                @{@"inputRadius" :
                                      @{kM13ProgressViewFilteredImageCIFilterStartValuesKey : @100.0, kM13ProgressViewFilteredImageCIFilterEndValuesKey : @0.0
                                        }
                                  }
                                ];
        _progressView.filterParameters = parameters;
        [_progressView setFilters:@[blurFilter]];
    } else if (_filterControl.selectedSegmentIndex == 1) {
        //Light Tunnel filter
        CIFilter *lightTunnelFilter = [CIFilter filterWithName:@"CILightTunnel"];
        [lightTunnelFilter setDefaults];
        //Get center
        UIImage *image = [UIImage imageNamed:@"Striped_apple_logo.png"];
        CIVector *center = [CIVector vectorWithCGPoint:CGPointMake(image.size.width / 2.0, image.size.height / 2.0)];
        [lightTunnelFilter setValue:center forKey:@"inputCenter"];
        //Set properties
        NSArray *parameters = @[
                                @{ @"inputRotation" :
                                      @{kM13ProgressViewFilteredImageCIFilterStartValuesKey : @10.0, kM13ProgressViewFilteredImageCIFilterEndValuesKey : @0.0
                                        }
                                  , @"inputRadius" :
                                      @{kM13ProgressViewFilteredImageCIFilterStartValuesKey : @20.0, kM13ProgressViewFilteredImageCIFilterEndValuesKey : @0.0
                                        }
                                   }
                                ];
        _progressView.filterParameters = parameters;
        [_progressView setFilters:@[lightTunnelFilter]];
    }
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
    [_progressView performAction:M13ProgressViewActionNone animated:YES];
    [_progressView setProgress:0 animated:YES];
    //Enable other controls
    _progressSlider.enabled = YES;
}

@end
