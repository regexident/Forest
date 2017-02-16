//
//  BinarySearchTreeViewController.swift
//  Forest
//
//  Created by Vincent Esche on 8/2/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

import UIKit

import Forest

class BinarySearchTreeViewController<T: MutableBinarySearchTreeType>: UITableViewController where T.Element == Int {
	
	typealias Tree = T
	
	@IBOutlet var headerView: UIView!
    @IBOutlet var benchmarkButton: UIButton!
	
    let benchmarks = [
        BinarySearchTreeBenchmark(
            title: "Sorted Sequence",
            partials: ["Initialize", "Insert", "Search", "Remove"]
        ),
        BinarySearchTreeBenchmark(
            title: "Random Sequence",
            partials: ["Initialize", "Insert", "Search", "Remove"]
        )
    ]
	
	let queue = OperationQueue()
	
	convenience init() {
		self.init(nibName: nil, bundle: nil)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: "BinarySearchTreeViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
	    super.init(coder: coder)
	}

	@IBAction func startBenchmarks(_ sender: UIButton) {
		DispatchQueue.main.async {
			self.benchmarkButton.isEnabled = false
		}
		var previousOperation: BlockOperation?
		for (section, benchmark) in self.benchmarks.enumerated() {
			let labels = (0..<benchmark.partials.count).map { (index: Int) -> UILabel in
				let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: section))!
				return cell.detailTextLabel!
			}
			let operation = BlockOperation() {
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
		let operation = BlockOperation() {
			DispatchQueue.main.async {
				self.benchmarkButton.isEnabled = true
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
		
		self.tableView.register(UINib(nibName: "BenchmarkCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
 
	override func numberOfSections(in tableView: UITableView) -> Int {
		return self.benchmarks.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.benchmarks[section].partials.count
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let benchmarkSection = self.benchmarks[section]
		return benchmarkSection.title
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		let benchmark = self.benchmarks[indexPath.section]
		let partial = benchmark.partials[indexPath.row]
		
		cell.textLabel?.text = partial
		cell.detailTextLabel?.text = "0"
		return cell
	}
	
	override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return false
	}
}
