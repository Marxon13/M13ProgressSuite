//
//  MetroViewController.h
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 3/8/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13ProgressViewMetro.h"

@interface MetroViewController : UIViewController

@property (nonatomic, retain) IBOutlet M13ProgressViewMetro *progressView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *shapeControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *dotControl;
@property (nonatomic, retain) IBOutlet UISlider *numberOfDotsControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *iconControl;
@property (nonatomic, retain) IBOutlet UISlider *progressSlider;

- (IBAction)changeShape:(id)sender;
- (IBAction)changeDot:(id)sender;
- (IBAction)changeNumberOfDots:(id)sender;
- (IBAction)changeIcon:(id)sender;
- (IBAction)changeProgress:(id)sender;
- (IBAction)animateProgress:(id)sender;

@end
