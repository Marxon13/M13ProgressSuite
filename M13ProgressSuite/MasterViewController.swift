//
//  MasterViewController.swift
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 9/9/15.
//  Copyright © 2015 Brandon McQuilkin. All rights reserved.
//

import UIKit

struct ProgressSection {
    var sectionTitle: String
    var progressCells: [ProgressCell]
}

struct ProgressCell {
    var cellTitle: String
    var cellDetail: String?
    var representedViewControllerIdentifier: String
}

class MasterViewController: UITableViewController {
    
    var examples: [ProgressSection] = [
        ProgressSection(sectionTitle: "Progress Bars", progressCells: [
            ProgressCell(cellTitle: "Basic Bar", cellDetail: "(UIProgressBar)", representedViewControllerIdentifier: "BasicBarExample"),
            ProgressCell(cellTitle: "Bordered Bar", cellDetail: nil, representedViewControllerIdentifier: "BorderedBarExample"),
            ProgressCell(cellTitle: "Segmented Bar", cellDetail: nil, representedViewControllerIdentifier: "SegmentedBarExample"),
            ProgressCell(cellTitle: "Striped Bar", cellDetail: nil, representedViewControllerIdentifier: "StripedBarExample"),
            ]),
        ProgressSection(sectionTitle: "Circular Progress Indicators", progressCells: [
            ProgressCell(cellTitle: "Pie", cellDetail: nil, representedViewControllerIdentifier: "CircularPieExample"),
            ProgressCell(cellTitle: "Ring", cellDetail: nil, representedViewControllerIdentifier: "CircularRingExample"),
            ProgressCell(cellTitle: "Segmented Ring", cellDetail: nil, representedViewControllerIdentifier: "Segmented Ring Example")
            ]),
        ProgressSection(sectionTitle: "Image Based Progress Bars", progressCells: [
            ProgressCell(cellTitle: "Filtered Image", cellDetail: "(CIFilters)", representedViewControllerIdentifier: "FilteredImageExample"),
            ProgressCell(cellTitle: "Greyscale Image", cellDetail: nil, representedViewControllerIdentifier: "GreyscaleImageExample")
            ]),
        ProgressSection(sectionTitle: "Additions", progressCells: [
            ProgressCell(cellTitle: "External Percentage Text", cellDetail: "(Any Progress View)", representedViewControllerIdentifier: "ExternalPercentageTextExample"),
            ]),
        ProgressSection(sectionTitle: "UINavigationBar", progressCells: [
            ProgressCell(cellTitle: "Progress Bar", cellDetail: "Like: Messages / Safari / News", representedViewControllerIdentifier: "UINavigationBarProgressBarExample")
            ]),
        ProgressSection(sectionTitle: "HUD", progressCells: [
            ProgressCell(cellTitle: "Basic HUD", cellDetail: nil, representedViewControllerIdentifier: "BasicHUDExample")
            ])
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return examples.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples[section].progressCells.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return examples[section].sectionTitle
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = examples[indexPath.section].progressCells[indexPath.row].cellTitle
        
        if let detail: String = examples[indexPath.section].progressCells[indexPath.row].cellDetail {
            cell.detailTextLabel?.text = detail
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewControllerIdentifier: String = examples[indexPath.section].progressCells[indexPath.row].representedViewControllerIdentifier
        
        if let viewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier(viewControllerIdentifier) {
            // Override point for customization after application launch.
            let window = (UIApplication.sharedApplication().delegate as! AppDelegate).window!
            let splitViewController = window.rootViewController as! UISplitViewController
            let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
            let detailController = navigationController.topViewController as! DetailViewController
            detailController.detailItem = viewController
            navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        }
    }
    
    
}

