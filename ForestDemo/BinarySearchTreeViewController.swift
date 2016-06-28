//
//  BinarySearchTreeViewController.swift
//  Forest
//
//  Created by Vincent Esche on 8/2/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

import UIKit

import Forest

class BinarySearchTreeViewController<T: MutableBinarySearchTreeType where T.Element == Int>: UITableViewController {
	
	typealias Tree = T
	
	@IBOutlet var headerView: UIView!
	@IBOutlet var benchmarkButton: UIButton!
	
	let benchmarks = [
		BinarySearchTreeBenchmark(title: "Sorted Sequence", partials: ["Initialize", "Insert", "Search", "Remove"]),
		BinarySearchTreeBenchmark(title: "Random Sequence", partials: ["Initialize", "Insert", "Search", "Remove"])
	]
	
	let queue = NSOperationQueue()
	
	convenience init() {
		self.init(nibName: nil, bundle: nil)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: "BinarySearchTreeViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
	    super.init(coder: coder)
	}

	@IBAction func startBenchmarks(sender: UIButton) {
		dispatch_async(dispatch_get_main_queue()) {
			self.benchmarkButton.enabled = false
		}
		var previousOperation: NSBlockOperation?
		for (section, benchmark) in self.benchmarks.enumerate() {
			let labels = (0..<benchmark.partials.count).map { (index: Int) -> UILabel in
				let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: section))!
				return cell.detailTextLabel!
			}
			let operation = NSBlockOperation() {
				let tree = Tree()
				let total = 100_000
				let delegate = BinarySearchTreeBenchmarkDelegate(labels: labels)
				if section == 0 {
					benchmark.run(tree, total: total, source: BinarySearchTreeSortedSource(), delegate: delegate)
				} else {
					benchmark.run(tree, total: total, source: BinarySearchTreeRandomSource(), delegate: delegate)
				}
			}
			if let dependency = previousOperation {
				operation.addDependency(dependency)
			}
			previousOperation = operation
			self.queue.addOperation(operation)
		}
		let operation = NSBlockOperation() {
			dispatch_async(dispatch_get_main_queue()) {
				self.benchmarkButton.enabled = true
			}
		}
		if let dependency = previousOperation {
			operation.addDependency(dependency)
		}
		self.queue.addOperation(operation)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.tableView.tableHeaderView = self.headerView
		
		self.tableView.registerNib(UINib(nibName: "BenchmarkCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
 
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.benchmarks.count
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.benchmarks[section].partials.count
	}

	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let benchmarkSection = self.benchmarks[section]
		return benchmarkSection.title
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
		
		let benchmark = self.benchmarks[indexPath.section]
		let partial = benchmark.partials[indexPath.row]
		
		cell.textLabel?.text = partial
		cell.detailTextLabel?.text = "0"
		return cell
	}
	
	override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}
}