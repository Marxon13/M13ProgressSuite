//
//  BarExampleViewController.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 11/25/15.
//  Copyright © 2015 Marxon13. All rights reserved.
//

import UIKit

class BarExampleViewController: BaseExampleViewController {
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /// The vertical progress bar.
    @IBOutlet var verticalProgressBar: M13ProgressBar?
    
    /// The horizontal progress bar.
    @IBOutlet var horizontalProgressBar: M13ProgressBar?
    
    override var progressViews: [M13ProgressView] {
        if let verticalProgressBar = verticalProgressBar, horizontalProgressBar = horizontalProgressBar {
            return [verticalProgressBar, horizontalProgressBar]
        }
        return []
    }
    
    //-------------------------------
    // MARK: Initalization
    //-------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        verticalProgressBar?.progressDirection = .BottomToTop
    }
    
    //-------------------------------
    // MARK: Actions
    //-------------------------------
    
    /**
    Updates the corner radius of the progress views.
    - parameter sender: The slider that updated its value.
    */
    @IBAction func updateCornerRadius(sender: UISlider) {
        horizontalProgressBar?.cornerRadius = CGFloat(sender.value)
        verticalProgressBar?.cornerRadius = CGFloat(sender.value)
    }
    
    /**
    Updates the direction of the progress views.
    */
    @IBAction func updateProgressDirection(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            horizontalProgressBar?.progressDirection = .LeadingToTrailing
            verticalProgressBar?.progressDirection = .BottomToTop
        } else if sender.selectedSegmentIndex == 1 {
            horizontalProgressBar?.progressDirection = .TrailingToLeading
            verticalProgressBar?.progressDirection = .TopToBottom
        }
    }

}
