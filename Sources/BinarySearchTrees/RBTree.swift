//
//  RBTree.swift
//  Forest
//
//  Created by Vincent Esche on 2/4/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

public enum RBTreeColor {
	case red, black
}

public enum RBTree<E: Comparable>: MutableBinarySearchTreeType {
	
	public typealias Element = E
	
	case leaf
    indirect case branch(RBTree, Element, RBTree, RBTreeColor)
 
	public var color: RBTreeColor {
		return extendedAnalysis(branch: { _, _, _, color in color }, leaf: { .black })
	}
	
	public init() {
		self = .leaf
	}
	
	public init(_ element: Element) {
		self.init(.leaf, element, .leaf, .red)
	}
	
	public init(_ left: RBTree, _ element: Element, _ right: RBTree, _ color: RBTreeColor) {
		self = .branch(left, element, right, color)
	}
	
	public init<S: Sequence>(sortedSequence: S) where S.Iterator.Element == Element {
		self = RBTree(sortedArraySlice: ArraySlice(sortedSequence), color: .black)
	}
	
	fileprivate init(sortedArraySlice slice: ArraySlice<Element>, color: RBTreeColor) {
		let range = slice.startIndex..<slice.endIndex
		if let (less, index, greater) = range.bisect() {
			let leftColor: RBTreeColor = (less.count > greater.count) ? .red : .black
			let rightColor: RBTreeColor = (less.count < greater.count) ? .red : .black
			let left = (less.isEmpty) ? RBTree() : RBTree(sortedArraySlice: slice[less], color: leftColor)
			let right = (greater.isEmpty) ? RBTree() : RBTree(sortedArraySlice: slice[greater], color: rightColor)
			self = RBTree(left, slice[index], right, color)
		} else {
			self = RBTree()
		}
	}
	
	public func insertAndReturnExisting(_ element: Element) -> (RBTree, Element?) {
		let (tree, existing) = self.insertInSubtreeAndReturnExisting(element)
		switch tree {
		case let .branch(l, e, r, _):
			return (RBTree(l, e, r, .black), existing)
		default:
			return (tree, existing)
		}
	}
	
	fileprivate func insertInSubtreeAndReturnExisting(_ element: Element) -> (RBTree, Element?) {
		return extendedAnalysis(branch: { l, e, r, c in
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
			(RBTree(.leaf, element, .leaf, .red), nil)
		})
	}
	
	public func removeAndReturnExisting(_ element: Element) -> (RBTree, Element?) {
		let (tree, existing) = self.removeFromSubtreeAndReturnExisting(element)
		switch tree {
		case let .branch(l, e, r, _):
			return (RBTree(l, e, r, .black), existing)
		default:
			return (tree, existing)
		}
	}
	
	fileprivate func removeFromSubtreeAndReturnExisting(_ element: Element) -> (RBTree, Element?) {
		return extendedAnalysis(branch: { l, e, r, c in
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
		case .leaf:
			return (self, nil)
		case let .branch(.leaf, e, .leaf, _):
			return (.leaf, e)
		case let .branch(.leaf, e, r, _):
			return (r, e)
		case let .branch(l, e, .leaf, _):
			return (l, e)
		case let .branch(l, e, r, c):
			let leftMax = l.rightmostBranch()
			let subtree = l.remove(leftMax.element!)
			return (RBTree(subtree, leftMax.element!, r, c), e)
		}
	}
	
	public func rebalance() -> RBTree {
		switch self {
		case let .branch(.branch(.branch(ll, le, lr, .red), e, rl, .red), re, rr, .black):
            // right rotation:
			return .branch(.branch(ll, le, lr, .black), e, .branch(rl, re, rr, .black), .red)
		case let .branch(ll, le, .branch(lr, e, .branch(rl, re, rr, .red), .red), .black):
            // left rotation:
			return .branch(.branch(ll, le, lr, .black), e, .branch(rl, re, rr, .black), .red)
		case let .branch(.branch(ll, le, .branch(lr, e, rl, .red), .red), re, rr, .black):
            // right left rotation:
			return .branch(.branch(ll, le, lr, .black), e, .branch(rl, re, rr, .black), .red)
		case let .branch(ll, le, .branch(.branch(lr, e, rl, .red), re, rr, .red), .black):
            // left right rotation:
			return .branch(.branch(ll, le, lr, .black), e, .branch(rl, re, rr, .black), .red)
		default:
			return self
		}
	}
	
	public func isValid() -> Bool {
		return extendedAnalysis(branch: { _, _, _, color in
			return (color == .black) && self.checkSubtree().0
		}, leaf: {
			return true
		})
	}
	
	public func checkSubtree() -> (Bool, Int) {
		switch self {
		case .branch(.branch(_, _, _, .red), _, .branch(_, _, _, .red), .red):
			print("Invalid: A red node must have black children.")
			return (false, -1)
		case let .branch(l, e, r, c):
			let blackCount = (c == .black) ? 1 : 0
			let (leftValid, leftBlackCount) = l.checkSubtree()
			let (rightValid, rightBlackCount) = r.checkSubtree()
			if !leftValid || !rightValid || (leftBlackCount != rightBlackCount) {
				return (false, -1)
			}
			if let le = l.element, let re = r.element, le >= e && re <= e {
				print("Invalid: Elements not ordered.")
				return (false, -1)
			}
			return (leftBlackCount == rightBlackCount, blackCount + rightBlackCount)
		case .leaf:
			return (true, 1)
		}
	}
	
	public func analysis<U>(branch: (RBTree, Element, RBTree) -> U, leaf: () -> U) -> U {
		switch self {
		case let .branch(l, e, r, _):
			return branch(l, e, r)
		case .leaf:
			return leaf()
		}
	}
	
	public func extendedAnalysis<U>(branch: (RBTree, Element, RBTree, RBTreeColor) -> U, leaf: () -> U) -> U {
		switch self {
		case let .branch(l, e, r, c):
			return branch(l, e, r, c)
		case .leaf:
			return leaf()
		}
	}
}

extension RBTree {
	public var debugDescription: String {
		return self.recursiveDescription {
            return $0.extendedAnalysis(branch: { _, e, _, c in
				let color = (c == .red) ? "red" : "black"
				return "\(e) (\(color))"
			}, leaf: {
				"nil (black)"
			})
		}
	}
}

extension RBTree {
    public static func ==<E: Equatable>(lhs: RBTree<E>, rhs: RBTree<E>) -> Bool {
        switch (lhs, rhs) {
        case let (.branch(l1, e1, r1, _), .branch(l2, e2, r2, _)):
            return (e1 == e2) && (l1 == l2) && (r1 == r2)
        case (.leaf, .leaf):
            return true
        default:
            return false
        }
    }
}
