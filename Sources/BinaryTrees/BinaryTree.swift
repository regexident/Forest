//
//  BinaryTree.swift
//  Forest
//
//  Created by Vincent Esche on 2/12/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

public enum BinaryTree<E: Comparable>: BinaryTreeType {
	public typealias Element = E

	case Leaf
	indirect case Branch(BinaryTree, Element, BinaryTree)
	
	public init() {
		self = .Leaf
	}
	
	public init(_ element: Element) {
		self.init(.Leaf, element, .Leaf)
	}
	
	public init(_ left: BinaryTree, _ element: Element, _ right: BinaryTree) {
		self = .Branch(left, element, right)
	}
	
	public func analysis<U>(@noescape branch: (BinaryTree, Element, BinaryTree) -> U, @noescape leaf: () -> U) -> U {
		switch self {
		case .Leaf:
			return leaf()
		case let .Branch(left, element, right):
			return branch(left, element, right)
		}
	}
}

public func ==<E: Equatable>(lhs: BinaryTree<E>, rhs: BinaryTree<E>) -> Bool {
	switch (lhs, rhs) {
	case let (.Branch(l1, e1, r1), .Branch(l2, e2, r2)):
		return (e1 == e2) && (l1 == l2) && (r1 == r2)
	case (.Leaf, .Leaf):
		return true
	default:
		return false
	}
}
