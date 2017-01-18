//
//  AVLTreeTests.swift
//  ForestTests
//
//  Created by Vincent Esche on 2/4/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

import Quick
import Nimble

import Forest

class AVLTreeTests: BinaryTreeTests {

	static func assembleAVLTree(_ array: [Any]) -> AVLTree<Int> {
		typealias Tree = AVLTree<Int>
		
		let tree: Tree
		switch array.count {
		case 1:
			let element = array[0] as! Int
			tree = Tree(Tree(), element, Tree())
		case 2:
			if array[0] is Int {
				let element = array[0] as! Int
				let right = assembleAVLTree(array[1] as! [Any])
				tree = Tree(Tree(), element, right)
			} else {
				let left = assembleAVLTree(array[0] as! [Any])
				let element = array[1] as! Int
				tree = Tree(left, element, Tree())
			}
		case 3:
			let left = assembleAVLTree(array[0] as! [Any])
			let element = array[1] as! Int
			let right = assembleAVLTree(array[2] as! [Any])
			tree = Tree(left, element, right)
		default:
			tree = Tree()
		}
		return tree
	}
	
	override func spec() {
		super.spec()
		
		self.describe_creatingWithSequence()
		self.describe_noRotation()
		self.describe_leftRotation()
		self.describe_rightRotation()
		self.describe_leftRightRotation()
		self.describe_rightLeftRotation()
		self.describe_insert()
		self.describe_remove()
	}
	
	func describe_creatingWithSequence() {
		typealias Tree = AVLTree<Int>
		describe("Creating AVLTree") {
			context("from sequence") {
				let testTree = AVLTreeTests.assembleAVLTree([ [ [ 1], 2 ], 3, [ [ 4 ], 5 ] ])
//				   ┌─ 5
//				   │  └─ 4
//				┌─ 3
//				│  └─ 2
//				│     └─ 1
				
				let tree = Tree(sequence: [1, 2, 3, 4, 5])
				it("it matches expected shape") {
					expect(tree).to(equal(testTree))
				}
			}
		}
	}
	
	func describe_noRotation() {
		typealias Tree = AVLTree<Int>
		describe("Calling rebalance()") {
			context("on a balanced tree") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.rebalance(0)
				it("it remains unchanged") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_leftRotation() {
		typealias Tree = AVLTree<Int>
		describe("Calling rebalance()") {
			context("on an unbalanced right-right-heavy tree") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ 1, [ 2, [ 3 ] ] ])
//					  ┌─ 3
//				   ┌─ 2
//				┌─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.rebalance(0)
				it("it matches expected (balanced) shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_rightRotation() {
		typealias Tree = AVLTree<Int>
		describe("Calling rebalance()") {
			context("on an unbalanced left-left-heavy tree") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ [ [ 1 ], 2 ], 3 ])
//				┌─ 3
//				│  └─ 2
//				│     └─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1

				let tree = treeBefore.rebalance(0)
				it("it matches expected (balanced) shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_leftRightRotation() {
		typealias Tree = AVLTree<Int>
		describe("Calling rebalance()") {
			context("on an unbalanced left-right-heavy tree") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ [ 1, [ 2 ] ], 3 ])
//				┌─ 3
//				│  │  ┌─ 2
//				│  └─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1

				let tree = treeBefore.rebalance(0)
				it("it matches expected (balanced) shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_rightLeftRotation() {
		typealias Tree = AVLTree<Int>
		describe("Calling rebalance()") {
			context("on an unbalanced left-right-heavy tree") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ 1, [ [ 2 ], 3 ] ])
//				   ┌─ 3
//				   │  └─ 2
//				┌─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.rebalance(0)
				it("it matches expected (balanced) shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_insert() {
		typealias Tree = AVLTree<Int>
		describe("Calling insert()") {
			context("on an empty tree") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ ])
//				┌─ 
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ 1 ])
//				┌─ 1
				
				let tree = treeBefore.insert(1)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("on a root-only tree") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ 1 ])
//				┌─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ 1, [ 2 ] ])
//				   ┌─ 2
//				┌─ 1
				
				let tree = treeBefore.insert(2)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("adding a right child to a left-heavy node") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ [ 1 ], 2 ])
//				┌─ 2
//				│  └─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.insert(3)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("adding a left child to a right-heavy node") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.insert(1)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("adding a right child to a right-heavy node") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ [ 1 ], 2 ])
//				┌─ 2
//				│  └─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.insert(3)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("adding a right child to a right-heavy node") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ 1, [ 2 , [ 3 ] ] ])
//				      ┌─ 3
//				   ┌─ 2
//				┌─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3, [ 4 ] ] ])
//					  ┌─ 4
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.insert(4)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("adding a left child to a left-heavy node") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ [ [ 2 ], 3 ], 4 ])
//				┌─ 4
//				│  └─ 3
//				│     └─ 2
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ [ 1 ], 2 ], 3, [ 4 ] ])
//				   ┌─ 4
//				┌─ 3
//				│  └─ 2
//				│     └─ 1
				
				let tree = treeBefore.insert(1)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("adding an existing element") {
				let treeBefore = RBTreeTests.assembleRBTree([ 1 ])
//				┌─
				
				let treeAfter = RBTreeTests.assembleRBTree([ 1 ])
//				┌─ 1
				
				let tree = treeBefore.insert(1)
				it("it remains unchanged") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_remove() {
		typealias Tree = AVLTree<Int>
		describe("Calling remove()") {
			context("on an empty tree") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ ])
//				┌─
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ ])
//				┌─
				
				let tree = treeBefore.remove(1)
				it("it remains unchanged") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("for a missing element") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ 1 ])
//				┌─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ 1 ])
//				┌─ 1
				
				let tree = treeBefore.remove(2)
				it("it remains unchanged") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("for a tree's root element") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ 1, [ 2 ] ])
//				   ┌─ 2
//				┌─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ 2 ])
//				┌─ 2
				
				let tree = treeBefore.remove(1)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("for a tree's leaf element") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ 1, [ 2 ] ])
//				   ┌─ 2
//				┌─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ 1 ])
//				┌─ 1
				
				let tree = treeBefore.remove(2)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("for a tree's branch with one child") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ [ 3 ], 4 ] ])
//				   ┌─ 4
//				   │  └─ 3
//				┌─ 2
//				│  └─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.remove(4)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("for a tree's branch with two children") {
				let treeBefore = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ [ 3 ], 4, [ 5 ] ] ])
//					  ┌─ 5
//				   ┌─ 4
//				   │  └─ 3
//				┌─ 2
//				│  └─ 1
				
				let treeAfter = AVLTreeTests.assembleAVLTree([ [ 1 ], 2, [ 3, [ 5 ] ] ])
//					  ┌─ 5
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.remove(4)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
}
