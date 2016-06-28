//
//  KDTreeTests.swift
//  Forest
//
//  Created by Vincent Esche on 9/8/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

import Quick
import Nimble

import Forest

class KDTreeTests: BinaryTreeTests {
	
	override func spec() {
		super.spec()
		
		self.describe_KDTree()
	}
	
	func generatePointCloud(count: Int) -> [KDPoint] {
		var points = [KDPoint]()
		srand(UInt32(time(nil)))
		for _ in 0..<count {
			let x = (Double(rand()) / Double(RAND_MAX)) * 2.0 - 1.0
			let y = (Double(rand()) / Double(RAND_MAX)) * 2.0 - 1.0
			points.append(KDPoint(coordinates: [x, y]))
		}
		return points
	}
	
	func describe_KDTree() {
		typealias Tree = KDTree<KDPoint>
		describe("Creating KDTree") {
			context("from empty sequence") {
				let points = self.generatePointCloud(1000)
				let tree = Tree(sequence: points)
//				print("tree:")
//				debugPrint(tree)
//				let nearest = tree.nearest(KDPoint(x: 0.51, y: 0.49))
//				print("nearest: \(nearest)")
				
				let rect = KDRect(coordinates: [0.0, 0.0], extents: [0.125, 0.125])
				tree.within(rect) { element in print(element) }
			}
		}
		
	}
}