//
//  MasterViewController.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 11/25/15.
//  Copyright © 2015 Marxon13. All rights reserved.
//

import UIKit

/// An object that represents an example that the user can display.
struct ProgressExample {
    /// The title of the example.
    let title: String
    /// The identifier of the example view controller.
    let viewControllerIdentifier: String
}

/// An object that represents a group of examples that the user can display.
struct ProgressExampleGroup {
    /// The title of the group.
    let title: String
    /// The examples contained within the section.
    let examples: [ProgressExample]
}

/// The view controller that presents the menu allowing one to select a progress example.
class MasterViewController: UITableViewController {
    
    //-----------------------------
    // MARK: - Properties
    //-----------------------------
    
    /// The currently presented detail view controller.
    var detailViewController: DetailViewController? = nil
    
    /// The list of possible examples.
    var exampleGroups: [ProgressExampleGroup] = [
        ProgressExampleGroup(title: "Progress Bars", examples: [
            ProgressExample(title: "Basic Progress Bar", viewControllerIdentifier: "basicBarViewController"),
            ProgressExample(title: "Bordered Progress Bar", viewControllerIdentifier: "borderedBarViewController")
            ]),
        ProgressExampleGroup(title: "Circular Progress Indicators", examples: [
            ProgressExample(title: "Pie", viewControllerIdentifier: "pieViewController"),
            ProgressExample(title: "Ring", viewControllerIdentifier: "ringViewController"),
            ProgressExample(title: "Segmented Ring", viewControllerIdentifier: "segmentedRingViewController")
            ]),
        ProgressExampleGroup(title: "Image Based Progress Indicators", examples: [
            ProgressExample(title: "Greyscale Image", viewControllerIdentifier: "greyscaleImageViewController"),
            ProgressExample(title: "Filtered Image", viewControllerIdentifier: "filteredImageViewController")
            ])
    ]
    
    var objects = [AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Segue to update the detail view controller.
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // Get the example.
                let example = exampleGroups[indexPath.section].examples[indexPath.row]
                let exampleViewController = UIStoryboard(name: "Examples", bundle: nil).instantiateViewControllerWithIdentifier(example.viewControllerIdentifier)
                
                // Set it to the detail controller.
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailViewController = exampleViewController
                controller.title = example.title
                
                // Update the navigation items.
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return exampleGroups.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleGroups[section].examples.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return exampleGroups[section].title
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let example = exampleGroups[indexPath.section].examples[indexPath.row]
        cell.textLabel!.text = example.title
        
        return cell
    }
    
}

