//
//  RBTreeTests.swift
//  ForestTests
//
//  Created by Vincent Esche on 2/4/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

import Quick
import Nimble

import Forest

class RBTreeTests: BinaryTreeTests {
	
	static func assembleRBTree(_ array: [Any]) -> RBTree<Int> {
		typealias Tree = RBTree<Int>
		switch assembleRBTreeSubTree(array) {
        case let .branch(l, e, r, _):
			return Tree(l, e, r, .black)
		case .leaf:
			return .leaf
		}
	}
	
	static func assembleRBTreeSubTree(_ array: [Any]) -> RBTree<Int> {
		typealias Tree = RBTree<Int>
		
		let tree: Tree
		switch array.count {
		case 1:
			let element = array[0] as! Int
			tree = Tree(Tree(), element, Tree(), .red)
		case 2:
			if array[0] is Int {
				let element = array[0] as! Int
				let right = assembleRBTreeSubTree(array[1] as! [Any])
				tree = Tree(Tree(), element, right, .red)
			} else {
				let left = assembleRBTreeSubTree(array[0] as! [Any])
				let element = array[1] as! Int
				tree = Tree(left, element, Tree(), .red)
			}
		case 3:
			let left = assembleRBTreeSubTree(array[0] as! [Any])
			let element = array[1] as! Int
			let right = assembleRBTreeSubTree(array[2] as! [Any])
			tree = Tree(left, element, right, .red)
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
		self.describe_isValid()
	}
	
	func describe_creatingWithSequence() {
		typealias Tree = RBTree<Int>
		describe("Creating RBTree") {
			context("from sequence") {
				let testTree = RBTreeTests.assembleRBTree([ [ [ 1 ], 2 ], 3, [ [ 4 ], 5 ] ])
//				   ┌─ 5
//				   │  └─ 4
//				┌─ 3
//				│  └─ 2
//				│     └─ 1
				
				let tree = Tree(sequence: [1, 2, 3, 4, 5])
				
				it("it matches expected shape") {
					expect(tree).to(equal(testTree))
				}
				it("it is valid") {
					expect(tree.isValid()).to(beTrue())
				}
			}
		}
	}
	
	func describe_noRotation() {
		typealias Tree = RBTree<Int>
		describe("Calling rebalance()") {
			context("on a balanced tree") {
				let treeBefore = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.rebalance()
				it("it remains unchanged") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_leftRotation() {
		typealias Tree = RBTree<Int>
		describe("Calling rebalance()") {
			context("on an unbalanced right-right-heavy tree") {
				let treeBefore = RBTreeTests.assembleRBTree([ 1, [ 2, [ 3 ] ] ])
//					  ┌─ 3
//				   ┌─ 2
//				┌─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.rebalance()
				it("it matches expected (balanced) shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_rightRotation() {
		typealias Tree = RBTree<Int>
		describe("Calling rebalance()") {
			context("on an unbalanced left-left-heavy tree") {
				let treeBefore = RBTreeTests.assembleRBTree([ [ [ 1 ], 2 ], 3 ])
//				┌─ 3
//				│  └─ 2
//				│     └─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1

				let tree = treeBefore.rebalance()
				it("it matches expected (balanced) shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_leftRightRotation() {
		typealias Tree = RBTree<Int>
		describe("Calling rebalance()") {
			context("on an unbalanced left-right-heavy tree") {
				let treeBefore = RBTreeTests.assembleRBTree([ [ 1, [ 2 ] ], 3 ])
//				┌─ 3
//				│  │  ┌─ 2
//				│  └─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1

				let tree = treeBefore.rebalance()
				it("it matches expected (balanced) shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_rightLeftRotation() {
		typealias Tree = RBTree<Int>
		describe("Calling rebalance()") {
			context("on an unbalanced left-right-heavy tree") {
				let treeBefore = RBTreeTests.assembleRBTree([ 1, [ [ 2 ], 3 ] ])
//				   ┌─ 3
//				   │  └─ 2
//				┌─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.rebalance()
				it("it matches expected (balanced) shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_insert() {
		typealias Tree = RBTree<Int>
		describe("Calling insert()") {
			context("on an empty tree") {
				let treeBefore = RBTreeTests.assembleRBTree([ ])
//				┌─ 
				
				let treeAfter = RBTreeTests.assembleRBTree([ 1 ])
//				┌─ 1
				
				let tree = treeBefore.insert(1)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("on a root-only tree") {
				let treeBefore = RBTreeTests.assembleRBTree([ 1 ])
//				┌─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ 1, [ 2 ] ])
//				   ┌─ 2
//				┌─ 1
				
				let tree = treeBefore.insert(2)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("adding a right child to a left-heavy node") {
				let treeBefore = RBTreeTests.assembleRBTree([ [ 1 ], 2 ])
//				┌─ 2
//				│  └─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.insert(3)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("adding a left child to a right-heavy node") {
				let treeBefore = RBTreeTests.assembleRBTree([ 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.insert(1)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("adding a right child to a right-heavy node") {
				let treeBefore = RBTreeTests.assembleRBTree([ [ 1 ], 2 ])
//				┌─ 2
//				│  └─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.insert(3)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("adding a right child to a right-heavy node") {
				let treeBefore = RBTreeTests.assembleRBTree([ 1, [ 2 , [ 3 ] ] ])
//				      ┌─ 3
//				   ┌─ 2
//				┌─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ 3, [ 4 ] ] ])
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
				let treeBefore = RBTreeTests.assembleRBTree([ [ [ 2 ], 3 ], 4 ])
//				┌─ 4
//				│  └─ 3
//				│     └─ 2
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ [ 1 ], 2 ], 3, [ 4 ] ])
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
		typealias Tree = RBTree<Int>
		describe("Calling remove()") {
			context("on an empty tree") {
				let treeBefore = RBTreeTests.assembleRBTree([ ])
//				┌─
				
				let treeAfter = RBTreeTests.assembleRBTree([ ])
//				┌─
				
				let tree = treeBefore.remove(1)
				it("it remains unchanged") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("for a missing element") {
				let treeBefore = RBTreeTests.assembleRBTree([ 1 ])
//				┌─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ 1 ])
//				┌─ 1
				
				let tree = treeBefore.remove(2)
				it("it remains unchanged") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("for a tree's root element") {
				let treeBefore = RBTreeTests.assembleRBTree([ 1, [ 2 ] ])
//				   ┌─ 2
//				┌─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ 2 ])
//				┌─ 2
				
				let tree = treeBefore.remove(1)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("for a tree's leaf element") {
				let treeBefore = RBTreeTests.assembleRBTree([ 1, [ 2 ] ])
//				   ┌─ 2
//				┌─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ 1 ])
//				┌─ 1
				
				let tree = treeBefore.remove(2)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("for a tree's branch with one child") {
				let treeBefore = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ [ 3 ], 4 ] ])
//				   ┌─ 4
//				   │  └─ 3
//				┌─ 2
//				│  └─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ 3 ] ])
//				   ┌─ 3
//				┌─ 2
//				│  └─ 1
				
				let tree = treeBefore.remove(4)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
			context("for a tree's branch with two children") {
				let treeBefore = RBTreeTests.assembleRBTree([ [ 1 ], 2, [ [ 3 ], 4, [ 5 ] ] ])
//					  ┌─ 5
//				   ┌─ 4
//				   │  └─ 3
//				┌─ 2
//				│  └─ 1
				
				let treeAfter = RBTreeTests.assembleRBTree([ [ [ 1 ], 2 ], 3, [ 5 ] ])
//				   ┌─ 5
//				┌─ 3
//				│  └─ 2
//				│     └─ 1
				
				let tree = treeBefore.remove(4)
				it("it matches expected shape") {
					expect(tree).to(equal(treeAfter))
				}
			}
		}
	}
	
	func describe_isValid() {
		typealias Tree = RBTree<Int>
		describe("Calling isValid()") {
			context("on a valid tree") {
				let rrr = Tree(Tree(), 15, Tree(), .red)
				let lrl = Tree(Tree(), 4, Tree(), .red)
				
				let rl = Tree(Tree(), 8, Tree(), .black)
				let rr = Tree(Tree(), 14, rrr, .black)
				
				let ll = Tree(Tree(), 1, Tree(), .black)
				let lr = Tree(lrl, 5, Tree(), .black)
				
				let l = Tree(ll, 2, lr, .red)
				let r = Tree(rl, 11, rr, .red)
				
				let tree = Tree(l, 7, r, .black)
				
				it("it returns true") {
					expect(tree.isValid()).to(beTrue())
				}
			}
			context("on an invalid tree") {
				let lrll = Tree(Tree(), 4, Tree(), .black)
				
				let lrl = Tree(lrll, 5, Tree(), .red)
				let lrr = Tree(Tree(), 8, Tree(), .red)
				
				let ll = Tree(Tree(), 1, Tree(), .black)
				let lr = Tree(lrl, 7, lrr, .black)

				let rr = Tree(Tree(), 15, Tree(), .red)
				
				let l = Tree(ll, 2, lr, .red)
				let r = Tree(Tree(), 14, rr, .black)

				let tree = Tree(l, 11, r, .black)
//				debugPrint(tree)
				
				it("it returns false") {
					expect(tree.isValid()).to(beFalse())
				}
			}
		}
	}

}
