//
//  GrowableBinarySearchTreeType.swift
//  Forest
//
//  Created by Vincent Esche on 7/26/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

public protocol GrowableBinarySearchTreeType : BinarySearchTreeType {
	func insertAndReturnExisting(_ element: Element) -> (Self, Element?)
}

extension GrowableBinarySearchTreeType {
	final public func insert(_ element: Element) -> Self {
		return self.insertAndReturnExisting(element).0
	}
	
	final public mutating func insertInPlace(_ element: Element) -> Element? {
		let insertedElement: Element?
		(self, insertedElement) = self.insertAndReturnExisting(element)
		return insertedElement
	}
}
