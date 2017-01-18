//
//  AVLTree.swift
//  Forest
//
//  Created by Vincent Esche on 2/12/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

public enum AVLTree<E: Comparable>: MutableBinarySearchTreeType {
	
	public typealias Element = E
    
	case leaf
	indirect case branch(AVLTree, Element, AVLTree, Int8)
 	
	public var height: Int8 {
		return extendedAnalysis({ _, _, _, h in h }, leaf: { 0 })
	}
	
	public init() {
		self = .leaf
	}
	
	public init(_ element: Element) {
		self.init(.leaf, element, .leaf)
	}
	
	public init(_ left: AVLTree, _ element: Element, _ right: AVLTree) {
		let height = Swift.max(left.height, right.height) + 1
		self = .branch(left, element, right, height)
	}

	public init<S: Sequence>(sortedSequence: S) where S.Iterator.Element == Element {
		self = AVLTree(sortedArraySlice: ArraySlice(sortedSequence))
	}
	
	fileprivate init(sortedArraySlice slice: ArraySlice<Element>) {
		let range = slice.startIndex..<slice.endIndex
		if let (less, index, greater) = range.bisect() {
			let left = (less.isEmpty) ? AVLTree() : AVLTree(sortedArraySlice: slice[less])
			let right = (greater.isEmpty) ? AVLTree() : AVLTree(sortedArraySlice: slice[greater])
			self = AVLTree(left, slice[index], right)
		} else {
			self = AVLTree()
		}
	}
	
	public func insertAndReturnExisting(_ element: Element) -> (AVLTree, Element?) {
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
			(AVLTree(.leaf, element, .leaf), nil)
		})
	}
	
	public func removeAndReturnExisting(_ element: Element) -> (AVLTree, Element?) {
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
		case .leaf:
			return (self, nil)
		case let .branch(.leaf, e, .leaf, _):
			return (.leaf, e)
		case let .branch(.leaf, e, r, _):
			return (r, e)
		case let .branch(l, e, .leaf, _):
			return (l, e)
		case let .branch(l, e, r, _):
			let leftMax = l.rightmostBranch()
			let subtree = l.remove(leftMax.element!)
			return (AVLTree(subtree, leftMax.element!, r), e)
		}
	}

	public func rebalance(_ tolerance: Int = 1) -> AVLTree {
		let t = tolerance // inbalance tolerance
		switch self {
		case let .branch(.branch(.branch(ll, le, lr, llh), e, rl, lh), re, rr, _) where (lh > rr.height + t) && (llh > rl.height + t):
			return AVLTree(AVLTree(ll, le, lr), e, AVLTree(rl, re, rr)) // right rotation
		case let .branch(ll, le, .branch(lr, e, .branch(rl, re, rr, rrh), rh), _) where (rh > ll.height + t) && (rrh > lr.height + t):
			return AVLTree(AVLTree(ll, le, lr), e, AVLTree(rl, re, rr)) // left rotation
		case let .branch(.branch(ll, le, .branch(lr, e, rl, lrh), lh), re, rr, _) where (lh > rr.height + t) && (lrh > ll.height + t):
			return AVLTree(AVLTree(ll, le, lr), e, AVLTree(rl, re, rr)) // right left rotation
		case let .branch(ll, le, .branch(.branch(lr, e, rl, rlh), re, rr, rh), _) where (rh > ll.height + t) && (rlh > rr.height + t):
			return AVLTree(AVLTree(ll, le, lr), e, AVLTree(rl, re, rr)) // left right rotation
		default:
			return self
		}
	}
	
	public func analysis<U>(_ branch: (AVLTree, Element, AVLTree) -> U, leaf: () -> U) -> U {
		switch self {
		case let .branch(l, e, r, _):
			return branch(l, e, r)
		case .leaf:
			return leaf()
		}
	}
	
	public func extendedAnalysis<U>(_ branch: (AVLTree, Element, AVLTree, Int8) -> U, leaf: () -> U) -> U {
		switch self {
		case let .branch(l, e, r, h):
			return branch(l, e, r, h)
		case .leaf:
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

extension AVLTree {
    public static func ==<E: Equatable>(lhs: AVLTree<E>, rhs: AVLTree<E>) -> Bool {
        switch (lhs, rhs) {
        case let (.branch(l1, e1, r1, h1), .branch(l2, e2, r2, h2)):
            return (h1 == h2) && (e1 == e2) && (l1 == l2) && (r1 == r2)
        case (.leaf, .leaf):
            return true
        default:
            return false
        }
    }
}
