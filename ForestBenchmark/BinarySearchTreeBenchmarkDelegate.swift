//
//  BinarySearchTreeBenchmarkDelegate.swift
//  Forest
//
//  Created by Vincent Esche on 15/02/2017.
//  Copyright © 2017 Regexident. All rights reserved.
//

import AppKit

struct BinarySearchTreeBenchmarkDelegate {
    let partials = ["Initialize", "Insert", "Search", "Remove"]

    func update(_ partial: Int, string: String) {}
    func progress(_ partial: Int, current: Int, total: Int) {}
    func done(_ partial: Int, total: Int, seconds: TimeInterval) {
        let string = String(format: "%d in %.2f seconds", total, seconds)
        print("    \(self.partials[partial]): \(string)")
    }
}
