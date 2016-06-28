//
//  ShrinkableBinarySearchTreeType.swift
//  Forest
//
//  Created by Vincent Esche on 7/26/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

public protocol ShrinkableBinarySearchTreeType : BinarySearchTreeType {
	func removeAndReturnExisting(element: Element) -> (Self, Element?)
}

extension ShrinkableBinarySearchTreeType {
	final public func remove(element: Element) -> Self {
		return self.removeAndReturnExisting(element).0
	}
	
	final public mutating func removeInPlace(element: Element) -> Element? {
		let removedElement: Element?
		(self, removedElement) = self.removeAndReturnExisting(element)
		return removedElement
	}
}