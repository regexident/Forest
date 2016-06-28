//
//  MasterViewController.swift
//  ForestDemo
//
//  Created by Vincent Esche on 8/2/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

import UIKit

import Forest

struct TreeDemoSection {
	let title: String
	let demos: [TreeDemo]
}

class MasterViewController: UITableViewController {
	
	var detailViewController: DetailViewController? = nil
	let treeDemoSections: [TreeDemoSection] = [
		TreeDemoSection(title: "Binary Search Trees", demos: [
			TreeDemo(title: "AVLTree", viewController: BinarySearchTreeViewController<AVLTree<Int>>()),
			TreeDemo(title: "RBTree", viewController: BinarySearchTreeViewController<RBTree<Int>>())
		]),
	]

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

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = self.tableView.indexPathForSelectedRow {
				let treeDemoSection = self.treeDemoSections[indexPath.section]
				let treeDemo = treeDemoSection.demos[indexPath.row]
		        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
		        controller.detailItem = treeDemo
		        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}
}

extension MasterViewController {
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.treeDemoSections.count
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.treeDemoSections[section].demos.count
	}
}

extension MasterViewController {
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let treeDemoSection = self.treeDemoSections[section]
		return treeDemoSection.title
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

		let treeDemoSection = self.treeDemoSections[indexPath.section]
		let treeDemo = treeDemoSection.demos[indexPath.row]
		
		cell.separatorInset = UIEdgeInsetsZero
		cell.textLabel!.text = treeDemo.title
		return cell
	}
}
