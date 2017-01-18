//
//  BinarySearchTreeType.swift
//  Forest
//
//  Created by Vincent Esche on 7/26/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

public enum BinaryTreeStepType {
    case root
    case leftBranch
    case rightBranch
}

public protocol BinarySearchTreeType : BinaryTreeType, ExpressibleByArrayLiteral {
	associatedtype Element :	Comparable
	
	init<S: Sequence>(sortedSequence: S) where S.Iterator.Element == Element
}

extension BinarySearchTreeType {
	public init<S: Sequence>(sequence: S) where S.Iterator.Element == Element {
		self.init(sortedSequence: sequence.sorted())
	}
	
	public init(arrayLiteral elements: Element...) {
		self.init(sequence: elements)
	}
	
	final public mutating func clearInPlace() {
		self = self.clear()
	}

	final public func searchFor(_ element: Element, closure: @escaping (Self, BinaryTreeStepType) -> ()) {
		analysis({ l, e, r in
			if element < e {
				closure(l, .leftBranch)
				return l.searchFor(element, closure: closure)
			} else if element > e {
				closure(r, .leftBranch)
				return r.searchFor(element, closure: closure)
			} else {
				return
			}
		}, leaf: {
			return
		})
	}
	
	final public func get(_ element: Element) -> Element? {
		return analysis({ l, e, r in
			if element < e {
				return l.get(element)
			} else if element > e {
				return r.get(element)
			} else {
				return e
			}
		}, leaf: {
			nil
		})
	}
	
	final public func contains(_ element: Element) -> Bool {
		return self.get(element) != nil
	}
}
