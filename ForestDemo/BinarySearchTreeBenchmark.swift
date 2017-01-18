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
	func update(_ partial: Int, string: String) {
		DispatchQueue.main.async {
			self.labels[partial].text = string
		}
	}
	func progress(_ partial: Int, current: Int, total: Int) {
		DispatchQueue.main.async {
			self.labels[partial].text = "\(current) / \(total)"
		}
	}
	func done(_ partial: Int, total: Int, seconds: TimeInterval) {
		DispatchQueue.main.async {
			self.labels[partial].text = String(format: "%d in %.2f seconds", total, seconds)
		}
	}
}

protocol BinarySearchTreeBenchmarkType {
	func run(_ total: Int, delegate: BinarySearchTreeBenchmarkDelegate)
}

struct BinarySearchTreeBenchmark {
	let title: String
	let partials: [String]
	
	func run<T: MutableBinarySearchTreeType>(_ tree: T, total: Int, source: BinarySearchTreeBenchmarkSource, delegate: BinarySearchTreeBenchmarkDelegate) where T.Element == Int {
		delegate.update(0, string: "Preparing Sequence")
        var tree = tree
        var source = source
		var sequence = [Int]()
		for _ in 1...total {
			sequence.append(source.next())
		}
		delegate.update(0, string: "Initializing…")
		let initialize = Date.timeIntervalSinceReferenceDate
		tree = (source.isSorted) ? T(sortedSequence: sequence) : T(sequence: sequence)
		delegate.done(0, total: total, seconds: Date.timeIntervalSinceReferenceDate - initialize)
		
		tree = T()
		let insert = Date.timeIntervalSinceReferenceDate
		for i in 1...total {
			if i % 1000 == 0 {
				delegate.progress(1, current: i, total: total)
			}
			let _ = tree.insertInPlace(source.next())
		}
		delegate.done(1, total: total, seconds: Date.timeIntervalSinceReferenceDate - insert)
		
		let search = Date.timeIntervalSinceReferenceDate
		for i in 1...total {
			if i % 1000 == 0 {
				delegate.progress(2, current: i, total: total)
			}
			let _ = tree.contains(source.next())
		}
		delegate.done(2, total: total, seconds: Date.timeIntervalSinceReferenceDate - search)
		
		let remove = Date.timeIntervalSinceReferenceDate
		for i in 1...total {
			if i % 1000 == 0 {
				delegate.progress(3, current: i, total: total)
			}
			let _ = tree.removeInPlace(source.next())
		}
		delegate.done(3, total: total, seconds: Date.timeIntervalSinceReferenceDate - remove)
	}
}
