//
//  RBTree.swift
//  Forest
//
//  Created by Vincent Esche on 2/4/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

public enum RBTreeColor {
	case Red, Black
}

public enum RBTree<E: Comparable>: MutableBinarySearchTreeType {
	
	public typealias Element = E
	
	case Leaf
	indirect case Branch(RBTree, Element, RBTree, RBTreeColor)
 
	public var color: RBTreeColor {
		return extendedAnalysis({ _, _, _, color in color }, leaf: { .Black })
	}
	
	public init() {
		self = .Leaf
	}
	
	public init(_ element: Element) {
		self.init(.Leaf, element, .Leaf, .Red)
	}
	
	public init(_ left: RBTree, _ element: Element, _ right: RBTree, _ color: RBTreeColor) {
		self = .Branch(left, element, right, color)
	}
	
	public init<S: SequenceType where S.Generator.Element == Element>(sortedSequence: S) {
		self = RBTree(sortedArraySlice: ArraySlice(sortedSequence), color: .Black)
	}
	
	private init(sortedArraySlice slice: ArraySlice<Element>, color: RBTreeColor) {
		let range = Range(start: slice.startIndex, end: slice.endIndex)
		if let (less, index, greater) = range.bisect() {
			let leftColor: RBTreeColor = (less.count > greater.count) ? .Red : .Black
			let rightColor: RBTreeColor = (less.count < greater.count) ? .Red : .Black
			let left = (less.isEmpty) ? RBTree() : RBTree(sortedArraySlice: slice[less], color: leftColor)
			let right = (greater.isEmpty) ? RBTree() : RBTree(sortedArraySlice: slice[greater], color: rightColor)
			self = RBTree(left, slice[index], right, color)
		} else {
			self = RBTree()
		}
	}
	
	public func insertAndReturnExisting(element: Element) -> (RBTree, Element?) {
		let (tree, existing) = self.insertInSubtreeAndReturnExisting(element)
		switch tree {
		case let .Branch(l, e, r, _):
			return (RBTree(l, e, r, .Black), existing)
		default:
			return (tree, existing)
		}
	}
	
	private func insertInSubtreeAndReturnExisting(element: Element) -> (RBTree, Element?) {
		return extendedAnalysis({ l, e, r, c in
			if element < e {
				let (subtree, inserted) = l.insertInSubtreeAndReturnExisting(element)
				return (RBTree(subtree, e, r, c).rebalance(), inserted)
			} else if element > e {
				let (subtree, inserted) = r.insertInSubtreeAndReturnExisting(element)
				return (RBTree(l, e, subtree, c).rebalance(), inserted)
			} else {
				return (RBTree(l, element, r, c), e)
			}
		}, leaf: {
			(RBTree(.Leaf, element, .Leaf, .Red), nil)
		})
	}
	
	public func removeAndReturnExisting(element: Element) -> (RBTree, Element?) {
		let (tree, existing) = self.removeFromSubtreeAndReturnExisting(element)
		switch tree {
		case let .Branch(l, e, r, _):
			return (RBTree(l, e, r, .Black), existing)
		default:
			return (tree, existing)
		}
	}
	
	private func removeFromSubtreeAndReturnExisting(element: Element) -> (RBTree, Element?) {
		return extendedAnalysis({ l, e, r, c in
			if element < e {
				let (subtree, removed) = l.removeFromSubtreeAndReturnExisting(element)
				return (RBTree(subtree, e, r, c).rebalance(), removed)
			} else if element > e {
				let (subtree, removed) = r.removeFromSubtreeAndReturnExisting(element)
				return (RBTree(l, e, subtree, c).rebalance(), removed)
			} else {
				return self.remove()
			}
		}, leaf: {
			(self, nil)
		})
	}
	
