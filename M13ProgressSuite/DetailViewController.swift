//
//  DetailViewController.swift
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 9/9/15.
//  Copyright © 2015 Brandon McQuilkin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var detailItem: UIViewController? {
        willSet {
            if let item = detailItem {
                item.willMoveToParentViewController(nil)
                item.view.removeFromSuperview()
                item.removeFromParentViewController()
            }
        }
        didSet {
            if let item = detailItem {
                addChildViewController(item)
                item.view.frame = CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height)
                view.addSubview(item.view)
                item.didMoveToParentViewController(self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let item = detailItem {
            item.view.frame = CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height)
        }
    }
}

