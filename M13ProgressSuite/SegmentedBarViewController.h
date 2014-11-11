//
//  SegmentedBarViewController.h
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "M13ProgressViewSegmentedBar.h"

@interface SegmentedBarViewController : UIViewController

@property (nonatomic, retain) IBOutlet M13ProgressViewSegmentedBar *progressViewVertical;
@property (nonatomic, retain) IBOutlet M13ProgressViewSegmentedBar *progressViewHorizontal;
@property (nonatomic, retain) IBOutlet UISlider *progressSlider;
@property (nonatomic, retain) IBOutlet UIButton *animateButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *iconControl;
@property (nonatomic, retain) IBOutlet UISwitch *indeterminateSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *colorizeSwitch;
@property (nonatomic, retain) IBOutlet UISegmentedControl *directionControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *shapeControl;

- (IBAction)animateProgress:(id)sender;
- (IBAction)progressChanged:(id)sender;
- (IBAction)iconChanged:(id)sender;
- (IBAction)indeterminateChanged:(id)sender;
- (IBAction)directioChanged:(id)sender;
- (IBAction)shapeChanged:(id)sender;
- (IBAction)colorizeChanged:(id)sender;

@end
