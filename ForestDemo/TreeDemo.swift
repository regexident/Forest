//
//  TreeDemo.swift
//  Forest
//
//  Created by Vincent Esche on 8/2/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

import UIKit

struct TreeDemo {
	let title: String
	let viewController: UIViewController
}

class BenchmarksCell: UITableViewCell {
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var progressView: UIProgressView!
	@IBOutlet var progressLabel: UILabel!
}