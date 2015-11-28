//
//  FilteredImageExampleViewController.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 11/28/15.
//  Copyright © 2015 Marxon13. All rights reserved.
//

import UIKit

class FilteredImageExampleViewController: BaseExampleViewController {

    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /// The progress view.
    @IBOutlet var filteredImageProgressView: M13ProgressFilteredImage?
    
    /// The control that allows the user to select a filter.
    @IBOutlet var filterControl: UISegmentedControl?
    
    override var progressViews: [M13ProgressView] {
        if let filteredImageProgressView = filteredImageProgressView {
            return [filteredImageProgressView]
        }
        return []
    }
    
    //-------------------------------
    // MARK: Actions
    //-------------------------------

    @IBAction func updateFilter(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            filteredImageProgressView?.progressFilter = .Blur
        } else if sender.selectedSegmentIndex == 1 {
            filteredImageProgressView?.progressFilter = .LightTunnel
        } else if sender.selectedSegmentIndex == 2 {
            filteredImageProgressView?.progressFilter = .SepiaTone
        }
    }

}
