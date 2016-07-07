//
//  AVLTree.swift
//  Forest
//
//  Created by Vincent Esche on 2/12/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

public enum AVLTree<E: Comparable>: MutableBinarySearchTreeType {
	
	public typealias Element = E
		
	case Leaf
	indirect case Branch(AVLTree, Element, AVLTree, Int8)
 	
	public var height: Int8 {
		return extendedAnalysis({ _, _, _, h in h }, leaf: { 0 })
	}
	
	public init() {
		self = .Leaf
	}
	
	public init(_ element: Element) {
		self.init(.Leaf, element, .Leaf)
	}
	
	public init(_ left: AVLTree, _ element: Element, _ right: AVLTree) {
		let height = max(left.height, right.height) + 1
		self = .Branch(left, element, right, height)
	}

	public init<S: SequenceType where S.Generator.Element == Element>(sortedSequence: S) {
		self = AVLTree(sortedArraySlice: ArraySlice(sortedSequence))
	}
	
	private init(sortedArraySlice slice: ArraySlice<Element>) {
		let range = slice.startIndex..<slice.endIndex
		if let (less, index, greater) = range.bisect() {
			let left = (less.isEmpty) ? AVLTree() : AVLTree(sortedArraySlice: slice[less])
			let right = (greater.isEmpty) ? AVLTree() : AVLTree(sortedArraySlice: slice[greater])
			self = AVLTree(left, slice[index], right)
		} else {
			self = AVLTree()
		}
	}
	
	public func insertAndReturnExisting(element: Element) -> (AVLTree, Element?) {
		return analysis({ l, e, r in
			if element < e {
				let (subtree, inserted) = l.insertAndReturnExisting(element)
				return (AVLTree(subtree, e, r).rebalance(), inserted)
			} else if element > e {
				let (subtree, inserted) = r.insertAndReturnExisting(element)
				return (AVLTree(l, e, subtree).rebalance(), inserted)
			} else {
				return (AVLTree(l, element, r), e)
			}
		}, leaf: {
			(AVLTree(.Leaf, element, .Leaf), nil)
		})
	}
	
	public func removeAndReturnExisting(element: Element) -> (AVLTree, Element?) {
		return analysis({ l, e, r in
			if element < e {
				let (subtree, removed) = l.removeAndReturnExisting(element)
				return (AVLTree(subtree, e, r).rebalance(), removed)
			} else if element > e {
				let (subtree, removed) = r.removeAndReturnExisting(element)
				return (AVLTree(l, e, subtree).rebalance(), removed)
			} else {
				return self.remove()
			}
		}, leaf: {
			(self, nil)
		})
	}
	
	public func remove() -> (AVLTree, Element?) {
		switch self {
		case .Leaf:
			return (self, nil)
		case let .Branch(.Leaf, e, .Leaf, _):
			return (.Leaf, e)
		case let .Branch(.Leaf, e, r, _):
			return (r, e)
		case let .Branch(l, e, .Leaf, _):
			return (l, e)
		case let .Branch(l, e, r, _):
			let leftMax = l.rightmostBranch()
			let subtree = l.remove(leftMax.element!)
			return (AVLTree(subtree, leftMax.element!, r), e)
		}
	}

	public func rebalance(tolerance: Int = 1) -> AVLTree {
		let t = tolerance // inbalance tolerance
		switch self {
		case let .Branch(.Branch(.Branch(ll, le, lr, llh), e, rl, lh), re, rr, _) where (lh > rr.height + t) && (llh > rl.height + t):
			return AVLTree(AVLTree(ll, le, lr), e, AVLTree(rl, re, rr)) // right rotation
		case let .Branch(ll, le, .Branch(lr, e, .Branch(rl, re, rr, rrh), rh), _) where (rh > ll.height + t) && (rrh > lr.height + t):
			return AVLTree(AVLTree(ll, le, lr), e, AVLTree(rl, re, rr)) // left rotation
		case let .Branch(.Branch(ll, le, .Branch(lr, e, rl, lrh), lh), re, rr, _) where (lh > rr.height + t) && (lrh > ll.height + t):
			return AVLTree(AVLTree(ll, le, lr), e, AVLTree(rl, re, rr)) // right left rotation
		case let .Branch(ll, le, .Branch(.Branch(lr, e, rl, rlh), re, rr, rh), _) where (rh > ll.height + t) && (rlh > rr.height + t):
			return AVLTree(AVLTree(ll, le, lr), e, AVLTree(rl, re, rr)) // left right rotation
		default:
			return self
		}
	}
	
	public func analysis<U>(@noescape branch: (AVLTree, Element, AVLTree) -> U, @noescape leaf: () -> U) -> U {
		switch self {
		case let .Branch(l, e, r, _):
			return branch(l, e, r)
		case .Leaf:
			return leaf()
		}
	}
	
	public func extendedAnalysis<U>(@noescape branch: (AVLTree, Element, AVLTree, Int8) -> U, @noescape leaf: () -> U) -> U {
		switch self {
		case let .Branch(l, e, r, h):
			return branch(l, e, r, h)
		case .Leaf:
			return leaf()
		}
	}
}

extension AVLTree {
	public var debugDescription: String {
		return self.recursiveDescription {
			return $0.analysis({ _, e, _ in
				"\(e) @ \(self.height)"
			}, leaf: {
				"nil @ \(self.height)"
			})
		}
	}
}

public func ==<E: Equatable>(lhs: AVLTree<E>, rhs: AVLTree<E>) -> Bool {
	switch (lhs, rhs) {
	case let (.Branch(l1, e1, r1, h1), .Branch(l2, e2, r2, h2)):
		return (h1 == h2) && (e1 == e2) && (l1 == l2) && (r1 == r2)
	case (.Leaf, .Leaf):
		return true
	default:
		return false
	}
}
