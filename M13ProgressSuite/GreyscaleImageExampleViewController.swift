//
//  GreyscaleImageExampleViewController.swift
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 9/13/15.
//  Copyright © 2015 Brandon McQuilkin. All rights reserved.
//

import UIKit

class GreyscaleImageExampleViewController: UIViewController {
    
    @IBOutlet var imageProgressView: M13ProgressImage?
    
    @IBOutlet var progressButton: UIButton?
    @IBOutlet var progressSlider: UISlider?
    @IBOutlet var directionControl: UISegmentedControl!
    @IBOutlet var showBackgroundSwitch: UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let progress = imageProgressView?.progress {
            progressSlider?.setValue(Float(progress), animated: false)
        }
        if let bg = imageProgressView?.drawGreyscaleBackground {
            showBackgroundSwitch?.on = bg
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func animateProgress(sender: UIButton) {
        imageProgressView?.setProgress(0.0, animated: false)
        
        progressButton?.enabled = false
        progressSlider?.enabled = false
        directionControl?.enabled = false
        showBackgroundSwitch?.enabled = false
        
        // Start with a sliver
        imageProgressView?.setProgress(0.10, animated: false)
        
        // Increment the progress over a few seconds
        let demoIncrementSeconds :NSTimeInterval = 1.0
        weak var weakSelf: GreyscaleImageExampleViewController? = self
        delay(demoIncrementSeconds) { () -> () in
            if let retainedSelf = weakSelf {
                retainedSelf.imageProgressView?.setProgress(0.3, animated: true)
                delay(demoIncrementSeconds, closure: { () -> () in
                    if let retainedSelf = weakSelf {
                        retainedSelf.imageProgressView?.setProgress(0.5, animated: true)
                        delay(demoIncrementSeconds, closure: { () -> () in
                            if let retainedSelf = weakSelf {
                                retainedSelf.imageProgressView?.setProgress(1.0, animated: true)
                                delay(retainedSelf.imageProgressView!.animationDuration, closure: { () -> () in
                                    if let retainedSelf = weakSelf {
                                        retainedSelf.imageProgressView?.setState(.Success, animated: true)
                                        delay(demoIncrementSeconds, closure: { () -> () in
                                            if let retainedSelf = weakSelf {
                                                retainedSelf.imageProgressView?.setProgress(CGFloat(retainedSelf.progressSlider!.value), animated: true)
                                                retainedSelf.imageProgressView?.setState(.Normal, animated: true)
                                                
                                                retainedSelf.progressButton?.enabled = true
                                                retainedSelf.progressSlider?.enabled = true
                                                retainedSelf.directionControl?.enabled = true
                                                retainedSelf.showBackgroundSwitch?.enabled = true
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
        imageProgressView?.setProgress(CGFloat(sender.value), animated: false)
    }
    
    @IBAction func updateDirection(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            imageProgressView?.progressDirection = .LeadingToTrailing
        } else if sender.selectedSegmentIndex == 1 {
            imageProgressView?.progressDirection = .BottomToTop
        } else if sender.selectedSegmentIndex == 2 {
            imageProgressView?.progressDirection = .TrailingToLeading
        } else if sender.selectedSegmentIndex == 3 {
            imageProgressView?.progressDirection = .TopToBottom
        }
    }
    
    @IBAction func updateBackgroundSwitch(sender: UISwitch) {
        imageProgressView?.drawGreyscaleBackground = sender.on
    }
    
}
