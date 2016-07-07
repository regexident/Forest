//
//  BinarySearchTreeType.swift
//  Forest
//
//  Created by Vincent Esche on 7/26/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

public protocol BinarySearchTreeType : BinaryTreeType, ArrayLiteralConvertible {
	associatedtype Element :	Comparable
	
	init<S: SequenceType where S.Generator.Element == Element>(sortedSequence: S)
}

extension BinarySearchTreeType {
	public init<S: SequenceType where S.Generator.Element == Element>(sequence: S) {
		self.init(sortedSequence: sequence.sort())
	}
	
	public init(arrayLiteral elements: Element...) {
		self.init(sequence: elements)
	}
	
	final public mutating func clearInPlace() {
		self = self.clear()
	}

	final public func searchFor(element: Element, @noescape closure: (Self, BinaryTreeStepType) -> ()) {
		analysis({ l, e, r in
			if element < e {
				closure(l, .LeftBranch)
				return l.searchFor(element, closure: closure)
			} else if element > e {
				closure(r, .LeftBranch)
				return r.searchFor(element, closure: closure)
			} else {
				return
			}
		}, leaf: {
			return
		})
	}
	
	final public func get(element: Element) -> Element? {
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
	
	final public func contains(element: Element) -> Bool {
		return self.get(element) != nil
	}
}