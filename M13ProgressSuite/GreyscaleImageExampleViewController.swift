//
//  GreyscaleImageExampleViewController.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 11/28/15.
//  Copyright © 2015 Marxon13. All rights reserved.
//

import UIKit

class GreyscaleImageExampleViewController: BaseExampleViewController {

    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /// The progress view.
    @IBOutlet var greyscaleImageProgressView: M13ProgressImage?
    
    /// Changes the direction of the progress
    @IBOutlet var directionControl: UISegmentedControl?
    
    /// Shows the gresscale background
    @IBOutlet var showBackgroundSwitch: UISwitch?

    override var progressViews: [M13ProgressView] {
        if let greyscaleImageProgressView = greyscaleImageProgressView {
            return [greyscaleImageProgressView]
        }
        return []
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
            greyscaleImageProgressView?.progressDirection = .LeadingToTrailing
        } else if sender.selectedSegmentIndex == 1 {
            greyscaleImageProgressView?.progressDirection = .BottomToTop
        } else if sender.selectedSegmentIndex == 2 {
            greyscaleImageProgressView?.progressDirection = .TrailingToLeading
        } else if sender.selectedSegmentIndex == 3 {
            greyscaleImageProgressView?.progressDirection = .TopToBottom
        }
    }
    
    @IBAction func updateBackgroundSwitch(sender: UISwitch) {
        greyscaleImageProgressView?.drawGreyscaleBackground = sender.on
    }
}

