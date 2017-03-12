//
//  BinaryTree.swift
//  Forest
//
//  Created by Vincent Esche on 2/12/15.
//  Copyright (c) 2015 Vincent Esche. All rights reserved.
//

public enum BinaryTree<E: Comparable>: BinaryTreeType {
	public typealias Element = E

	case leaf
	indirect case branch(BinaryTree, Element, BinaryTree)
	
	public init() {
		self = .leaf
    }
	
	public init(_ element: Element) {
		self.init(.leaf, element, .leaf)
	}
	
	public init(_ left: BinaryTree, _ element: Element, _ right: BinaryTree) {
		self = .branch(left, element, right)
	}
	
	public func analysis<U>(branch: (BinaryTree, Element, BinaryTree) -> U, leaf: () -> U) -> U {
		switch self {
		case .leaf:
			return leaf()
		case let .branch(left, element, right):
			return branch(left, element, right)
		}
	}
}

extension BinaryTree : Equatable {
    public static func ==<E: Equatable>(lhs: BinaryTree<E>, rhs: BinaryTree<E>) -> Bool {
        switch (lhs, rhs) {
        case let (.branch(l1, e1, r1), .branch(l2, e2, r2)):
            return (e1 == e2) && (l1 == l2) && (r1 == r2)
        case (.leaf, .leaf):
            return true
        default:
            return false
        }
    }
}
