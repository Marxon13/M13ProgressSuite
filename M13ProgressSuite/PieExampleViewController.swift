//
//  PieExampleViewController.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 11/27/15.
//  Copyright © 2015 Marxon13. All rights reserved.
//

import UIKit

class PieExampleViewController: BaseExampleViewController {
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /// The progress view.
    @IBOutlet var pieProgressView: M13ProgressPie?
    
    /// The control to change the direction of the progress.
    @IBOutlet var directionControl: UISegmentedControl?

    override var progressViews: [M13ProgressView] {
        if let pieProgressView = pieProgressView {
            return [pieProgressView]
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
     Changes the direction progress travels in.
     - parameter sender: The segmented control whose value has changed.
     */
    @IBAction func updateDirection(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pieProgressView?.progressDirection = .Clockwise
        } else if sender.selectedSegmentIndex == 1 {
            pieProgressView?.progressDirection = .CounterClockwise
        }
    }
    
}
