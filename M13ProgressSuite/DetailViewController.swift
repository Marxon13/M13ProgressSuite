//
//  DetailViewController.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 11/25/15.
//  Copyright © 2015 Marxon13. All rights reserved.
//

import UIKit

/// The view controller that presents the progress examples.
class DetailViewController: UIViewController {
    
    //-----------------------------
    // MARK: - Properties
    //-----------------------------

    /// The scroll view that will containt the progress view examples.
    @IBOutlet weak var progressContentScrollView: UIScrollView?
    
    /// The view that is currently displayed in the content scroll view.
    var detailViewController: UIViewController? {
        willSet {
            detailViewController?.willMoveToParentViewController(nil)
            detailViewController?.view.removeFromSuperview()
            detailViewController?.removeFromParentViewController()
        }
        didSet {
            configureView()
        }
    }
    
    //-----------------------------
    // MARK: - Configuration
    //-----------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    /// Sets up the autolayout constraints for the content view.
    func configureView() {
        
        // Add the view if necessary
        if let detailViewController = detailViewController, let scrollView = progressContentScrollView where detailViewController.view.superview == nil {
            addChildViewController(detailViewController)
            detailViewController.view.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(detailViewController.view)
            detailViewController.didMoveToParentViewController(self)
        }
        
        // Setup the constraints
        if let detail = detailViewController?.view, let scrollView = progressContentScrollView {
            // Create the constraints between the content view and the scroll view.
            detail.leadingAnchor.constraintEqualToAnchor(scrollView.leadingAnchor).active = true
            detail.trailingAnchor.constraintEqualToAnchor(scrollView.trailingAnchor).active = true
            detail.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
            detail.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor).active = true
            // Create the constraints between the content view and the main view.
            detail.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
            detail.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
            detail.bottomAnchor.constraintGreaterThanOrEqualToAnchor(view.bottomAnchor).active = true
        }
    }
    
}

