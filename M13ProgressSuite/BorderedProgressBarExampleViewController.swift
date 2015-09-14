//
//  BorderedProgressBarExampleViewController.swift
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 9/13/15.
//  Copyright © 2015 Brandon McQuilkin. All rights reserved.
//

import UIKit

class BorderedProgressBarExampleViewController: UIViewController {

    @IBOutlet var horizontalProgressView: M13BorderedProgressBar?
    @IBOutlet var verticalProgressView: M13BorderedProgressBar?
    
    @IBOutlet var progressButton: UIButton?
    @IBOutlet var progressSlider: UISlider?
    @IBOutlet var indeterminateSwitch: UISwitch?
    @IBOutlet var stateControl: UISegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        verticalProgressView?.progressDirection = M13ProgressBarProgressDirection.BottomToTop
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func animateProgress(sender: UIButton) {
        horizontalProgressView?.setProgress(0.0, animated: false)
        //verticalProgressView?.setProgress(0.0, animated: false)
        
        progressButton?.enabled = false
        progressSlider?.enabled = false
        indeterminateSwitch?.enabled = false
        stateControl?.enabled = false
        
        weak var weakSelf: BorderedProgressBarExampleViewController? = self
        delay(1.0) { () -> () in
            if let retainedSelf = weakSelf {
                retainedSelf.horizontalProgressView?.setProgress(0.3, animated: true)
                retainedSelf.verticalProgressView?.setProgress(0.3, animated: true)
                delay(2.0, closure: { () -> () in
                    if let retainedSelf = weakSelf {
                        retainedSelf.horizontalProgressView?.setProgress(0.5, animated: true)
                        retainedSelf.verticalProgressView?.setProgress(0.5, animated: true)
                        delay(3.0, closure: { () -> () in
                            if let retainedSelf = weakSelf {
                                retainedSelf.horizontalProgressView?.setProgress(1.0, animated: true)
                                retainedSelf.verticalProgressView?.setProgress(1.0, animated: true)
                                delay(retainedSelf.horizontalProgressView!.animationDuration, closure: { () -> () in
                                    if let retainedSelf = weakSelf {
                                        retainedSelf.horizontalProgressView?.setState(M13ProgressViewState.Success, animated: true)
                                        retainedSelf.verticalProgressView?.setState(M13ProgressViewState.Success, animated: true)
                                        delay(2.0, closure: { () -> () in
                                            if let retainedSelf = weakSelf {
                                                retainedSelf.horizontalProgressView?.setProgress(CGFloat(retainedSelf.progressSlider!.value), animated: true)
                                                retainedSelf.verticalProgressView?.setProgress(CGFloat(retainedSelf.progressSlider!.value), animated: true)
                                                retainedSelf.horizontalProgressView?.setState(M13ProgressViewState.Normal, animated: true)
                                                retainedSelf.verticalProgressView?.setState(M13ProgressViewState.Normal, animated: true)
                                                
                                                retainedSelf.progressButton?.enabled = true
                                                retainedSelf.progressSlider?.enabled = true
                                                retainedSelf.indeterminateSwitch?.enabled = true
                                                retainedSelf.stateControl?.enabled = true
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
        horizontalProgressView?.setProgress(CGFloat(sender.value), animated: false)
        verticalProgressView?.setProgress(CGFloat(sender.value), animated: false)
    }
    
    @IBAction func updateIndeterminate(sender: UISwitch) {
        horizontalProgressView?.indeterminate = sender.on
        verticalProgressView?.indeterminate = sender.on
    }
    
    @IBAction func updateState(sender: UISegmentedControl) {
        var state: M13ProgressViewState = M13ProgressViewState.Normal
        if sender.selectedSegmentIndex == 1 {
            state = M13ProgressViewState.Success
        } else if sender.selectedSegmentIndex == 2 {
            state = M13ProgressViewState.Failure
        }
        
        horizontalProgressView?.setState(state, animated: true)
        verticalProgressView?.setState(state, animated: true)
    }
    
    @IBAction func updateCornerRadius(sender: UISlider) {
        horizontalProgressView?.cornerRadius = CGFloat(sender.value)
        verticalProgressView?.cornerRadius = CGFloat(sender.value)
    }
    
    @IBAction func updateDirection(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            horizontalProgressView?.progressDirection = M13ProgressBarProgressDirection.LeadingToTrailing
            verticalProgressView?.progressDirection = M13ProgressBarProgressDirection.BottomToTop
        } else if sender.selectedSegmentIndex == 1 {
            horizontalProgressView?.progressDirection = M13ProgressBarProgressDirection.TrailingToLeading
            verticalProgressView?.progressDirection = M13ProgressBarProgressDirection.TopToBottom
        }
    }


}
