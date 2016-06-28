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
			
			self.view.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: NSLayoutAttribute.Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
			self.view.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
			self.view.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: NSLayoutAttribute.Left, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0))
			self.view.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.configureView()
	}
}