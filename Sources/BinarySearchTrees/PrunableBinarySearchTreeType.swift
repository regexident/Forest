//
//  PrunableBinarySearchTreeType.swift
//  Forest
//
//  Created by Vincent Esche on 7/26/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

public protocol PrunableBinarySearchTreeType : BinarySearchTreeType {
	func removeAndReturnExisting(_ element: Element) -> (Self, Element?)
}

extension PrunableBinarySearchTreeType {
	final public func remove(_ element: Element) -> Self {
		return self.removeAndReturnExisting(element).0
	}
	
	final public mutating func removeInPlace(_ element: Element) -> Element? {
		let removedElement: Element?
		(self, removedElement) = self.removeAndReturnExisting(element)
		return removedElement
	}
}
