//
//  DetailViewController.swift
//  ForestDemo
//
//  Created by Vincent Esche on 8/2/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	var detailItem: TreeDemo! {
		didSet {
			// Update the view.
			self.configureView()
		}
	}

	func configureView() {
		// Update the user interface for the detail item.
		if let detail = self.detailItem {
			self.title = detail.title
			
			let viewController = detail.viewController
			self.addChildViewController(viewController)
			viewController.view.translatesAutoresizingMaskIntoConstraints = false
			viewController.view.frame = self.view.bounds
			self.view.addSubview(viewController.view)
			
			self.view.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
			self.view.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: NSLayoutAttribute.bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))
			self.view.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: NSLayoutAttribute.left, relatedBy: .equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0.0))
			self.view.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: NSLayoutAttribute.right, relatedBy: .equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0.0))
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.configureView()
	}
}
