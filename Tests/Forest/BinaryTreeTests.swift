//
//  BinaryTreeTests.swift
//  ForestTests
//
//  Created by Vincent Esche on 2/4/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

import Quick
import Nimble

import Forest

class BinaryTreeTests: QuickSpec {
	
	static func assembleBinaryTree(array: [NSObject]) -> BinaryTree<Int> {
		typealias Tree = BinaryTree<Int>
		let tree: Tree
		switch array.count {
		case 1:
			let element = array[0] as! Int
			tree = Tree(Tree(), element, Tree())
		case 2:
			if array[0] is Int {
				let element = array[0] as! Int
				let right = assembleBinaryTree(array[1] as! [NSObject])
				tree = Tree(Tree(), element, right)
			} else {
				let left = assembleBinaryTree(array[0] as! [NSObject])
				let element = array[1] as! Int
				tree = Tree(left, element, Tree())
			}
		case 3:
			let left = assembleBinaryTree(array[0] as! [NSObject])
			let element = array[1] as! Int
			let right = assembleBinaryTree(array[2] as! [NSObject])
			tree = Tree(left, element, right)
		default:
			tree = Tree()
		}
		return tree
	}
	
	override func spec() {
		self.describe_creatingWithNil()
		self.describe_creatingWithNilElementNil()
		self.describe_creatingWithChildElementNil()
		self.describe_creatingWithNilElementChild()
		self.describe_creatingWithChildElementChild()
	}
	
	func describe_creatingWithNil() {
		typealias Tree = BinaryTree<Int>
		describe("Creating BinaryTree of pattern") {
			context("(nil)") {
				let testTree = BinaryTreeTests.assembleBinaryTree([ ])
//				┌─ 
				let tree = Tree()
				it("it matches expected shape") {
					expect(tree).to(equal(testTree))
				}
				it("its element is nil") {
					expect(tree.element).to(beNil())
				}
				it("its left is nil") {
					expect(tree.left).to(beNil())
				}
				it("its right is nil") {
					expect(tree.right).to(beNil())
				}
				it("its height is 0") {
					expect(tree.height).to(equal(0))
				}
				it("its count is 0") {
					expect(tree.count).to(equal(0))
				}
			}
		}
	}
	
	func describe_creatingWithNilElementNil() {
		typealias Tree = BinaryTree<Int>
		describe("Creating BinaryTree of pattern") {
			context("(nil, element, nil)") {
				let testTree = BinaryTreeTests.assembleBinaryTree([ 1 ])
//				┌─ 1
				
				let tree = Tree(1)
				it("it matches expected shape") {
					expect(tree).to(equal(testTree))
				}
				it("its element is nil") {
					expect(tree.element).to(equal(1))
				}
				it("its left is nil") {
					expect(tree.left).to(beNil())
				}
				it("its right is nil") {
					expect(tree.right).to(beNil())
				}
				it("its height is 0") {
					expect(tree.height).to(equal(1))
				}
				it("its count is 1") {
					expect(tree.count).to(equal(1))
				}
			}
		}
	}
	
	func describe_creatingWithChildElementNil() {
		typealias Tree = BinaryTree<Int>
		describe("Creating BinaryTree of pattern") {
			context("(child, element, nil)") {
				let testTree = BinaryTreeTests.assembleBinaryTree([ [ 1 ], 2 ])
//				┌─ 2
//				│  └─ 1
				
				let tree = Tree(Tree(1), 2, Tree())
				it("it matches expected shape") {
					expect(tree).to(equal(testTree))
				}
				it("its element is nil") {
					expect(tree.element).to(equal(2))
				}
				it("its left is not nil") {
					expect(tree.left).toNot(beNil())
				}
				it("its right is nil") {
					expect(tree.right).to(beNil())
				}
				it("its height is 0") {
					expect(tree.height).to(equal(2))
				}
				it("its count is 2") {
					expect(tree.count).to(equal(2))
				}
			}
		}
	}
	
	func describe_creatingWithNilElementChild() {
		typealias Tree = BinaryTree<Int>
		describe("Creating BinaryTree of pattern") {
			context("(nil, element, child)") {
				let testTree = BinaryTreeTests.assembleBinaryTree([ 1, [ 2 ] ])
//				   ┌─ 2
//				┌─ 1
				
				let tree = Tree(Tree(), 1, Tree(2))
				it("it matches expected shape") {
					expect(tree).to(equal(testTree))
				}
				it("its element is nil") {
					expect(tree.element).to(equal(1))
				}
				it("its left is nil") {
					expect(tree.left).to(beNil())
				}
				it("its right is not nil") {
					expect(tree.right).toNot(beNil())
				}
				it("its height is 0") {
					expect(tree.height).to(equal(2))
				}
				it("its count is 2") {
					expect(tree.count).to(equal(2))
				}
			}
		}
	}
	
	func describe_creatingWithChildElementChild() {
		typealias Tree = BinaryTree<Int>
		describe("Creating BinaryTree of pattern") {
			context("(child, element, child)") {
				let testTree = BinaryTreeTests.assembleBinaryTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = Tree(Tree(1), 2, Tree(3))
				it("it matches expected shape") {
					expect(tree).to(equal(testTree))
				}
				it("its element is nil") {
					expect(tree.element).to(equal(2))
				}
				it("its left is not nil") {
					expect(tree.left).toNot(beNil())
				}
				it("its right is not nil") {
					expect(tree.right).toNot(beNil())
				}
				it("its height is 0") {
					expect(tree.height).to(equal(2))
				}
				it("its count is 3") {
					expect(tree.count).to(equal(3))
				}
			}
		}
	}
}