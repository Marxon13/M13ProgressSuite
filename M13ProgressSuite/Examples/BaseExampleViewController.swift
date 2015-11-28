//
//  BaseExampleViewController.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 11/25/15.
//  Copyright © 2015 Marxon13. All rights reserved.
//

import UIKit

/**
 Runs the given closure after a delay.
 
 - parameter delay: The amount of time in seconds before the closure is run.
 - parameter closure: The closure to run after the delay.
 */
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

/// The base view controller for example view controllers.
class BaseExampleViewController: UIViewController {
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /// The button that will start a progress animation.
    @IBOutlet var progressButton: UIButton?
    
    /// The slider that allows the user to control the progress manually.
    @IBOutlet var progressSlider: UISlider?
    
    /// The switch that allows the user to switch the progress view between a determinate and indeterminate state.
    @IBOutlet var indeterminateSwitch: UISwitch?
    
    /// The segmented control that allows the user to switch between the different possible states.
    @IBOutlet var stateControl: UISegmentedControl?
    
    /// Returns the progress views controlled by the view controller.
    var progressViews: [M13ProgressView] {
        return []
    }
    
    //-------------------------------
    // MARK: Initalization
    //-------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //-------------------------------
    // MARK: Actions
    //-------------------------------
    
    /**
    The action that will run the progress animation for the progress views. This should be overriden and `animateProgressForProgressViews:completion:` should be called.
    - parameter sender: The button that called the action.
    */
    @IBAction func beginProgressAnimation(sender: UIButton) {
        animateProgress({})
    }
    
    /**
    The action that will update the progress of the progress views.
    - parameter sender: The slider whose value has changed.
    */
    @IBAction func updateProgress(sender: UISlider) {
        for progressView in progressViews {
            progressView.setProgress(CGFloat(sender.value), animated: false)
        }
    }
    
    /**
    The action that will update the indeterminate state of the progress views.
     - parameter sender: The switch whose value has changed.
    */
    @IBAction func updateIndeterminate(sender: UISwitch) {
        for progressView in progressViews {
            progressView.indeterminate = sender.on
        }
    }
    
    /**
    The action that will update the state of the progress views.
    - parameter sender: The switch whose value has changed.
    */
    @IBAction func updateState(sender: UISegmentedControl) {
        var state: M13ProgressViewState = .Normal
        if sender.selectedSegmentIndex == 1 {
            state = .Success
        } else if sender.selectedSegmentIndex == 2 {
            state = .Failure
        }
        
        for progressView in progressViews {
            progressView.setState(state, animated: true)
        }
    }
     
    //-------------------------------
    // MARK: Animations
    //-------------------------------
    
    /**
    Animates the progress of the progress views passed into the function. Once the animation completes, the completion block will be run.
    - parameter completion: The block of code to run on completion.
    - note: The completion block should be used to enable any controls that were disabled before the animation.
    */
    func animateProgress(completion:()->()) {
        
        // Disable controls for the duration of the animation.
        progressButton?.enabled = false
        progressSlider?.enabled = false
        indeterminateSwitch?.enabled = false
        stateControl?.enabled = false
        
        // Set the initial progress to zero
        for progressView in progressViews {
            progressView.setProgress(0.0, animated: false)
        }
        
        // Weak self to prevent retain loop.
        weak var weakSelf: BaseExampleViewController? = self
        let shownProgressViews: [M13ProgressView] = progressViews
        delay(1.0) { () -> () in
            for progressView in shownProgressViews {
                progressView.setProgress(0.3, animated: true)
            }
            delay(2.0, closure: { () -> () in
                for progressView in shownProgressViews {
                    progressView.setProgress(0.5, animated: true)
                }
                delay(3.0, closure: { () -> () in
                    for progressView in shownProgressViews {
                        progressView.setProgress(1.0, animated: true)
                    }
                    if let aProgressView = shownProgressViews.first {
                        delay(aProgressView.animationDuration, closure: { () -> () in
                            for progressView in shownProgressViews {
                                progressView.setState(.Success, animated: true)
                            }
                            delay(2.0, closure: { () -> () in
                                if let retainedSelf = weakSelf {
                                    for progressView in shownProgressViews {
                                        progressView.setState(.Normal, animated: true)
                                        progressView.setProgress(CGFloat(retainedSelf.progressSlider!.value), animated: true)
                                    }
                                    
                                    retainedSelf.progressButton?.enabled = true
                                    retainedSelf.progressSlider?.enabled = true
                                    retainedSelf.indeterminateSwitch?.enabled = true
                                    retainedSelf.stateControl?.enabled = true
                                    completion()
                                }
                            })
                        })
                    }
                })
            })
        }
    }
}
