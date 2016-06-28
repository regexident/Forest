//
//  BinarySearchTreeBenchmark.swift
//  Forest
//
//  Created by Vincent Esche on 8/2/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

import UIKit

import Forest

protocol BinarySearchTreeBenchmarkSource {
	mutating func next() -> Int
	var isSorted: Bool { get }
}

struct BinarySearchTreeSortedSource: BinarySearchTreeBenchmarkSource {
	var current: Int = 0
	mutating func next() -> Int {
        self.current += 1
		return self.current
	}
	var isSorted: Bool {
		return true
	}
}

struct BinarySearchTreeRandomSource: BinarySearchTreeBenchmarkSource {
	mutating func next() -> Int {
		return Int(arc4random())
	}
	var isSorted: Bool {
		return false
	}
}

struct BinarySearchTreeBenchmarkDelegate {
	let labels: [UILabel]
	func update(partial: Int, string: String) {
		dispatch_async(dispatch_get_main_queue()) {
			self.labels[partial].text = string
		}
	}
	func progress(partial: Int, current: Int, total: Int) {
		dispatch_async(dispatch_get_main_queue()) {
			self.labels[partial].text = "\(current) / \(total)"
		}
	}
	func done(partial: Int, total: Int, seconds: NSTimeInterval) {
		dispatch_async(dispatch_get_main_queue()) {
			self.labels[partial].text = String(format: "%d in %.2f seconds", total, seconds)
		}
	}
}

protocol BinarySearchTreeBenchmarkType {
	func run(total: Int, delegate: BinarySearchTreeBenchmarkDelegate)
}

struct BinarySearchTreeBenchmark {
	let title: String
	let partials: [String]
	
	func run<T: MutableBinarySearchTreeType where T.Element == Int>(tree: T, total: Int, source: BinarySearchTreeBenchmarkSource, delegate: BinarySearchTreeBenchmarkDelegate) {
		delegate.update(0, string: "Preparing Sequence")
        var tree = tree
        var source = source
		var sequence = [Int]()
		for _ in 1...total {
			sequence.append(source.next())
		}
		delegate.update(0, string: "Initializing…")
		let initialize = NSDate.timeIntervalSinceReferenceDate()
		tree = (source.isSorted) ? T(sortedSequence: sequence) : T(sequence: sequence)
		delegate.done(0, total: total, seconds: NSDate.timeIntervalSinceReferenceDate() - initialize)
		
		tree = T()
		let insert = NSDate.timeIntervalSinceReferenceDate()
		for i in 1...total {
			if i % 1000 == 0 {
				delegate.progress(1, current: i, total: total)
			}
			tree.insertInPlace(source.next())
		}
		delegate.done(1, total: total, seconds: NSDate.timeIntervalSinceReferenceDate() - insert)
		
		let search = NSDate.timeIntervalSinceReferenceDate()
		for i in 1...total {
			if i % 1000 == 0 {
				delegate.progress(2, current: i, total: total)
			}
			tree.contains(source.next())
		}
		delegate.done(2, total: total, seconds: NSDate.timeIntervalSinceReferenceDate() - search)
		
		let remove = NSDate.timeIntervalSinceReferenceDate()
		for i in 1...total {
			if i % 1000 == 0 {
				delegate.progress(3, current: i, total: total)
			}
			tree.removeInPlace(source.next())
		}
		delegate.done(3, total: total, seconds: NSDate.timeIntervalSinceReferenceDate() - remove)
	}
}