	public func remove() -> (RBTree, Element?) {
		switch self {
		case .Leaf:
			return (self, nil)
		case let .Branch(.Leaf, e, .Leaf, _):
			return (.Leaf, e)
		case let .Branch(.Leaf, e, r, _):
			return (r, e)
		case let .Branch(l, e, .Leaf, _):
			return (l, e)
		case let .Branch(l, e, r, c):
			let leftMax = l.rightmostBranch()
			let subtree = l.remove(leftMax.element!)
			return (RBTree(subtree, leftMax.element!, r, c), e)
		}
	}
	
	public func rebalance() -> RBTree {
		switch self {
		case let .Branch(.Branch(.Branch(ll, le, lr, .Red), e, rl, .Red), re, rr, .Black):
			return .Branch(.Branch(ll, le, lr, .Black), e, .Branch(rl, re, rr, .Black), .Red) // right rotation
		case let .Branch(ll, le, .Branch(lr, e, .Branch(rl, re, rr, .Red), .Red), .Black):
			return .Branch(.Branch(ll, le, lr, .Black), e, .Branch(rl, re, rr, .Black), .Red) // left rotation
		case let .Branch(.Branch(ll, le, .Branch(lr, e, rl, .Red), .Red), re, rr, .Black):
			return .Branch(.Branch(ll, le, lr, .Black), e, .Branch(rl, re, rr, .Black), .Red) // right left rotation
		case let .Branch(ll, le, .Branch(.Branch(lr, e, rl, .Red), re, rr, .Red), .Black):
			return .Branch(.Branch(ll, le, lr, .Black), e, .Branch(rl, re, rr, .Black), .Red) // left right rotation
		default:
			return self
		}
	}
	
	public func isValid() -> Bool {
		return extendedAnalysis({ _, _, _, color in
			return (color == .Black) && self.checkSubtree().0
		}, leaf: {
			return true
		})
	}
	
	public func checkSubtree() -> (Bool, Int) {
		switch self {
		case .Branch(.Branch(_, _, _, .Red), _, .Branch(_, _, _, .Red), .Red):
			print("Invalid: A red node must have black children.")
			return (false, -1)
		case let .Branch(l, e, r, c):
			let blackCount = (c == .Black) ? 1 : 0
			let (leftValid, leftBlackCount) = l.checkSubtree()
			let (rightValid, rightBlackCount) = r.checkSubtree()
			if !leftValid || !rightValid || (leftBlackCount != rightBlackCount) {
				return (false, -1)
			}
			if let le = l.element, re = r.element where le >= e && re <= e {
				print("Invalid: Elements not ordered.")
				return (false, -1)
			}
			return (leftBlackCount == rightBlackCount, blackCount + rightBlackCount)
		case .Leaf:
			return (true, 1)
		}
	}
	
	public func analysis<U>(@noescape branch: (RBTree, Element, RBTree) -> U, @noescape leaf: () -> U) -> U {
		switch self {
		case let .Branch(l, e, r, _):
			return branch(l, e, r)
		case .Leaf:
			return leaf()
		}
	}
	
	public func extendedAnalysis<U>(@noescape branch: (RBTree, Element, RBTree, RBTreeColor) -> U, @noescape leaf: () -> U) -> U {
		switch self {
		case let .Branch(l, e, r, c):
			return branch(l, e, r, c)
		case .Leaf:
			return leaf()
		}
	}
}

extension RBTree {
	public var debugDescription: String {
		return self.recursiveDescription {
			return $0.extendedAnalysis( { _, e, _, c in
				let color = (c == .Red) ? "red" : "black"
				return "\(e) (\(color))"
			}, leaf: {
				"nil (black)"
			})
		}
	}
}

public func ==<E: Equatable>(lhs: RBTree<E>, rhs: RBTree<E>) -> Bool {
	switch (lhs, rhs) {
	case let (.Branch(l1, e1, r1, _), .Branch(l2, e2, r2, _)):
		return (e1 == e2) && (l1 == l2) && (r1 == r2)
	case (.Leaf, .Leaf):
		return true
	default:
		return false
	}
}

