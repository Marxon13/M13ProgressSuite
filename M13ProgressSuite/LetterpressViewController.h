//
//  LetterpressViewController.h
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 4/28/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13ProgressViewLetterpress.h"

@interface LetterpressViewController : UIViewController

@property (nonatomic, retain) IBOutlet M13ProgressViewLetterpress *progressView;
@property (nonatomic, retain) IBOutlet UISlider *progressSlider;
@property (nonatomic, retain) IBOutlet UIButton *animateButton;

- (IBAction)animateProgress:(id)sender;
- (IBAction)progressChanged:(id)sender;
- (IBAction)gridPointsXChanged:(id)sender;
- (IBAction)gridPointsYChanged:(id)sender;
- (IBAction)pointShapeChanged:(id)sender;
- (IBAction)notchSizeXChanged:(id)sender;
- (IBAction)notchSizeYChanged:(id)sender;

@end
