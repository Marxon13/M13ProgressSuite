//
//  RadiativeViewController.h
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 3/13/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13ProgressViewRadiative.h"

@interface RadiativeViewController : UIViewController

@property (nonatomic, retain) IBOutlet M13ProgressViewRadiative *progressView;
@property (nonatomic, retain) IBOutlet UISlider *progressSlider;
@property (nonatomic, retain) IBOutlet UIButton *animateButton;
@property (nonatomic, retain) IBOutlet UISwitch *indeterminateSwitch;
@property (nonatomic, retain) IBOutlet UISegmentedControl *shapeControl;
@property (nonatomic, retain) IBOutlet UISlider *numberOfRipplesSlider;
@property (nonatomic, retain) IBOutlet UISwitch *outwardSwitch;

- (IBAction)animateProgress:(id)sender;
- (IBAction)progressChanged:(id)sender;
- (IBAction)indeterminateChanged:(id)sender;
- (IBAction)shapeChanged:(id)sender;
- (IBAction)numberOfRipplesChanged:(id)sender;
- (IBAction)directionChanged:(id)sender;


@end
