//
//  CircularRingExampleViewController.swift
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 9/13/15.
//  Copyright © 2015 Brandon McQuilkin. All rights reserved.
//

import UIKit

class CircularRingExampleViewController: UIViewController {
    
    @IBOutlet var ringProgressView: M13ProgressRing?
    
    @IBOutlet var progressButton: UIButton?
    @IBOutlet var progressSlider: UISlider?
    @IBOutlet var indeterminateSwitch: UISwitch?
    @IBOutlet var showPercentageSwitch: UISwitch?
    @IBOutlet var stateControl: UISegmentedControl?
    @IBOutlet var directionControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let progress = ringProgressView?.progress {
            progressSlider?.setValue(Float(progress), animated: false)
        }
        if let status = ringProgressView?.percentage {
            showPercentageSwitch?.setOn(status, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func animateProgress(sender: UIButton) {
        ringProgressView?.setProgress(0.0, animated: false)
        
        progressButton?.enabled = false
        progressSlider?.enabled = false
        indeterminateSwitch?.enabled = false
        showPercentageSwitch?.enabled = false
        stateControl?.enabled = false
        directionControl?.enabled = false
        
        // Start with a sliver
        ringProgressView?.setProgress(0.01, animated: false)
        
        // Increment the progress over a few seconds
        let demoIncrementSeconds :NSTimeInterval = 1.0
        weak var weakSelf: CircularRingExampleViewController? = self
        delay(demoIncrementSeconds) { () -> () in
            if let retainedSelf = weakSelf {
                retainedSelf.ringProgressView?.setProgress(0.3, animated: true)
                delay(demoIncrementSeconds, closure: { () -> () in
                    if let retainedSelf = weakSelf {
                        retainedSelf.ringProgressView?.setProgress(0.5, animated: true)
                        delay(demoIncrementSeconds, closure: { () -> () in
                            if let retainedSelf = weakSelf {
                                retainedSelf.ringProgressView?.setProgress(1.0, animated: true)
                                delay(retainedSelf.ringProgressView!.animationDuration, closure: { () -> () in
                                    if let retainedSelf = weakSelf {
                                        retainedSelf.ringProgressView?.setState(.Success, animated: true)
                                        delay(demoIncrementSeconds, closure: { () -> () in
                                            if let retainedSelf = weakSelf {
                                                retainedSelf.ringProgressView?.setProgress(CGFloat(retainedSelf.progressSlider!.value), animated: true)
                                                retainedSelf.ringProgressView?.setState(.Normal, animated: true)
                                                
                                                retainedSelf.progressButton?.enabled = true
                                                retainedSelf.progressSlider?.enabled = true
                                                retainedSelf.indeterminateSwitch?.enabled = true
                                                retainedSelf.showPercentageSwitch?.enabled = true
                                                retainedSelf.stateControl?.enabled = true
                                                retainedSelf.directionControl?.enabled = true
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
        ringProgressView?.setProgress(CGFloat(sender.value), animated: false)
    }
    
    @IBAction func updateIndeterminate(sender: UISwitch) {
        ringProgressView?.indeterminate = sender.on
    }
    
    @IBAction func updatePercentage(sender: UISwitch) {
        ringProgressView?.percentage = sender.on
    }
    
    @IBAction func updateState(sender: UISegmentedControl) {
        var state: M13ProgressViewState = .Normal
        if sender.selectedSegmentIndex == 1 {
            state = .Success
        } else if sender.selectedSegmentIndex == 2 {
            state = .Failure
        }
        ringProgressView?.setState(state, animated: true)
    }
    
    @IBAction func updateDirection(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            ringProgressView?.progressDirection = .Clockwise
        } else if sender.selectedSegmentIndex == 1 {
            ringProgressView?.progressDirection = .CounterClockwise
        }
    }
    
}
