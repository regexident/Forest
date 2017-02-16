//
//  BinarySearchTreeBenchmarkDelegate.swift
//  Forest
//
//  Created by Vincent Esche on 15/02/2017.
//  Copyright © 2017 Regexident. All rights reserved.
//

import UIKit

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
