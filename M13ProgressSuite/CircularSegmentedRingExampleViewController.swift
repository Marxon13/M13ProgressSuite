//
//  CircularSegmentedRingExampleViewController.swift
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 9/13/15.
//  Copyright © 2015 Brandon McQuilkin. All rights reserved.
//

import UIKit

class CircularSegmentedRingExampleViewController: UIViewController {
    
    @IBOutlet var segmentedRingProgressView: M13ProgressSegmentedRing?
    
    @IBOutlet var progressButton: UIButton?
    @IBOutlet var progressSlider: UISlider?
    @IBOutlet var indeterminateSwitch: UISwitch?
    @IBOutlet var showPercentageSwitch: UISwitch?
    @IBOutlet var stateControl: UISegmentedControl?
    @IBOutlet var segmentBoundaryControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let progress = segmentedRingProgressView?.progress {
            progressSlider?.setValue(Float(progress), animated: false)
        }
        if let status = segmentedRingProgressView?.percentage {
            showPercentageSwitch?.setOn(status, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func animateProgress(sender: UIButton) {
        segmentedRingProgressView?.setProgress(0.0, animated: false)
        
        progressButton?.enabled = false
        progressSlider?.enabled = false
        indeterminateSwitch?.enabled = false
        showPercentageSwitch?.enabled = false
        stateControl?.enabled = false
        segmentBoundaryControl?.enabled = false
        
        // Start with a sliver
        segmentedRingProgressView?.setProgress(0.10, animated: false)
        
        // Increment the progress over a few seconds
        let demoIncrementSeconds :NSTimeInterval = 1.0
        weak var weakSelf: CircularSegmentedRingExampleViewController? = self
        delay(demoIncrementSeconds) { () -> () in
            if let retainedSelf = weakSelf {
                retainedSelf.segmentedRingProgressView?.setProgress(0.3, animated: true)
                delay(demoIncrementSeconds, closure: { () -> () in
                    if let retainedSelf = weakSelf {
                        retainedSelf.segmentedRingProgressView?.setProgress(0.5, animated: true)
                        delay(demoIncrementSeconds, closure: { () -> () in
                            if let retainedSelf = weakSelf {
                                retainedSelf.segmentedRingProgressView?.setProgress(1.0, animated: true)
                                delay(retainedSelf.segmentedRingProgressView!.animationDuration, closure: { () -> () in
                                    if let retainedSelf = weakSelf {
                                        retainedSelf.segmentedRingProgressView?.setState(.Success, animated: true)
                                        delay(demoIncrementSeconds, closure: { () -> () in
                                            if let retainedSelf = weakSelf {
                                                retainedSelf.segmentedRingProgressView?.setProgress(CGFloat(retainedSelf.progressSlider!.value), animated: true)
                                                retainedSelf.segmentedRingProgressView?.setState(.Normal, animated: true)
                                                
                                                retainedSelf.progressButton?.enabled = true
                                                retainedSelf.progressSlider?.enabled = true
                                                retainedSelf.indeterminateSwitch?.enabled = true
                                                retainedSelf.showPercentageSwitch?.enabled = true
                                                retainedSelf.stateControl?.enabled = true
                                                retainedSelf.segmentBoundaryControl?.enabled = true
                                            }
                                        })
                                    }
                                })
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func updateProgress(sender: UISlider) {
        segmentedRingProgressView?.setProgress(CGFloat(sender.value), animated: false)
    }
    
    @IBAction func updateIndeterminate(sender: UISwitch) {
        segmentedRingProgressView?.indeterminate = sender.on
    }
    
    @IBAction func updatePercentage(sender: UISwitch) {
        segmentedRingProgressView?.percentage = sender.on
    }
    
    @IBAction func updateState(sender: UISegmentedControl) {
        var state: M13ProgressViewState = .Normal
        if sender.selectedSegmentIndex == 1 {
            state = .Success
        } else if sender.selectedSegmentIndex == 2 {
            state = .Failure
        }
        segmentedRingProgressView?.setState(state, animated: true)
    }
    
    @IBAction func updateSegmentBoundary(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentedRingProgressView?.segmentBoundaryType = .Wedge
        } else if sender.selectedSegmentIndex == 1 {
            segmentedRingProgressView?.segmentBoundaryType = .Rectangle
        }
    }
    
}
