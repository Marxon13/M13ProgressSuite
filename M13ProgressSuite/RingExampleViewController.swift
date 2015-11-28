//
//  RingExampleViewController.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 11/27/15.
//  Copyright © 2015 Marxon13. All rights reserved.
//

import UIKit

class RingExampleViewController: BaseExampleViewController {
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /// The progress view.
    @IBOutlet var ringProgressView: M13ProgressRing?
    
    /// The switch to control whether or not the percentage is shown.
    @IBOutlet var showPercentageSwitch: UISwitch?
    
    /// The control to change the direction of the progress.
    @IBOutlet var directionControl: UISegmentedControl?
    
    override var progressViews: [M13ProgressView] {
        if let ringProgressView = ringProgressView {
            return [ringProgressView]
        }
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
    Shows and hides the percentage label in the progress ring.
    - parameter sender: The switch whose value has changed.
    */
    @IBAction func updatePercentage(sender: UISwitch) {
        ringProgressView?.percentage = sender.on
    }
    
    /**
    Changes the direction progress travels in.
     - parameter sender: The segmented control whose value has changed.
    */
    @IBAction func updateDirection(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            ringProgressView?.progressDirection = .Clockwise
        } else if sender.selectedSegmentIndex == 1 {
            ringProgressView?.progressDirection = .CounterClockwise
        }
    }

}
