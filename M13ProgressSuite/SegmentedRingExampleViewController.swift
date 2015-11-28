//
//  SegmentedRingExampleViewController.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 11/27/15.
//  Copyright © 2015 Marxon13. All rights reserved.
//

import UIKit

class SegmentedRingExampleViewController: BaseExampleViewController {
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /// The progress view.
    @IBOutlet var segmentedRingProgressView: M13ProgressSegmentedRing?
    
    /// The switch to control whether or not the percentage is shown.
    @IBOutlet var showPercentageSwitch: UISwitch?
    
    /// The control to control the segment shape
    @IBOutlet var segmentBoundaryControl: UISegmentedControl?
    
    /// The control to change the direction of the progress.
    @IBOutlet var directionControl: UISegmentedControl?
    
    override var progressViews: [M13ProgressView] {
        if let ringProgressView = segmentedRingProgressView {
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
        segmentedRingProgressView?.percentage = sender.on
    }
    
    /**
     Changes the direction progress travels in.
     - parameter sender: The segmented control whose value has changed.
     */
    @IBAction func updateDirection(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentedRingProgressView?.progressDirection = .Clockwise
        } else if sender.selectedSegmentIndex == 1 {
            segmentedRingProgressView?.progressDirection = .CounterClockwise
        }
    }
    
    /**
    Updates the shape of the segment wedges.
     - parameter sender: The control whose value was updated.
    */
    @IBAction func updateSegmentBoundary(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentedRingProgressView?.segmentBoundaryType = .Wedge
        } else if sender.selectedSegmentIndex == 1 {
            segmentedRingProgressView?.segmentBoundaryType = .Rectangle
        }
    }

}
