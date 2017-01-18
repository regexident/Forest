//
//  BinaryTreeTraversal.swift
//  Forest
//
//  Created by Vincent Esche on 7/26/15.
//  Copyright © 2015 Vincent Esche. All rights reserved.
//

public struct BinaryTreeTraversal<T: BinaryTreeType> {
	public typealias Tree = T
	
	public let skipLeafs: Bool
	
	public init(skipLeafs: Bool = true) {
		self.skipLeafs = skipLeafs
	}
	
	public func preorder(_ tree: Tree, closure: @escaping (Tree) -> ()) {
		tree.analysis({ (l, e, r) -> Void in
			closure(tree)
			self.preorder(l, closure: closure)
			self.preorder(r, closure: closure)
		}, leaf: {
			if !self.skipLeafs {
				closure(tree)
			}
		})
	}
	
	public func inorder(_ tree: Tree, closure: @escaping (Tree) -> ()) {
		tree.analysis({ (l, e, r) -> Void in
			self.inorder(l, closure: closure)
			closure(tree)
			self.inorder(r, closure: closure)
		}, leaf: {
			if !self.skipLeafs {
				closure(tree)
			}
		})
	}
	
	public func postorder(_ tree: Tree, closure: @escaping (Tree) -> ()) {
		tree.analysis({ (l, e, r) -> Void in
			self.postorder(l, closure: closure)
			self.postorder(r, closure: closure)
			closure(tree)
		}, leaf: {
			if !self.skipLeafs {
				closure(tree)
			}
		})
	}
}
