//
//  ViewController.swift
//  ForestBenchmark
//
//  Created by Vincent Esche on 15/02/2017.
//  Copyright © 2017 Regexident. All rights reserved.
//

import Cocoa

import Forest

class ViewController: NSViewController {

    let treeDelegate = BinarySearchTreeBenchmarkDelegate()
    let queue = OperationQueue()

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

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async {
            print("AVLTree:")
            self.startBenchmarks(treeType: AVLTree<Int>.self)
            print()

            print("RBTree:")
            self.startBenchmarks(treeType: RBTree<Int>.self)
            print()
        }
    }

    func startBenchmarks<T: MutableBinarySearchTreeType>(treeType: T.Type)
        where T.Element == Int {
        for (section, benchmark) in self.benchmarks.enumerated() {
            let tree = treeType.init()
            let total = 100_000
            let delegate = BinarySearchTreeBenchmarkDelegate()
            if section == 0 {
                print("  Sorted:")
                benchmark.run(
                    tree,
                    total: total,
                    source: BinarySearchTreeSortedSource(),
                    delegate: delegate
                )
            } else {
                print("  Randomized:")
                benchmark.run(
                    tree,
                    total: total,
                    source: BinarySearchTreeRandomSource(),
                    delegate: delegate
                )
            }
        }
        print("Done.")
    }
}
